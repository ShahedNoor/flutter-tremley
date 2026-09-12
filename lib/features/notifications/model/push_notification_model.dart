class PushNotificationModel {
  bool? status;
  String? message;
  List<NotificationData>? data;

  PushNotificationModel({this.status, this.message, this.data});

  PushNotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <NotificationData>[];
      json['data'].forEach((v) {
        data!.add(NotificationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationData {
  String? id;
  String? type;
  String? notifiableType;
  int? notifiableId;
  NotificationPayload? data;
  String? readAt;
  String? createdAt;
  String? updatedAt;

  NotificationData(
      {this.id,
      this.type,
      this.notifiableType,
      this.notifiableId,
      this.data,
      this.readAt,
      this.createdAt,
      this.updatedAt});

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    notifiableType = json['notifiable_type'];
    notifiableId = json['notifiable_id'];
    data = json['data'] != null ? NotificationPayload.fromJson(json['data']) : null;
    readAt = json['read_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['notifiable_type'] = notifiableType;
    data['notifiable_id'] = notifiableId;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['read_at'] = readAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class NotificationPayload {
  String? title;
  String? body;
  PayloadData? data;

  NotificationPayload({this.title, this.body, this.data});

  NotificationPayload.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    data = json['data'] != null ? PayloadData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['body'] = body;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class PayloadData {
  dynamic bookingId;
  String? status;

  PayloadData({this.bookingId, this.status});

  PayloadData.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['booking_id'] = bookingId;
    data['status'] = status;
    return data;
  }
}
