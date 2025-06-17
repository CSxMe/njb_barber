import 'package:flutter/material.dart';

class ShopStatusToggle extends StatelessWidget {
  final bool isShopOpen;
  final Function(bool) onToggle;

  const ShopStatusToggle({
    super.key,
    required this.isShopOpen,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isShopOpen 
                ? 'المحل مفتوح' 
                : 'المحل مغلق',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isShopOpen ? Colors.green.shade300 : Colors.red.shade300,
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: isShopOpen,
            onChanged: onToggle,
            activeColor: Colors.green,
            activeTrackColor: Colors.green.shade200,
            inactiveThumbColor: Colors.red,
            inactiveTrackColor: Colors.red.shade200,
          ),
        ],
      ),
    );
  }
}

