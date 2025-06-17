import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BarberAuthProvider extends ChangeNotifier {
  String _password = '123'; // Default password
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;
  
  BarberAuthProvider() {
    _loadPassword();
  }

  void _loadPassword() {
    try {
      final box = Hive.box<String>('barberPassword');
      _password = box.get('password', defaultValue: '123')!;
    } catch (e) {
      debugPrint('Error loading password: $e');
      _password = '123'; // Default password if there's an error
    }
    notifyListeners();
  }

  void _savePassword() {
    try {
      Hive.box<String>('barberPassword').put('password', _password);
    } catch (e) {
      debugPrint('Error saving password: $e');
    }
  }

  bool authenticate(String inputPassword) {
    final isValid = inputPassword == _password;
    if (isValid) {
      _isAuthenticated = true;
      notifyListeners();
    }
    return isValid;
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }

  bool changePassword(String currentPassword, String newPassword) {
    if (currentPassword != _password) {
      return false; // Current password is incorrect
    }
    
    if (newPassword.isEmpty) {
      return false; // New password cannot be empty
    }
    
    _password = newPassword;
    _savePassword();
    notifyListeners();
    return true;
  }

  void resetToDefaultPassword() {
    _password = '123';
    _savePassword();
    notifyListeners();
  }
}

