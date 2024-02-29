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

  void fetchUpdateNotificationStatus(List<int> notificationIndexes) async {
    print('Updating notification status for IDs: $notificationIndexes');
    await ApiService.updateNotificationStatus(notificationIndexes, "Read");
    fetchNotifications();
    countUnreadNotifications();
  }

  void fetchDeleteNotificationStatus(List<int> notificationIndexes) async {
    print('Deleting notifications with IDs: $notificationIndexes');
    await ApiService.updateNotificationStatus(notificationIndexes, "Delete");
    // Remove deleted notifications from the list
    selectedIndexes.clear();
    fetchNotifications();
    countUnreadNotifications();
  }
}
