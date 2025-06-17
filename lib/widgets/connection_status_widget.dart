import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/waiting_list_provider.dart';
import '../providers/app_status_provider.dart';

class ConnectionStatusWidget extends StatelessWidget {
  const ConnectionStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<WaitingListProvider, AppStatusProvider>(
      builder: (context, waitingListProvider, appStatusProvider, child) {
        final isOnline = waitingListProvider.isOnline && appStatusProvider.isOnline;
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: isOnline ? Colors.green.shade100 : Colors.orange.shade100,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: isOnline ? Colors.green.shade300 : Colors.orange.shade300,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isOnline ? Icons.cloud_done : Icons.cloud_off,
                size: 16,
                color: isOnline ? Colors.green.shade700 : Colors.orange.shade700,
              ),
              const SizedBox(width: 4),
              Text(
                isOnline ? 'متصل' : 'غير متصل',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isOnline ? Colors.green.shade700 : Colors.orange.shade700,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

