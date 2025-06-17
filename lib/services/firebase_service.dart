import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _waitingListCollection = 'waiting_list';
  static const String _shopStatusCollection = 'shop_status';
  static const String _shopId = 'main_shop'; // يمكن تغييره لدعم عدة محلات

  // Initialize Firebase
  static Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      debugPrint('Firebase initialized successfully');
    } catch (e) {
      debugPrint('Error initializing Firebase: $e');
      rethrow;
    }
  }

  // Check internet connectivity
  static Future<bool> hasInternetConnection() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      return false;
    }
  }

  // Waiting List Operations
  static Stream<List<String>> getWaitingListStream() {
    return _firestore
        .collection(_waitingListCollection)
        .doc(_shopId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()!;
        final list = data['customers'] as List<dynamic>?;
        return list?.cast<String>() ?? [];
      }
      return <String>[];
    });
  }

  static Future<void> updateWaitingList(List<String> customers) async {
    try {
      await _firestore
          .collection(_waitingListCollection)
          .doc(_shopId)
          .set({
        'customers': customers,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error updating waiting list: $e');
      rethrow;
    }
  }

  static Future<void> addCustomer(String customerName) async {
    try {
      await _firestore.runTransaction((transaction) async {
        final docRef = _firestore.collection(_waitingListCollection).doc(_shopId);
        final snapshot = await transaction.get(docRef);
        
        List<String> customers = [];
        if (snapshot.exists && snapshot.data() != null) {
          final data = snapshot.data()!;
          final list = data['customers'] as List<dynamic>?;
          customers = list?.cast<String>() ?? [];
        }
        
        // Check if customer already exists (case insensitive)
        if (!customers.any((name) => name.toLowerCase() == customerName.toLowerCase())) {
          customers.add(customerName);
          transaction.set(docRef, {
            'customers': customers,
            'lastUpdated': FieldValue.serverTimestamp(),
          });
        }
      });
    } catch (e) {
      debugPrint('Error adding customer: $e');
      rethrow;
    }
  }

  static Future<void> removeCustomer(String customerName) async {
    try {
      await _firestore.runTransaction((transaction) async {
        final docRef = _firestore.collection(_waitingListCollection).doc(_shopId);
        final snapshot = await transaction.get(docRef);
        
        if (snapshot.exists && snapshot.data() != null) {
          final data = snapshot.data()!;
          final list = data['customers'] as List<dynamic>?;
          List<String> customers = list?.cast<String>() ?? [];
          
          customers.remove(customerName);
          transaction.set(docRef, {
            'customers': customers,
            'lastUpdated': FieldValue.serverTimestamp(),
          });
        }
      });
    } catch (e) {
      debugPrint('Error removing customer: $e');
      rethrow;
    }
  }

  static Future<void> nextCustomer() async {
    try {
      await _firestore.runTransaction((transaction) async {
        final docRef = _firestore.collection(_waitingListCollection).doc(_shopId);
        final snapshot = await transaction.get(docRef);
        
        if (snapshot.exists && snapshot.data() != null) {
          final data = snapshot.data()!;
          final list = data['customers'] as List<dynamic>?;
          List<String> customers = list?.cast<String>() ?? [];
          
          if (customers.isNotEmpty) {
            customers.removeAt(0);
            transaction.set(docRef, {
              'customers': customers,
              'lastUpdated': FieldValue.serverTimestamp(),
            });
          }
        }
      });
    } catch (e) {
      debugPrint('Error moving to next customer: $e');
      rethrow;
    }
  }

  static Future<void> clearWaitingList() async {
    try {
      await _firestore
          .collection(_waitingListCollection)
          .doc(_shopId)
          .set({
        'customers': [],
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error clearing waiting list: $e');
      rethrow;
    }
  }

  // Shop Status Operations
  static Stream<bool> getShopStatusStream() {
    return _firestore
        .collection(_shopStatusCollection)
        .doc(_shopId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()!;
        return data['isOpen'] as bool? ?? true;
      }
      return true; // Default to open
    });
  }

  static Future<void> updateShopStatus(bool isOpen) async {
    try {
      await _firestore
          .collection(_shopStatusCollection)
          .doc(_shopId)
          .set({
        'isOpen': isOpen,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error updating shop status: $e');
      rethrow;
    }
  }

  // Offline support - get cached data
  static Future<List<String>> getCachedWaitingList() async {
    try {
      final snapshot = await _firestore
          .collection(_waitingListCollection)
          .doc(_shopId)
          .get(const GetOptions(source: Source.cache));
      
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()!;
        final list = data['customers'] as List<dynamic>?;
        return list?.cast<String>() ?? [];
      }
      return [];
    } catch (e) {
      debugPrint('Error getting cached waiting list: $e');
      return [];
    }
  }

  static Future<bool> getCachedShopStatus() async {
    try {
      final snapshot = await _firestore
          .collection(_shopStatusCollection)
          .doc(_shopId)
          .get(const GetOptions(source: Source.cache));
      
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()!;
        return data['isOpen'] as bool? ?? true;
      }
      return true;
    } catch (e) {
      debugPrint('Error getting cached shop status: $e');
      return true;
    }
  }
}

