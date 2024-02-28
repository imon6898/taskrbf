import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomCart extends StatelessWidget {
  final int? index; // Define the index parameter
  final String? itemName;
  final DateTime? date;
  final String? description;
  final String? readStatus;
  final bool isChecked; // Track whether the checkbox is checked
  final bool isEditMode; // Track whether edit mode is active
  final ValueChanged<bool?>? onCheckboxChanged; // Callback for checkbox change

  CustomCart({
    this.index, // Make index required
    this.itemName,
    this.date,
    this.description,
    this.readStatus,
    this.isChecked = false, // Initialize isChecked to false
    required this.isEditMode, // Receive edit mode state
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
      indicator = SizedBox(width: 0); // Hide the indicator by setting width to 0
    }

    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: ListTile(
        tileColor: Colors.white,
        leading: isEditMode ? Checkbox( // Show checkbox only in edit mode
          value: isChecked,
          onChanged: (isChecked) {
            // Call the onChanged callback
            onCheckboxChanged?.call(isChecked);
            // Print the ID if the checkbox is checked
            if (isChecked == true) {
              print('ID: ${index}');
            }
          },
        ) : null, // Hide checkbox when not in edit mode
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    indicator, // Show the indicator if not null
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
