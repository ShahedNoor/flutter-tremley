class HomeBarberSearchListModel {
  bool? status;
  String? message;
  List<HomeBarber>? data;

  HomeBarberSearchListModel({this.status, this.message, this.data});

  HomeBarberSearchListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <HomeBarber>[];
      json['data'].forEach((v) {
        data!.add(HomeBarber.fromJson(v));
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

class HomeBarber {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? profileImage;
  String? coverImage;
  String? latitude;
  String? longitude;
  String? role;
  String? blockStatus;
  int? availability;
  num? distance;
  int? freeMinutes;

  HomeBarber({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.profileImage,
    this.coverImage,
    this.latitude,
    this.longitude,
    this.role,
    this.blockStatus,
    this.availability,
    this.distance,
    this.freeMinutes,
  });

  HomeBarber.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    profileImage = json['profile_image'];
    coverImage = json['cover_image'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    role = json['role'];
    blockStatus = json['block_status'];
    availability = json['availability'];
    distance = json['distance'];
    freeMinutes = json['free_minutes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['profile_image'] = profileImage;
    data['cover_image'] = coverImage;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['role'] = role;
    data['block_status'] = blockStatus;
    data['availability'] = availability;
    data['distance'] = distance;
    data['free_minutes'] = freeMinutes;
    return data;
  }
}
