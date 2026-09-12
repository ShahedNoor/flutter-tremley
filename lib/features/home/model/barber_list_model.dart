import 'dart:convert';

BarberListModel barberListModelFromJson(String str) =>
    BarberListModel.fromJson(json.decode(str));

String barberListModelToJson(BarberListModel data) =>
    json.encode(data.toJson());

class BarberListModel {
  bool? status;
  String? message;
  List<Barber>? data;

  BarberListModel({
    this.status,
    this.message,
    this.data,
  });

  factory BarberListModel.fromJson(Map<String, dynamic> json) =>
      BarberListModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Barber>.from(json["data"]!.map((x) => Barber.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Barber {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? profileImage;
  bool? availability;
  String? status;
  dynamic averageRating;
  int? totalReviews;

  Barber({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.profileImage,
    this.availability,
    this.status,
    this.averageRating,
    this.totalReviews,
  });

  factory Barber.fromJson(Map<String, dynamic> json) => Barber(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        profileImage: json["profile_image"],
        availability: json["availability"],
        status: json["status"],
        averageRating: json["average_rating"],
        totalReviews: json["total_reviews"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "email": email,
        "profile_image": profileImage,
        "availability": availability,
        "status": status,
        "average_rating": averageRating,
        "total_reviews": totalReviews,
      };
}
