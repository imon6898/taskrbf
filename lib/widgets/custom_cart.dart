import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart'; // Import Get package
import '../controllers/notification_controller.dart'; // Import your GetX controller


class CustomCart extends StatelessWidget {
  final int? index;
  final String? itemName;
  final DateTime? date;
  final String? description;
  final String? readStatus;
  final bool isChecked;
  final bool isEditMode;
  final Function(bool?)? onCheckboxChanged;

  CustomCart({
    this.index,
    this.itemName,
    this.date,
    this.description,
    this.readStatus,
    this.isChecked = false,
    required this.isEditMode,
    this.onCheckboxChanged,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = date != null ? DateFormat('dd MMM yyyy hh:mm a').format(date!) : '';
    Widget indicator;

    if (readStatus == 'No') {
      indicator = Container(
        width: 8,
        height: 10,
        margin: EdgeInsets.only(right: 2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red,
        ),
      );
    } else {
      indicator = SizedBox(width: 0);
    }

    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: ListTile(
        tileColor: Colors.white,
        onTap: () {
          if (isEditMode) {
            onCheckboxChanged?.call(!isChecked); // Invert the isChecked value
          }
        },
        leading: isEditMode ? Checkbox(
          value: isChecked,
          onChanged: onCheckboxChanged,
        ) : null,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    indicator,
                    Text(
                      itemName ?? '',
                      style: TextStyle(fontSize: 14.0, color: Colors.red),
                    ),
                  ],
                ),
                Text(
                  '$formattedDate',
                  style: TextStyle(fontSize: 14.0, color: Colors.red),
                ),
              ],
            ),
            SizedBox(height: 5.0),
            Row(
              children: [
                Expanded(
                  child: Text(
                    description ?? '',
                    style: TextStyle(fontSize: 16.0),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
