class SalonLoyaltyModel {
  String? status;
  String? reachLoyality;
  String? customerLoyalityPoint;
  String? loyalityDescription;
  int? serviceId;
  String? serviceName;
  String? serviceDuration;
  SalonDetailsLoyalty? salonDetails;

  SalonLoyaltyModel({
    this.status,
    this.reachLoyality,
    this.customerLoyalityPoint,
    this.loyalityDescription,
    this.serviceId,
    this.serviceName,
    this.serviceDuration,
    this.salonDetails,
  });

  SalonLoyaltyModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    reachLoyality = json['reach_loyality']?.toString();
    customerLoyalityPoint = json['customer_loyality_point']?.toString();
    loyalityDescription = json['loyality_description'];
    serviceId = json['service_id'];
    serviceName = json['service_name'];
    serviceDuration = json['service_duration']?.toString();
    salonDetails = json['salon_details'] != null
        ? SalonDetailsLoyalty.fromJson(json['salon_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['reach_loyality'] = reachLoyality;
    data['customer_loyality_point'] = customerLoyalityPoint;
    data['loyality_description'] = loyalityDescription;
    data['service_id'] = serviceId;
    data['service_name'] = serviceName;
    data['service_duration'] = serviceDuration;
    if (salonDetails != null) {
      data['salon_details'] = salonDetails!.toJson();
    }
    return data;
  }
}

class SalonDetailsLoyalty {
  int? id;
  String? name;
  String? image;
  String? role;

  SalonDetailsLoyalty({this.id, this.name, this.image, this.role});

  SalonDetailsLoyalty.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['role'] = role;
    return data;
  }
}
