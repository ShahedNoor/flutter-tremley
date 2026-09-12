class LoyaltyHistoryModel {
  String? status;
  LoyaltyHistoryData? data;

  LoyaltyHistoryModel({this.status, this.data});

  LoyaltyHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? LoyaltyHistoryData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class LoyaltyHistoryData {
  List<SalonHistory>? salonHistory;
  List<HomeBarberHistory>? homeBarberHistory;

  LoyaltyHistoryData({this.salonHistory, this.homeBarberHistory});

  LoyaltyHistoryData.fromJson(Map<String, dynamic> json) {
    if (json['salon_history'] != null) {
      salonHistory = <SalonHistory>[];
      json['salon_history'].forEach((v) {
        salonHistory!.add(SalonHistory.fromJson(v));
      });
    }
    if (json['home_barber_history'] != null) {
      homeBarberHistory = <HomeBarberHistory>[];
      json['home_barber_history'].forEach((v) {
        homeBarberHistory!.add(HomeBarberHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (salonHistory != null) {
      data['salon_history'] = salonHistory!.map((v) => v.toJson()).toList();
    }
    if (homeBarberHistory != null) {
      data['home_barber_history'] =
          homeBarberHistory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SalonHistory {
  int? id;
  String? points;
  String? salonName;
  int? salonId;
  String? image;
  String? date;

  SalonHistory({
    this.id,
    this.points,
    this.salonName,
    this.salonId,
    this.image,
    this.date,
  });

  SalonHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    points = json['points']?.toString();
    salonName = json['salon_name'];
    salonId = json['salon_id'];
    image = json['image'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['points'] = points;
    data['salon_name'] = salonName;
    data['salon_id'] = salonId;
    data['image'] = image;
    data['date'] = date;
    return data;
  }
}

class HomeBarberHistory {
  int? id;
  String? points;
  String? barberName;
  int? barberId;
  String? image;
  String? date;

  HomeBarberHistory({
    this.id,
    this.points,
    this.barberName,
    this.barberId,
    this.image,
    this.date,
  });

  HomeBarberHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    points = json['points']?.toString();
    barberName = json['barber_name'];
    barberId = json['barber_id'];
    image = json['image'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['points'] = points;
    data['barber_name'] = barberName;
    data['barber_id'] = barberId;
    data['image'] = image;
    data['date'] = date;
    return data;
  }
}
