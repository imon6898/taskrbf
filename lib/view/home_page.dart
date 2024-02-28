
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notification_controller.dart';
import 'notification_page.dart';
import 'package:badges/badges.dart' as custom_badges;

class HomePage extends StatelessWidget {
  final NotificationController notificationController = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF0C9869),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '.....',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              child: ListTile(
                title: const Text(
                  'LogOut',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
                subtitle: const Text(
                  'LogOut your Account',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                leading: Icon(Icons.logout, color: Colors.black, size: 40),
                trailing: Icon(Icons.arrow_forward_ios, size: 30, color: Colors.orange),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          Obx(() => custom_badges.Badge(
            badgeContent: Text(
              notificationController.notificationCount.toString(),
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
            position: custom_badges.BadgePosition.topEnd(top: 2, end: 2),
            child: IconButton(
              onPressed: () {
                Get.to(NotificationPage());
              },
              icon: Icon(Icons.notification_important_rounded, size: 30,),
            ),
          )),
        ],
      ),
      body: Container(),
    );
  }
}
