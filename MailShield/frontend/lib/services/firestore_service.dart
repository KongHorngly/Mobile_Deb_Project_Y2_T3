import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/history_model.dart';
import '../models/analysis_result_model.dart';

/// Persists user profiles and scan history to Cloud Firestore.
/// Collections:
///   users/{uid}                -> UserModel
///   users/{uid}/history/{id}   -> HistoryItem
class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection('users');

  CollectionReference<Map<String, dynamic>> _historyOf(String uid) =>
      _users.doc(uid).collection('history');

  // ---- User profile ----

  Future<void> createUser(UserModel user) {
    return _users.doc(user.id).set(user.toJson());
  }

  Future<UserModel> getUser(String uid) async {
    final doc = await _users.doc(uid).get();
    if (!doc.exists) {
      throw StateError('User $uid not found');
    }
    return UserModel.fromJson(doc.data()!);
  }

  Future<void> incrementScanCounts(String uid, {required bool isSafe}) {
    return _users.doc(uid).update({
      'totalScan': FieldValue.increment(1),
      if (isSafe) 'safeCount': FieldValue.increment(1),
      if (!isSafe) 'suspiciousCount': FieldValue.increment(1),
    });
  }

  // ---- Scan history ----

  Future<void> saveHistoryEntry({
    required String uid,
    required String title,
    required AnalysisResultModel result,
  }) {
    final doc = _historyOf(uid).doc();
    return doc.set({
      'title': title,
      'verdictLabel': result.isSafe ? 'Safe' : 'Suspicious Detected',
      'isSafe': result.isSafe,
      'scannedAt': FieldValue.serverTimestamp(),
      'sender': result.sender,
      'subject': result.subject,
      'fileOrImageName': result.fileOrImageName,
      'senderDomainStatus': result.senderDomainStatus,
      'suspiciousWordsFound': result.suspiciousWordsFound,
      'maliciousLinksFound': result.maliciousLinksFound,
      'recommendations': result.recommendations,
    });
  }

  Stream<List<HistoryItem>> watchHistory(String uid) {
    return _historyOf(uid)
        .orderBy('scannedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return HistoryItem(
              id: doc.id,
              title: data['title'] as String? ?? '',
              verdictLabel: data['verdictLabel'] as String? ?? '',
              isSafe: data['isSafe'] as bool? ?? false,
              scannedAt:
                  (data['scannedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
              sender: data['sender'] as String?,
              subject: data['subject'] as String?,
              fileOrImageName: data['fileOrImageName'] as String?,
              senderDomainStatus: data['senderDomainStatus'] as String?,
              suspiciousWordsFound: data['suspiciousWordsFound'] as bool?,
              maliciousLinksFound: data['maliciousLinksFound'] as bool?,
              recommendations: (data['recommendations'] as List?)
                  ?.map((e) => e.toString())
                  .toList(),
            );
          }).toList(),
        );
  }

  Future<void> deleteHistoryEntry({
    required String uid,
    required String historyId,
  }) {
    return _historyOf(uid).doc(historyId).delete();
  }
}
