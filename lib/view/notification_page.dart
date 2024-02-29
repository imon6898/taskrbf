import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notification_controller.dart';
import '../models/get_notification_model.dart';
import '../widgets/custom_cart.dart';

class NotificationPage extends StatelessWidget {
  final NotificationController _notificationController = Get.put(NotificationController());
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        // Reached the bottom of the list
        _notificationController.fetchMoreNotifications();
      }
    });

    return Scaffold(
      backgroundColor: Colors.white60,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text("Notification"),
        actions: [
          Obx(() => IconButton(
            onPressed: () {
              _notificationController.toggleEditMode();
            },
            icon: _notificationController.isEditMode.value
                ? Text(
              'Cancel',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            )
                : Icon(Icons.edit_outlined),
          )),
        ],
      ),
      body: Obx(() {
        if (_notificationController.isLoading.value && _notificationController.currentPage == 10) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Stack(
            children: [
              ListView.builder(
                controller: _scrollController,
                itemCount: _notificationController.notifications.length + (_notificationController.hasMoreData.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < _notificationController.notifications.length) {
                    final notification = _notificationController.notifications[index];
                    return CustomCart(
                      index: notification.id!,
                      itemName: notification.title,
                      description: notification.description,
                      date: notification.updatedAt ?? DateTime.now(),
                      readStatus: notification.readStatus,
                      isChecked: _notificationController.isEditMode.value &&
                          _notificationController.selectedIndexes.contains(notification.id!),
                      onCheckboxChanged: (isChecked) {
                        _notificationController.toggleCheckbox(notification.id!, isChecked);
                      },
                      isEditMode: _notificationController.isEditMode.value,
                    );
                  } else {
                    // Show a loading indicator if there's more data to load
                    return _notificationController.hasMoreData.value ? SizedBox(
                      width: 10,
                      height: 50,
                      child: Center(child: CircularProgressIndicator()),
                    ) : SizedBox();
                  }
                },
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: _notificationController.isEditMode.value ? 0 : -80,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: 80,
                  color: Colors.white,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _notificationController.selectedIndexes.length == _notificationController.notifications.length,
                              onChanged: (isChecked) {
                                _notificationController.toggleAllCheckboxes(isChecked);
                              },
                            ),
                            Text("All"),
                          ],
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: _notificationController.selectedIndexes.isNotEmpty
                                  ? () {
                                _notificationController.fetchDeleteNotificationStatus(
                                    _notificationController.selectedIndexes.toList());
                              }
                                  : null,
                              child: Text("Delete"),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: _notificationController.selectedIndexes.isNotEmpty
                                  ? () {
                                _notificationController.fetchUpdateNotificationStatus(
                                    _notificationController.selectedIndexes.toList());
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
          );
        }
      }),
    );
  }
}
