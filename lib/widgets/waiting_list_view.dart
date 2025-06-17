import 'package:flutter/material.dart';

class WaitingListView extends StatelessWidget {
  final List<String> waitingList;
  final Function(String) onDelete;
  final bool isCustomerView;

  const WaitingListView({
    super.key,
    required this.waitingList,
    required this.onDelete,
    this.isCustomerView = false,
  });

  @override
  Widget build(BuildContext context) {
    if (waitingList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: Colors.blueGrey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'لا يوجد زبائن في قائمة الانتظار',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.separated(
        itemCount: waitingList.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final customerName = waitingList[index];
          final isCurrentCustomer = index == 0;
          
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: isCurrentCustomer 
                  ? Colors.green.shade100 
                  : Colors.blueGrey.shade100,
              child: Text(
                (index + 1).toString(),
                style: TextStyle(
                  color: isCurrentCustomer 
                      ? Colors.green.shade800 
                      : Colors.blueGrey.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              customerName,
              style: TextStyle(
                fontWeight: isCurrentCustomer ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: isCurrentCustomer 
                ? Text(
                    'الزبون الحالي',
                    style: TextStyle(
                      color: Colors.green.shade800,
                      fontSize: 12,
                    ),
                  ) 
                : null,
            trailing: isCustomerView ? null : IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: Colors.red.shade300,
              ),
              onPressed: () {
                // Direct delete for barber view
                onDelete(customerName);
              },
            ),
          );
        },
      ),
    );
  }
}

