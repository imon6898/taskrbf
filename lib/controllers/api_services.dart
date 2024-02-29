import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/get_notification_model.dart';

class ApiService {
  static Dio _dio = Dio();
  static String baseUrl = 'http://sherpur.rbfgroupbd.com';
  static String authToken = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNzA5MTgwNDg3LCJleHAiOjE3MDkyNjY4ODd9.obz-4DW4FLFz8wP2OHRoCvTn_8Z6YGN-REJlor8I-24';

  static Future<List<Result>> fetchNotifications({required int page, required int pageSize}) async {
    var headers = {
      'Authorization': authToken,
    };

    try {
      var response = await _dio.get(
        '$baseUrl/get_notification?page=$page&pageSize=$pageSize',
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        var data = GetNotificationModel.fromJson(response.data);
        return data.data?.results ?? [];
      } else {
        print('Request failed with status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  static Future<void> updateNotificationStatus(List<int> notificationIds, String status) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': authToken,
    };

    var data = json.encode({
      "notification_Ids": notificationIds,
      "status": status,
    });

    try {
      var response = await _dio.post(
        '$baseUrl/update_notification_status',
        options: Options(headers: headers),
        data: data,
      );

      if (response.statusCode == 200) {
        print(json.encode(response.data));
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
