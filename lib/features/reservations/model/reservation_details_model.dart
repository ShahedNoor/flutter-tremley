class ReservationDetailsModel {
  bool? status;
  String? message;
  ReservationDetailsData? data;

  ReservationDetailsModel({this.status, this.message, this.data});

  ReservationDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? ReservationDetailsData.fromJson(json['data'])
        : null;
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

class ReservationDetailsData {
  int? id;
  String? serviceName;
  String? totalServicePrice;
  String? locationType;
  String? locationName;
  String? locationLat;
  String? locationLon;
  String? barberImage;
  String? averageRating;
  String? date;
  String? slotTime;
  String? startTime;
  String? endTime;
  String? dateTime;
  SalonDetails? salonDetails;
  BarberDetails? barberDetails;
  String? status;
  bool? canTrack;

  ReservationDetailsData({
    this.id,
    this.serviceName,
    this.totalServicePrice,
    this.locationType,
    this.locationName,
    this.locationLat,
    this.locationLon,
    this.barberImage,
    this.averageRating,
    this.date,
    this.slotTime,
    this.startTime,
    this.endTime,
    this.dateTime,
    this.salonDetails,
    this.barberDetails,
    this.status,
    this.canTrack,
  });

  ReservationDetailsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceName = json['service_name'];
    totalServicePrice = json['total_service_price'];
    locationType = json['location_type'];
    locationName = json['location_name'];
    locationLat = json['location_lat'];
    locationLon = json['location_lon'];
    barberImage = json['barber_image'];
    averageRating = json['average_rating'];
    date = json['date'];
    slotTime = json['slot_time'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    dateTime = json['date_time'];
    salonDetails = json['salon_details'] != null
        ? SalonDetails.fromJson(json['salon_details'])
        : null;
    barberDetails = json['barber_details'] != null
        ? BarberDetails.fromJson(json['barber_details'])
        : null;
    status = json['status'];
    canTrack = json['can_track'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['service_name'] = serviceName;
    data['total_service_price'] = totalServicePrice;
    data['location_type'] = locationType;
    data['location_name'] = locationName;
    data['location_lat'] = locationLat;
    data['location_lon'] = locationLon;
    data['barber_image'] = barberImage;
    data['average_rating'] = averageRating;
    data['date'] = date;
    data['slot_time'] = slotTime;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['date_time'] = dateTime;
    if (salonDetails != null) {
      data['salon_details'] = salonDetails!.toJson();
    }
    if (barberDetails != null) {
      data['barber_details'] = barberDetails!.toJson();
    }
    data['status'] = status;
    data['can_track'] = canTrack;
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

  BarberDetails({
    this.id,
    this.name,
    this.image,
    this.averageRating,
    this.latitude,
    this.longitude,
  });

  BarberDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    averageRating = json['average_rating'];
    latitude = json['latitude'];
    longitude = json['longitude'];
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

class SalonDetails {
  int? id;
  String? name;
  String? address;
  String? latitude;
  String? longitude;

  SalonDetails({
    this.id,
    this.name,
    this.address,
    this.latitude,
    this.longitude,
  });

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
