import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static Future<void> initHive() async {
    try {
      await Hive.initFlutter();
      
      // Open Hive boxes
      await Hive.openBox<List<dynamic>>('waitingList');
      await Hive.openBox<bool>('appStatus');
      await Hive.openBox<String>('barberPassword');
      
      debugPrint('Hive initialized successfully');
    } catch (e) {
      debugPrint('Error initializing Hive: $e');
      rethrow;
    }
  }
  
  static Future<void> clearAllData() async {
    try {
      await Hive.box<List<dynamic>>('waitingList').clear();
      await Hive.box<bool>('appStatus').clear();
      await Hive.box<String>('barberPassword').clear();
      
      // Reset to defaults
      await Hive.box<bool>('appStatus').put('status', true);
      await Hive.box<String>('barberPassword').put('password', '123');
      
      debugPrint('All Hive data cleared');
    } catch (e) {
      debugPrint('Error clearing Hive data: $e');
      rethrow;
    }
  }
}

