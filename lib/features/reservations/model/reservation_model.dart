class ReservationModel {
  bool? status;
  String? message;
  List<ReservationData>? data;

  ReservationModel({this.status, this.message, this.data});

  ReservationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ReservationData>[];
      json['data'].forEach((v) {
        data!.add(ReservationData.fromJson(v));
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

class ReservationData {
  int? id;
  String? serviceName;
  String? locationType;
  String? locationName;
  String? dateTime;
  String? status;
  bool? canTrack;
  String? locationLat;
  String? locationLon;

  ReservationData({
    this.id,
    this.serviceName,
    this.locationType,
    this.locationName,
    this.dateTime,
    this.status,
    this.canTrack,
    this.locationLat,
    this.locationLon,
  });

  ReservationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceName = json['service_name'];
    locationType = json['location_type'];
    locationName = json['location_name'];
    dateTime = json['date_time'];
    status = json['status'];
    canTrack = json['can_track'];
    locationLat = json['location_lat']?.toString();
    locationLon = json['location_lon']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['service_name'] = serviceName;
    data['location_type'] = locationType;
    data['location_name'] = locationName;
    data['date_time'] = dateTime;
    data['status'] = status;
    data['can_track'] = canTrack;
    data['location_lat'] = locationLat;
    data['location_lon'] = locationLon;
    return data;
  }
}
