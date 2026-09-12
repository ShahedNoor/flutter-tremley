class SalonReviewsModel {
  bool? status;
  String? message;
  Data? data;

  SalonReviewsModel({this.status, this.message, this.data});

  SalonReviewsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  List<ReviewItem>? list;
  Pagination? pagination;

  Data({this.list, this.pagination});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <ReviewItem>[];
      json['list'].forEach((v) {
        list!.add(ReviewItem.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (list != null) {
      data['list'] = list!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class ReviewItem {
  String? customerName;
  String? customerImage;
  num? rating;
  String? review;
  String? date;

  ReviewItem({
    this.customerName,
    this.customerImage,
    this.rating,
    this.review,
    this.date,
  });

  ReviewItem.fromJson(Map<String, dynamic> json) {
    customerName = json['customer_name'];
    customerImage = json['customer_image'];
    rating = num.tryParse(json['rating']?.toString() ?? '');
    review = json['review'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_name'] = customerName;
    data['customer_image'] = customerImage;
    data['rating'] = rating;
    data['review'] = review;
    data['date'] = date;
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? lastPage;
  int? total;
  int? perPage;
  String? nextPage;
  String? prevPage;

  Pagination({
    this.currentPage,
    this.lastPage,
    this.total,
    this.perPage,
    this.nextPage,
    this.prevPage,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = int.tryParse(json['current_page']?.toString() ?? '');
    lastPage = int.tryParse(json['last_page']?.toString() ?? '');
    total = int.tryParse(json['total']?.toString() ?? '');
    perPage = int.tryParse(json['per_page']?.toString() ?? '');
    nextPage = json['next_page'];
    prevPage = json['prev_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    data['last_page'] = lastPage;
    data['total'] = total;
    data['per_page'] = perPage;
    data['next_page'] = nextPage;
    data['prev_page'] = prevPage;
    return data;
  }
}
