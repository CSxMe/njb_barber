import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'تم تطوير التطبيق بواسطة يوسف. شكراً!',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blueGrey.shade600,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

