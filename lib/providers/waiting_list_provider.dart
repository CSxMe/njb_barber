import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/firebase_service.dart';
import 'dart:async';

class WaitingListProvider extends ChangeNotifier {
  List<String> _waitingList = [];
  StreamSubscription<List<String>>? _firebaseSubscription;
  bool _isOnline = true;

  List<String> get waitingList => _waitingList;
  bool get isOnline => _isOnline;

  WaitingListProvider() {
    _initializeProvider();
  }

  Future<void> _initializeProvider() async {
    // Check internet connectivity
    _isOnline = await FirebaseService.hasInternetConnection();
    
    if (_isOnline) {
      // Load from Firebase if online
      _subscribeToFirebaseUpdates();
    } else {
      // Load from local cache if offline
      await _loadFromLocalCache();
    }
  }

  void _subscribeToFirebaseUpdates() {
    _firebaseSubscription = FirebaseService.getWaitingListStream().listen(
      (customers) {
        _waitingList = customers;
        _isOnline = true;
        // Save to local cache for offline use
        _saveToLocalCache();
        notifyListeners();
      },
      onError: (error) {
        debugPrint('Error listening to Firebase updates: $error');
        _isOnline = false;
        // Fallback to local cache
        _loadFromLocalCache();
      },
    );
  }

  Future<void> _loadFromLocalCache() async {
    try {
      final box = Hive.box<List<dynamic>>('waitingList');
      final list = box.get('list');
      if (list != null) {
        _waitingList = List<String>.from(list);
      } else {
        _waitingList = [];
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading from local cache: $e');
      _waitingList = [];
      notifyListeners();
    }
  }

  Future<void> _saveToLocalCache() async {
    try {
      Hive.box<List<dynamic>>('waitingList').put('list', _waitingList);
    } catch (e) {
      debugPrint('Error saving to local cache: $e');
    }
  }

  Future<void> addCustomer(String name) async {
    if (name.isEmpty) return;
    
    final trimmedName = name.trim();
    
    // Check if the name already exists (case insensitive)
    if (_waitingList.any((existingName) => 
        existingName.toLowerCase() == trimmedName.toLowerCase())) {
      return; // Don't add duplicates
    }

    try {
      _isOnline = await FirebaseService.hasInternetConnection();
      
      if (_isOnline) {
        // Add to Firebase
        await FirebaseService.addCustomer(trimmedName);
      } else {
        // Add locally and sync later
        _waitingList.add(trimmedName);
        await _saveToLocalCache();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error adding customer: $e');
      // Fallback to local storage
      _waitingList.add(trimmedName);
      await _saveToLocalCache();
      notifyListeners();
    }
  }

  Future<void> removeCustomer(String name) async {
    try {
      _isOnline = await FirebaseService.hasInternetConnection();
      
      if (_isOnline) {
        // Remove from Firebase
        await FirebaseService.removeCustomer(name);
      } else {
        // Remove locally and sync later
        _waitingList.remove(name);
        await _saveToLocalCache();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error removing customer: $e');
      // Fallback to local storage
      _waitingList.remove(name);
      await _saveToLocalCache();
      notifyListeners();
    }
  }

  Future<void> nextCustomer() async {
    if (_waitingList.isEmpty) return;

    try {
      _isOnline = await FirebaseService.hasInternetConnection();
      
      if (_isOnline) {
        // Update Firebase
        await FirebaseService.nextCustomer();
      } else {
        // Update locally and sync later
        _waitingList.removeAt(0);
        await _saveToLocalCache();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error moving to next customer: $e');
      // Fallback to local storage
      if (_waitingList.isNotEmpty) {
        _waitingList.removeAt(0);
        await _saveToLocalCache();
        notifyListeners();
      }
    }
  }

  Future<void> clearList() async {
    try {
      _isOnline = await FirebaseService.hasInternetConnection();
      
      if (_isOnline) {
        // Clear Firebase
        await FirebaseService.clearWaitingList();
      } else {
        // Clear locally and sync later
        _waitingList.clear();
        await _saveToLocalCache();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error clearing list: $e');
      // Fallback to local storage
      _waitingList.clear();
      await _saveToLocalCache();
      notifyListeners();
    }
  }

  Future<void> refreshConnection() async {
    _isOnline = await FirebaseService.hasInternetConnection();
    
    if (_isOnline && _firebaseSubscription == null) {
      // Reconnect to Firebase
      _subscribeToFirebaseUpdates();
    }
    
    notifyListeners();
  }

  // For testing purposes
  void addDummyData() {
    _waitingList = ['أحمد', 'محمد', 'علي', 'يوسف', 'عمر'];
    _saveToLocalCache();
    notifyListeners();
  }

  @override
  void dispose() {
    _firebaseSubscription?.cancel();
    super.dispose();
  }
}

