class BookingDetailsModel {
  bool? status;
  String? message;
  BookingDetailsData? data;

  BookingDetailsModel({this.status, this.message, this.data});

  BookingDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? BookingDetailsData.fromJson(json['data']) : null;
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

class BookingDetailsData {
  BookingBarber? barber;
  BookingInfo? bookingInfo;
  SalonDetails? salonDetails;
  BarberDetails? barberDetails;
  BookingReview? salonReview;
  BookingReview? barberReview;
  List<BookingTracking>? tracking;
  int? chatId;

  BookingDetailsData(
      {this.barber,
      this.bookingInfo,
      this.salonDetails,
      this.barberDetails,
      this.salonReview,
      this.barberReview,
      this.tracking,
      this.chatId});

  BookingDetailsData.fromJson(Map<String, dynamic> json) {
    barber = json['barber'] != null ? BookingBarber.fromJson(json['barber']) : null;
    bookingInfo = json['booking_info'] != null
        ? BookingInfo.fromJson(json['booking_info'])
        : null;
    salonDetails = json['salon_details'] != null
        ? SalonDetails.fromJson(json['salon_details'])
        : null;
    barberDetails = json['barber_details'] != null
        ? BarberDetails.fromJson(json['barber_details'])
        : null;
    salonReview = json['salon_review'] != null
        ? BookingReview.fromJson(json['salon_review'])
        : null;
    barberReview = json['barber_review'] != null
        ? BookingReview.fromJson(json['barber_review'])
        : null;
    if (json['tracking'] != null) {
      tracking = <BookingTracking>[];
      json['tracking'].forEach((v) {
        tracking!.add(BookingTracking.fromJson(v));
      });
    }
    chatId = json['chat_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (barber != null) {
      data['barber'] = barber!.toJson();
    }
    if (bookingInfo != null) {
      data['booking_info'] = bookingInfo!.toJson();
    }
    if (salonDetails != null) {
      data['salon_details'] = salonDetails!.toJson();
    }
    if (barberDetails != null) {
      data['barber_details'] = barberDetails!.toJson();
    }
    if (salonReview != null) {
      data['salon_review'] = salonReview!.toJson();
    }
    if (barberReview != null) {
      data['barber_review'] = barberReview!.toJson();
    }
    if (tracking != null) {
      data['tracking'] = tracking!.map((v) => v.toJson()).toList();
    }
    data['chat_id'] = chatId;
    return data;
  }
}

class BookingBarber {
  String? name;
  String? image;
  String? rating;
  String? services;
  int? id;

  BookingBarber({this.name, this.image, this.rating, this.services, this.id});

  BookingBarber.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    rating = json['rating']?.toString();
    services = json['services'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['image'] = image;
    data['rating'] = rating;
    data['services'] = services;
    data['id'] = id;
    return data;
  }
}

class BookingInfo {
  int? id;
  String? serviceName;
  String? locationType;
  String? locationName;
  String? locationLat;
  String? locationLon;
  String? date;
  String? slotTime;
  String? startTime;
  String? endTime;
  String? dateTime;
  String? totalServicePrice;
  String? totalToPay;
  String? status;
  bool? isReviewed;
  int? barbarId;
  int? salonId;

  BookingInfo(
      {this.id,
      this.serviceName,
      this.locationType,
      this.locationName,
      this.locationLat,
      this.locationLon,
      this.date,
      this.slotTime,
      this.startTime,
      this.endTime,
      this.dateTime,
      this.totalServicePrice,
      this.totalToPay,
      this.status,
      this.isReviewed});

  BookingInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceName = json['service_name'];
    locationType = json['location_type'];
    locationName = json['location_name'];
    locationLat = json['location_lat'];
    locationLon = json['location_lon'];
    date = json['date'];
    slotTime = json['slot_time'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    dateTime = json['date_time'];
    totalServicePrice = json['total_service_price'];
    totalToPay = json['total_to_pay'];
    status = json['status'];
    isReviewed = json['is_reviewed'];
    barbarId = json['barbar_id'];
    salonId = json['salon_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['service_name'] = serviceName;
    data['location_type'] = locationType;
    data['location_name'] = locationName;
    data['location_lat'] = locationLat;
    data['location_lon'] = locationLon;
    data['date'] = date;
    data['slot_time'] = slotTime;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['date_time'] = dateTime;
    data['total_service_price'] = totalServicePrice;
    data['total_to_pay'] = totalToPay;
    data['status'] = status;
    data['is_reviewed'] = isReviewed;
    return data;
  }
}

class BookingTracking {
  String? title;
  String? subTitle;
  bool? isCompleted;

  BookingTracking({this.title, this.subTitle, this.isCompleted});

  BookingTracking.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subTitle = json['sub_title'];
    isCompleted = json['is_completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['sub_title'] = subTitle;
    data['is_completed'] = isCompleted;
    return data;
  }
}

class SalonDetails {
  int? id;
  String? name;
  String? address;
  String? latitude;
  String? longitude;

  SalonDetails({this.id, this.name, this.address, this.latitude, this.longitude});

  SalonDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    latitude = json['latitude']?.toString();
    longitude = json['longitude']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}

class BarberDetails {
  int? id;
  String? name;
  String? image;
  String? averageRating;
  String? latitude;
  String? longitude;

  BarberDetails(
      {this.id,
      this.name,
      this.image,
      this.averageRating,
      this.latitude,
      this.longitude});

  BarberDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    averageRating = json['average_rating']?.toString();
    latitude = json['latitude']?.toString();
    longitude = json['longitude']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['average_rating'] = averageRating;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}

class BookingReview {
  String? review;
  dynamic rating;
  bool? isReviewed;

  BookingReview({this.review, this.rating, this.isReviewed});

  BookingReview.fromJson(Map<String, dynamic> json) {
    review = json['review'];
    rating = json['rating'];
    isReviewed = json['is_reviewed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['review'] = review;
    data['rating'] = rating;
    data['is_reviewed'] = isReviewed;
    return data;
  }
}
