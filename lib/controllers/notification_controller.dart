import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/get_notification_model.dart';
import '../controllers/api_services.dart';

class NotificationController extends GetxController {
  var notifications = <Result>[].obs;
  var isEditMode = false.obs;
  var notificationCount = 0.obs;
  var selectedIndexes = Set<int>().obs;
  int currentPage = 0;
  int pageSize = 15;
  var isLoading = false.obs; // Add this line
  var hasMoreData = true.obs; // Add this line

  @override
  void onInit() {
    fetchNotifications();
    super.onInit();
  }

  void fetchNotifications() async {
    isLoading.value = true;
    var result = await ApiService.fetchNotifications(page: currentPage, pageSize: pageSize);
    isLoading.value = false;

    if (result.isNotEmpty) {
      notifications.assignAll(result);
      currentPage++;
      countUnreadNotifications();
    } else {
      // No more data available
      hasMoreData.value = false;
    }
  }

  void fetchMoreNotifications() async {
    if (!isLoading.value && hasMoreData.value) {
      isLoading.value = true;
      var result = await ApiService.fetchNotifications(page: currentPage, pageSize: pageSize);
      isLoading.value = false;

      if (result.isNotEmpty) {
        notifications.addAll(result);
        currentPage++;
        countUnreadNotifications();
      } else {
        // No more data available
        hasMoreData.value = false;
      }
    }
  }

  void countUnreadNotifications() {
    int unreadCount = notifications.where((notification) => notification.readStatus == 'No').length;
    notificationCount.value = unreadCount;
  }

  void toggleCheckbox(int index, bool? isChecked) {
    if (isChecked == true) {
      selectedIndexes.add(index); // Add the index when isChecked is true
    } else {
      selectedIndexes.remove(index); // Remove the index when isChecked is false
    }
  }

  void toggleAllCheckboxes(bool? isChecked) {
    if (isChecked != null) {
      if (isChecked) {
        selectedIndexes.addAll(notifications.map((notification) => notification.id!));
      } else {
        selectedIndexes.clear();
      }
    }
  }


  void toggleEditMode() {
    isEditMode.toggle();
    if (!isEditMode.value) {
      selectedIndexes.clear();
    }
  }

  void fetchUpdateNotificationStatus(List<int> notificationIndexes) {
    print('Updating notification status for IDs: $notificationIndexes');
    List<int> updatedIds = [];

    ApiService.updateNotificationStatus(notificationIndexes, "Read").then((_) {
      // This block executes after the updateNotificationStatus completes
      // Fetch notifications after updating the status
      fetchNotifications();
      countUnreadNotifications();

      // Show Snackbar indicating the status update for each notification index
      notificationIndexes.forEach((index) {
        Result? notification = notifications.firstWhere((element) => element.id == index,);
        if (notification != null) {
          if (notification.readStatus == 'No') {
            notification.readStatus = 'Yes';
            updatedIds.add(index);
          } else {
            // Notification already seen, show red Snackbar
            Get.snackbar(
              'Warning',
              'You have already seen this notification',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        }
      });

      // Show green Snackbar if successful updates occurred
      if (updatedIds.isNotEmpty) {
        Get.snackbar(
          'Success',
          'Notification status updated',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    }).catchError((error) {
      print('Error updating notification status: $error');
      // Show red Snackbar if unsuccessful
      Get.snackbar(
        'Error',
        'Failed to update notification status',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    });
  }



  void fetchDeleteNotificationStatus(List<int> notificationIndexes) {
    print('Deleting notifications with IDs: $notificationIndexes');
    ApiService.updateNotificationStatus(notificationIndexes, "Delete").then((_) {
      // Remove deleted notifications from the list
      selectedIndexes.clear();
      fetchNotifications();
      countUnreadNotifications();
      // Show green Snackbar if successful
      Get.snackbar(
        'Success',
        'Notifications deleted successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }).catchError((error) {
      print('Error deleting notifications: $error');
      // Show red Snackbar if unsuccessful
      Get.snackbar(
        'Error',
        'Failed to delete notifications',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    });
  }

}
