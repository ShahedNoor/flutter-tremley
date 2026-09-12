import 'dart:convert';
import 'package:intl/intl.dart';

BookingSlotsModel bookingSlotsModelFromJson(String str) =>
    BookingSlotsModel.fromJson(json.decode(str));

String bookingSlotsModelToJson(BookingSlotsModel data) =>
    json.encode(data.toJson());

class BookingSlotsModel {
  bool? status;
  String? message;
  BookingSlotsData? data;

  BookingSlotsModel({
    this.status,
    this.message,
    this.data,
  });

  factory BookingSlotsModel.fromJson(Map<String, dynamic> json) =>
      BookingSlotsModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : BookingSlotsData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class BookingSlotsData {
  String? providerType;
  int? barberId;
  int? salonId;
  String? date;
  List<Slot>? slots;

  BookingSlotsData({
    this.providerType,
    this.barberId,
    this.salonId,
    this.date,
    this.slots,
  });

  factory BookingSlotsData.fromJson(Map<String, dynamic> json) {
    List<Slot> parsedSlots = json["slots"] == null
        ? []
        : List<Slot>.from(json["slots"]!.map((x) => Slot.fromJson(x)));

    // Filter out past slots by comparing wall-clock times
    final now = DateTime.now();
    final wallClockNow = DateTime.utc(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
    );

    final String? dateString = json["date"];
    DateTime? requestedDate;
    if (dateString != null) {
      requestedDate = DateTime.tryParse(dateString);
    }
    
    final todayDate = DateTime(now.year, now.month, now.day);
    bool isFutureDate = false;
    
    if (requestedDate != null) {
      final reqDate = DateTime(requestedDate.year, requestedDate.month, requestedDate.day);
      if (reqDate.isAfter(todayDate)) {
        isFutureDate = true;
      } else if (reqDate.isBefore(todayDate)) {
        // Past date, clear all slots
        parsedSlots = [];
      }
    }

    if (!isFutureDate && parsedSlots.isNotEmpty) {
      // It's today (or we couldn't parse the date), so filter out past times.
      parsedSlots = parsedSlots.where((slot) {
        if (slot.startTime == null) return false;
        
        // Since the backend might return the wrong date in startTime, 
        // we extract just the time from startTime and combine it with today's date
        // to properly compare against wallClockNow.
        final actualSlotTime = DateTime.utc(
          now.year,
          now.month,
          now.day,
          slot.startTime!.hour,
          slot.startTime!.minute,
        );
        return actualSlotTime.isAfter(wallClockNow);
      }).toList();
    }

    return BookingSlotsData(
      providerType: json["provider_type"],
      barberId: json["barber_id"],
      salonId: json["salon_id"],
      date: json["date"],
      slots: parsedSlots,
    );
  }

  Map<String, dynamic> toJson() => {
        "provider_type": providerType,
        "barber_id": barberId,
        "salon_id": salonId,
        "date": date,
        "slots": slots == null
            ? []
            : List<dynamic>.from(slots!.map((x) => x.toJson())),
      };
}

class Slot {
  int? slotId;
  DateTime? startTime;
  DateTime? endTime;
  bool? isBooked;

  Slot({
    this.slotId,
    this.startTime,
    this.endTime,
    this.isBooked,
  });

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
        slotId: json["slot_id"],
        startTime: json["start_time"] == null
            ? null
            : DateTime.parse(json["start_time"]),
        endTime:
            json["end_time"] == null ? null : DateTime.parse(json["end_time"]),
        isBooked: json["is_booked"] == 1 || json["is_booked"] == true,
      );

  Map<String, dynamic> toJson() => {
        "slot_id": slotId,
        "start_time": startTime?.toIso8601String(),
        "end_time": endTime?.toIso8601String(),
        "is_booked": isBooked,
      };

  String get formattedStartTime {
    if (startTime == null) return "";
    return DateFormat('HH:mm').format(startTime!.toUtc());
  }

  String get formattedEndTime {
    if (endTime == null) return "";
    return DateFormat('HH:mm').format(endTime!.toUtc());
  }

  String get formattedTimeRange {
    if (startTime == null || endTime == null) return "";
    return "${DateFormat('HH:mm').format(startTime!.toUtc())} to ${DateFormat('HH:mm').format(endTime!.toUtc())}";
  }
}
