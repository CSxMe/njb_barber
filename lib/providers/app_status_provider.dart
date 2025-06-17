import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/firebase_service.dart';
import 'dart:async';

class AppStatusProvider extends ChangeNotifier {
  bool _isShopOpen = true;
  StreamSubscription<bool>? _firebaseSubscription;
  bool _isOnline = true;

  bool get isShopOpen => _isShopOpen;
  bool get isOnline => _isOnline;

  AppStatusProvider() {
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
    _firebaseSubscription = FirebaseService.getShopStatusStream().listen(
      (isOpen) {
        _isShopOpen = isOpen;
        _isOnline = true;
        // Save to local cache for offline use
        _saveToLocalCache();
        notifyListeners();
      },
      onError: (error) {
        debugPrint('Error listening to Firebase shop status updates: $error');
        _isOnline = false;
        // Fallback to local cache
        _loadFromLocalCache();
      },
    );
  }

  Future<void> _loadFromLocalCache() async {
    try {
      final box = Hive.box<bool>('appStatus');
      _isShopOpen = box.get('status', defaultValue: true)!;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading shop status from local cache: $e');
      _isShopOpen = true; // Default to open if there's an error
      notifyListeners();
    }
  }

  Future<void> _saveToLocalCache() async {
    try {
      Hive.box<bool>('appStatus').put('status', _isShopOpen);
    } catch (e) {
      debugPrint('Error saving shop status to local cache: $e');
    }
  }

  Future<void> toggleShopStatus() async {
    final newStatus = !_isShopOpen;
    await setShopStatus(newStatus);
  }

  Future<void> setShopStatus(bool isOpen) async {
    try {
      _isOnline = await FirebaseService.hasInternetConnection();
      
      if (_isOnline) {
        // Update Firebase
        await FirebaseService.updateShopStatus(isOpen);
      } else {
        // Update locally and sync later
        _isShopOpen = isOpen;
        await _saveToLocalCache();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating shop status: $e');
      // Fallback to local storage
      _isShopOpen = isOpen;
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

  @override
  void dispose() {
    _firebaseSubscription?.cancel();
    super.dispose();
  }
}

