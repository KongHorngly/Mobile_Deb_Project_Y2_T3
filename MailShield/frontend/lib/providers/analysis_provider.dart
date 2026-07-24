import 'package:flutter/foundation.dart';
import '../models/email_model.dart';
import '../models/analysis_result_model.dart';
import '../services/api_service.dart';
import '../services/firestore_service.dart';

/// Drives the Email/Image Analysis flow: analyzing state, cancel,
class AnalysisProvider extends ChangeNotifier {
  AnalysisProvider({ApiService? apiService, FirestoreService? firestoreService})
    : _apiService = apiService ?? ApiService(),
      _firestoreService = firestoreService ?? FirestoreService();

  final ApiService _apiService;
  final FirestoreService _firestoreService;

  bool _isAnalyzing = false;
  AnalysisResultModel? _lastResult;
  String? _errorMessage;
  bool _cancelled = false;

  bool get isAnalyzing => _isAnalyzing;
  AnalysisResultModel? get lastResult => _lastResult;
  String? get errorMessage => _errorMessage;

  Future<AnalysisResultModel?> analyzeEmail(
    EmailModel email, {
    String? uidToSaveHistory,
  }) async {
    _cancelled = false;
    _isAnalyzing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _apiService.analyzeEmail(email);
      if (_cancelled) return null;

      _lastResult = result;

      if (uidToSaveHistory != null) {
        await _firestoreService.saveHistoryEntry(
          uid: uidToSaveHistory,
          title: email.senderEmail,
          result: result,
        );
        await _firestoreService.incrementScanCounts(
          uidToSaveHistory,
          isSafe: result.isSafe,
        );
      }
      return result;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isAnalyzing = false;
      notifyListeners();
    }
  }

  Future<AnalysisResultModel?> analyzeImage(
    List<int> imageBytes, {
    String? uidToSaveHistory,
    String title = 'Image scan',
  }) async {
    _cancelled = false;
    _isAnalyzing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _apiService.analyzeImage(imageBytes);
      if (_cancelled) return null;

      _lastResult = result;

      if (uidToSaveHistory != null) {
        await _firestoreService.saveHistoryEntry(
          uid: uidToSaveHistory,
          title: title,
          result: result,
        );
        await _firestoreService.incrementScanCounts(
          uidToSaveHistory,
          isSafe: result.isSafe,
        );
      }
      return result;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isAnalyzing = false;
      notifyListeners();
    }
  }

  // Called from the "cancel" button
  void cancelAnalysis() {
    _cancelled = true;
    _isAnalyzing = false;
    notifyListeners();
  }

  void reset() {
    _lastResult = null;
    _errorMessage = null;
    notifyListeners();
  }
}
