class FaqModel {
  bool? success;
  List<FaqData>? data;
  String? message;

  FaqModel({this.success, this.data, this.message});

  FaqModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <FaqData>[];
      json['data'].forEach((v) {
        data!.add(FaqData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class FaqData {
  int? id;
  String? question;
  String? answer;

  FaqData({this.id, this.question, this.answer});

  FaqData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question'] = question;
    data['answer'] = answer;
    return data;
  }
}
