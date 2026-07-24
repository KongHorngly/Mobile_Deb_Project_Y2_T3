import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/history_model.dart';
import '../services/firestore_service.dart';

//Drives the History screen: live list, search filter, selected
//detail item, and delete
class HistoryProvider extends ChangeNotifier {
  HistoryProvider({FirestoreService? firestoreService})
    : _firestoreService = firestoreService ?? FirestoreService();

  final FirestoreService _firestoreService;
  StreamSubscription<List<HistoryItem>>? _subscription;

  List<HistoryItem> _allItems = [];
  String _searchQuery = '';
  HistoryItem? _selected;
  bool _isLoading = false;

  List<HistoryItem> get items {
    if (_searchQuery.isEmpty) return _allItems;
    final query = _searchQuery.toLowerCase();
    return _allItems
        .where((item) => item.title.toLowerCase().contains(query))
        .toList();
  }

  HistoryItem? get selected => _selected;
  bool get isLoading => _isLoading;

  void loadHistory(String uid) {
    _isLoading = true;
    notifyListeners();

    _subscription?.cancel();
    _subscription = _firestoreService.watchHistory(uid).listen((items) {
      _allItems = items;
      _isLoading = false;
      notifyListeners();
    });
  }

  void search(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void select(HistoryItem item) {
    _selected = item;
    notifyListeners();
  }

  void clearSelection() {
    _selected = null;
    notifyListeners();
  }

  Future<void> deleteSelected(String uid) async {
    if (_selected == null) return;
    await _firestoreService.deleteHistoryEntry(
      uid: uid,
      historyId: _selected!.id,
    );
    _selected = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
