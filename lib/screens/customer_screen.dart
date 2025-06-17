import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/waiting_list_provider.dart';
import '../providers/app_status_provider.dart';
import '../widgets/customer_name_input.dart';
import '../widgets/waiting_list_view.dart';
import '../widgets/app_footer.dart';
import '../widgets/connection_status_widget.dart';
import 'barber_login_screen.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appStatus = Provider.of<AppStatusProvider>(context);
    final waitingList = Provider.of<WaitingListProvider>(context);
    final textDirection = TextDirection.rtl; // Always RTL for Arabic

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'تطبيق الحلاقة - الزبون',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueGrey.shade800,
        foregroundColor: Colors.white,
        actions: [
          // Connection Status
          const ConnectionStatusWidget(),
          const SizedBox(width: 8),
          
          // Admin Login Button
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BarberLoginScreen()),
              );
            },
            tooltip: 'تسجيل دخول الحلاق',
          ),
        ],
      ),
      body: Directionality(
        textDirection: textDirection,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blueGrey.shade50,
                Colors.blueGrey.shade100,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Shop Status Banner
                if (!appStatus.isShopOpen)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.only(bottom: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.red.shade300),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.red,
                          size: 48.0,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'المحل مغلق حالياً. سنعود قريباً!',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                // Customer Input Form (only if shop is open)
                if (appStatus.isShopOpen)
                  CustomerNameInput(
                    onNameSubmitted: (name) {
                      if (name.isNotEmpty) {
                        waitingList.addCustomer(name);
                      }
                    },
                  ),

                // Waiting List Title with refresh button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.people, color: Colors.blueGrey),
                      const SizedBox(width: 8.0),
                      Text(
                        'قائمة الانتظار',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey.shade800,
                        ),
                      ),
                      const Spacer(),
                      
                      // Refresh button
                      IconButton(
                        onPressed: () async {
                          await waitingList.refreshConnection();
                          await appStatus.refreshConnection();
                        },
                        icon: const Icon(Icons.refresh),
                        tooltip: 'تحديث الاتصال',
                        color: Colors.blueGrey.shade600,
                      ),
                    ],
                  ),
                ),

                // Waiting List
                Expanded(
                  child: WaitingListView(
                    waitingList: waitingList.waitingList,
                    onDelete: (name) => waitingList.removeCustomer(name),
                    isCustomerView: true,
                  ),
                ),

                // Footer
                const AppFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

