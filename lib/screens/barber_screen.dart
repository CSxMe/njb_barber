import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/waiting_list_provider.dart';
import '../providers/app_status_provider.dart';
import '../widgets/waiting_list_view.dart';
import '../widgets/app_footer.dart';
import '../widgets/shop_status_toggle.dart';
import '../widgets/barber_action_buttons.dart';
import '../widgets/connection_status_widget.dart';
import 'customer_screen.dart';

class BarberScreen extends StatelessWidget {
  const BarberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final waitingList = Provider.of<WaitingListProvider>(context);
    final appStatus = Provider.of<AppStatusProvider>(context);
    final textDirection = TextDirection.rtl; // Always RTL for Arabic

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'تطبيق الحلاقة - الحلاق',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueGrey.shade800,
        foregroundColor: Colors.white,
        actions: [
          // Connection Status
          const ConnectionStatusWidget(),
          const SizedBox(width: 8),
          
          // Shop Status Toggle
          ShopStatusToggle(
            isShopOpen: appStatus.isShopOpen,
            onToggle: (value) => appStatus.toggleShopStatus(),
          ),
          
          // Logout Button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const CustomerScreen()),
              );
            },
            tooltip: 'تسجيل الخروج',
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
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.only(bottom: 20.0),
                  decoration: BoxDecoration(
                    color: appStatus.isShopOpen 
                        ? Colors.green.shade100 
                        : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: appStatus.isShopOpen 
                          ? Colors.green.shade300 
                          : Colors.red.shade300,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        appStatus.isShopOpen 
                            ? Icons.check_circle 
                            : Icons.access_time,
                        color: appStatus.isShopOpen 
                            ? Colors.green 
                            : Colors.red,
                        size: 36.0,
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          appStatus.isShopOpen 
                              ? 'المحل مفتوح وجاهز لخدمة الزبائن.' 
                              : 'المحل مغلق حالياً. سنعود قريباً!',
                          style: TextStyle(
                            fontSize: 16,
                            color: appStatus.isShopOpen 
                                ? Colors.green.shade800 
                                : Colors.red.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Waiting List Title with actions
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
                      
                      // Clear All Button
                      if (waitingList.waitingList.isNotEmpty)
                        TextButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('حذف قائمة الانتظار'),
                                content: const Text(
                                  'هل أنت متأكد من رغبتك في حذف قائمة الانتظار بالكامل؟',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('إلغاء'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      waitingList.clearList();
                                    },
                                    child: const Text(
                                      'حذف الكل',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.clear_all, size: 18),
                          label: const Text('حذف الكل'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                        ),
                    ],
                  ),
                ),

                // Waiting List
                Expanded(
                  child: WaitingListView(
                    waitingList: waitingList.waitingList,
                    onDelete: (name) => waitingList.removeCustomer(name),
                    isCustomerView: false,
                  ),
                ),

                // Action Buttons
                if (waitingList.waitingList.isNotEmpty)
                  BarberActionButtons(
                    onNextCustomer: () => waitingList.nextCustomer(),
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

