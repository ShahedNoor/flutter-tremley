class ServiceListModel {
  final bool? status;
  final String? message;
  final List<ServiceItem> data;

  ServiceListModel({
    this.status,
    this.message,
    this.data = const [],
  });

  factory ServiceListModel.fromJson(Map<String, dynamic> json) {
    return ServiceListModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => ServiceItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data.map((e) => e.toJson()).toList(),
      };
}

class ServiceItem {
  final int? id;
  final String? serviceName;
  final int? salonId;
  final String? createdAt;
  final String? updatedAt;
  final ServicePrice? servicePrice;

  /// Local quantity selected by user (not from API)
  int quantity;

  ServiceItem({
    this.id,
    this.serviceName,
    this.salonId,
    this.createdAt,
    this.updatedAt,
    this.servicePrice,
    this.quantity = 0,
  });

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      id: json['id'] as int?,
      serviceName: json['service_name'] as String?,
      salonId: json['salon_id'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      servicePrice: json['service_price'] != null
          ? ServicePrice.fromJson(json['service_price'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'service_name': serviceName,
        'salon_id': salonId,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'service_price': servicePrice?.toJson(),
      };
}

class ServicePrice {
  final int? id;
  final int? serviceId;
  final int? createdBy;
  final String? price;
  final String? discount;
  final String? timeDuration;
  final String? createdForType;
  final String? createdAt;
  final String? updatedAt;

  ServicePrice({
    this.id,
    this.serviceId,
    this.createdBy,
    this.price,
    this.discount,
    this.timeDuration,
    this.createdForType,
    this.createdAt,
    this.updatedAt,
  });

  factory ServicePrice.fromJson(Map<String, dynamic> json) {
    return ServicePrice(
      id: json['id'] as int?,
      serviceId: json['service_id'] as int?,
      createdBy: json['created_by'] as int?,
      price: json['price'] as String?,
      discount: json['discount'] as String?,
      timeDuration: json['time_duration'] as String?,
      createdForType: json['created_for_type'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'service_id': serviceId,
        'created_by': createdBy,
        'price': price,
        'discount': discount,
        'time_duration': timeDuration,
        'created_for_type': createdForType,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
