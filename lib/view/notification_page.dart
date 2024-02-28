import 'package:flutter/material.dart';
import '../controllers/api_services.dart';
import '../models/get_notification_model.dart';
import '../widgets/custom_cart.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Result> notifications = [];
  bool isEditMode = false;
  Set<int> selectedIndexes = {};

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    var result = await ApiService.fetchNotifications(page: 1, pageSize: 5);
    setState(() {
      notifications = result;
    });
  }

  Future<void> fetchUpdateNotificationStatus(List<int> notificationIndexes) async {
    print('Updating notification status for IDs: $notificationIndexes');
    await ApiService.updateNotificationStatus(notificationIndexes, "Read");
  }

  Future<void> fetchDeleteNotificationStatus(List<int> notificationIndexes) async {
    print('Deleting notifications with IDs: $notificationIndexes');
    await ApiService.updateNotificationStatus(notificationIndexes, "Delete");
    // Remove deleted notifications from the list
    setState(() {
      notifications.removeWhere((notification) => notificationIndexes.contains(notification.id!));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text("Notification"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                // Toggle edit mode
                isEditMode = !isEditMode;

                // Clear selected indexes when exiting edit mode
                if (!isEditMode) {
                  selectedIndexes.clear();
                }
              });
            },
            icon: isEditMode
                ? Text(
              'Cancel',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            )
                : Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: notifications.map((notification) {
                  return CustomCart(
                    index: notification.id!,
                    itemName: notification.title,
                    description: notification.description,
                    date: notification.updatedAt ?? DateTime.now(),
                    readStatus: notification.readStatus,
                    isChecked: isEditMode && selectedIndexes.contains(notification.id!),
                    onCheckboxChanged: (isChecked) {
                      setState(() {
                        if (isChecked ?? false) {
                          selectedIndexes.add(notification.id!);
                        } else {
                          selectedIndexes.remove(notification.id!);
                        }
                      });
                    },
                    isEditMode: isEditMode,
                  );
                }).toList(),
              ),
            ),
            // Render the bottom container if edit mode is active
            if (isEditMode)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 80,
                  color: Colors.white,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            if (isEditMode)
                              Checkbox(
                                value: selectedIndexes.length == notifications.length,
                                onChanged: (isChecked) {
                                  setState(() {
                                    if (isChecked != null) {
                                      if (isChecked) {
                                        selectedIndexes =
                                            Set.from(notifications.map((notification) => notification.id!));
                                      } else {
                                        selectedIndexes.clear();
                                      }
                                    }
                                  });
                                },
                              ),
                            Text("All"),
                          ],
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: selectedIndexes.isNotEmpty
                                  ? () {
                                fetchDeleteNotificationStatus(selectedIndexes.toList());
                              }
                                  : null,
                              child: Text("Delete"),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: selectedIndexes.isNotEmpty
                                  ? () {
                                fetchUpdateNotificationStatus(selectedIndexes.toList());
                              }
                                  : null,
                              child: Text("Mark as read"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
