
import 'dart:convert';

GetNotificationModel getNotoficationModelFromJson(String str) => GetNotificationModel.fromJson(json.decode(str));

String getNotoficationModelToJson(GetNotificationModel data) => json.encode(data.toJson());

class GetNotificationModel {
  final String? status;
  final String? message;
  final Error? error;
  final Data? data;

  GetNotificationModel({
    this.status,
    this.message,
    this.error,
    this.data,
  });

  factory GetNotificationModel.fromJson(Map<String, dynamic> json) => GetNotificationModel(
    status: json["status"],
    message: json["message"],
    error: json["error"] == null ? null : Error.fromJson(json["error"]),
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "error": error?.toJson(),
    "data": data?.toJson(),
  };
}

class Data {
  final int? totalunread;
  final List<Result>? results;

  Data({
    this.totalunread,
    this.results,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalunread: json["totalunread"],
    results: json["results"] == null ? [] : List<Result>.from(json["results"]!.map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalunread": totalunread,
    "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
  };
}

class Result {
  final int? id;
  final int? userId;
  final dynamic image;
  final String? title;
  final String? description;
  String? readStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  Result({
    this.id,
    this.userId,
    this.image,
    this.title,
    this.description,
    this.readStatus,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    userId: json["user_id"],
    image: json["image"],
    title: json["title"],
    description: json["description"],
    readStatus: json["read_status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "image": image,
    "title": title,
    "description": description,
    "read_status": readStatus,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
  };
}

class Error {
  Error();

  factory Error.fromJson(Map<String, dynamic> json) => Error(
  );

  Map<String, dynamic> toJson() => {
  };
}
