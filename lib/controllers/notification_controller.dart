import 'package:get/get.dart';
import '../models/get_notification_model.dart';
import '../controllers/api_services.dart';

class NotificationController extends GetxController {
  var notifications = <Result>[].obs;
  var isEditMode = false.obs;
  var selectedIndexes = <int>{}.obs;
  var notificationCount = 0.obs;

  @override
  void onInit() {
    fetchNotifications();
    super.onInit();
  }

  void fetchNotifications() async {
    var result = await ApiService.fetchNotifications(page: 1, pageSize: 5);
    notifications.assignAll(result);
    countUnreadNotifications();
  }

  void countUnreadNotifications() {
    int unreadCount = notifications.where((notification) => notification.readStatus == 'No').length;
    notificationCount.value = unreadCount;
  }

  void toggleCheckbox(int index, bool? isChecked) {
    if (isChecked == true) {
      if (index >= 0 && index < notifications.length) {
        selectedIndexes.add(notifications[index].id!);
      }
    } else {
      if (index >= 0 && index < notifications.length) {
        selectedIndexes.remove(notifications[index].id!);
      }
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

  Future<void> updateNotificationStatus(String status) async {
    if (selectedIndexes.isNotEmpty) {
      await ApiService.updateNotificationStatus(selectedIndexes.toList(), status);
      if (status == "Delete") {
        // Remove deleted notifications from the list
        notifications.removeWhere((notification) => selectedIndexes.contains(notification.id!));
        countUnreadNotifications(); // Recalculate notification count
      }
    }
  }
}
