import 'package:flutter/material.dart';

class BarberActionButtons extends StatelessWidget {
  final VoidCallback onNextCustomer;

  const BarberActionButtons({
    super.key,
    required this.onNextCustomer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton.icon(
        onPressed: onNextCustomer,
        icon: const Icon(Icons.skip_next),
        label: const Text('الزبون التالي'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade600,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

