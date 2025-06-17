import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'providers/waiting_list_provider.dart';
import 'providers/app_status_provider.dart';
import 'providers/barber_auth_provider.dart';
import 'screens/customer_screen.dart';
import 'services/hive_service.dart';
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for offline support
  await HiveService.initHive();
  
  // Initialize Firebase
  try {
    await FirebaseService.initializeFirebase();
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
    // Continue with offline mode
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WaitingListProvider()),
        ChangeNotifierProvider(create: (_) => AppStatusProvider()),
        ChangeNotifierProvider(create: (_) => BarberAuthProvider()),
      ],
      child: MaterialApp(
        title: 'تطبيق الحلاقة',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          fontFamily: 'Cairo',
          textTheme: const TextTheme(
            bodyMedium: TextStyle(fontSize: 16),
          ),
        ),
        locale: const Locale('ar', ''), // Force Arabic locale
        home: const CustomerScreen(),
      ),
    );
  }
}

