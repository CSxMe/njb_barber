import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/waiting_list_provider.dart';
import '../providers/app_status_provider.dart';
import '../providers/barber_auth_provider.dart';
import '../services/hive_service.dart';

class AppInitializer {
  static Future<void> initializeApp(BuildContext context) async {
    try {
      // Initialize Hive
      await HiveService.initHive();
      
      // Initialize providers
      final waitingListProvider = Provider.of<WaitingListProvider>(context, listen: false);
      final appStatusProvider = Provider.of<AppStatusProvider>(context, listen: false);
      final barberAuthProvider = Provider.of<BarberAuthProvider>(context, listen: false);
      
      // Log initialization
      debugPrint('App initialized successfully');
    } catch (e) {
      debugPrint('Error initializing app: $e');
      // Show error dialog or snackbar
    }
  }
  
  static Future<void> resetAppData(BuildContext context) async {
    try {
      await HiveService.clearAllData();
      
      // Refresh providers
      final waitingListProvider = Provider.of<WaitingListProvider>(context, listen: false);
      final appStatusProvider = Provider.of<AppStatusProvider>(context, listen: false);
      final barberAuthProvider = Provider.of<BarberAuthProvider>(context, listen: false);
      
      // Reload data
      waitingListProvider.clearList();
      appStatusProvider.setShopStatus(true);
      barberAuthProvider.resetToDefaultPassword();
      
      debugPrint('App data reset successfully');
    } catch (e) {
      debugPrint('Error resetting app data: $e');
      // Show error dialog or snackbar
    }
  }
}

