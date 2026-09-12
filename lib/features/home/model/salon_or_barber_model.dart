class SalonOrBarberModel {
  bool? status;
  String? message;
  SalonOrBarberData? data;

  SalonOrBarberModel({this.status, this.message, this.data});

  SalonOrBarberModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? SalonOrBarberData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class SalonOrBarberData {
  List<SalonOrBarber>? list;
  int? total;

  SalonOrBarberData({this.list, this.total});

  SalonOrBarberData.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <SalonOrBarber>[];
      json['list'].forEach((v) {
        list!.add(SalonOrBarber.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (list != null) {
      data['list'] = list!.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    return data;
  }
}

class SalonOrBarber {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? role;
  String? profileImage;
  String? coverImage;
  List<GalleryImage>? galleryImages;
  String? latitude;
  String? longitude;
  bool? availability;
  String? status;
  bool? salonBarbarStatus;
  double? distanceKm;
  String? openTime;
  String? closeTime;
  bool? isOpenNow;
  int? scheduleDuration;
  int? bufferTime;
  int? breakTime;
  String? businessName;
  String? salonAddress;
  String? about;
  String? experience;
  String? address;
  dynamic avgRating;
  int? reviewCount;
  int? barberCount;

  SalonOrBarber({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.role,
    this.profileImage,
    this.coverImage,
    this.galleryImages,
    this.latitude,
    this.longitude,
    this.availability,
    this.status,
    this.salonBarbarStatus,
    this.distanceKm,
    this.openTime,
    this.closeTime,
    this.isOpenNow,
    this.scheduleDuration,
    this.bufferTime,
    this.breakTime,
    this.businessName,
    this.salonAddress,
    this.about,
    this.experience,
    this.address,
    this.avgRating,
    this.reviewCount,
    this.barberCount,
  });

  SalonOrBarber.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    role = json['role'];
    profileImage = json['profile_image'];
    coverImage = json['cover_image'];
    if (json['gallery_images'] != null) {
      galleryImages = <GalleryImage>[];
      json['gallery_images'].forEach((v) {
        galleryImages!.add(GalleryImage.fromJson(v));
      });
    }
    latitude = json['latitude'];
    longitude = json['longitude'];
    availability = json['availability'];
    status = json['status'];
    salonBarbarStatus = json['salon_barbar_status'];
    distanceKm = json['distance_km'] != null ? double.tryParse(json['distance_km'].toString()) : null;
    openTime = json['open_time'];
    closeTime = json['close_time'];
    isOpenNow = json['is_open_now'];
    scheduleDuration = json['schedule_duration'];
    bufferTime = json['buffer_time'];
    breakTime = json['break_time'];
    businessName = json['business_name'];
    salonAddress = json['salon_address'];
    about = json['about'];
    experience = json['experience'];
    address = json['address'];
    avgRating = json['avg_rating'];
    reviewCount = json['review_count'];
    barberCount = json['barber_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['role'] = role;
    data['profile_image'] = profileImage;
    data['cover_image'] = coverImage;
    if (galleryImages != null) {
      data['gallery_images'] = galleryImages!.map((v) => v.toJson()).toList();
    }
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['availability'] = availability;
    data['status'] = status;
    data['salon_barbar_status'] = salonBarbarStatus;
    data['distance_km'] = distanceKm;
    data['open_time'] = openTime;
    data['close_time'] = closeTime;
    data['is_open_now'] = isOpenNow;
    data['schedule_duration'] = scheduleDuration;
    data['buffer_time'] = bufferTime;
    data['break_time'] = breakTime;
    data['business_name'] = businessName;
    data['salon_address'] = salonAddress;
    data['about'] = about;
    data['experience'] = experience;
    data['address'] = address;
    data['avg_rating'] = avgRating;
    data['review_count'] = reviewCount;
    data['barber_count'] = barberCount;
    return data;
  }
}

class GalleryImage {
  int? id;
  String? image;

  GalleryImage({this.id, this.image});

  GalleryImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    return data;
  }
}
