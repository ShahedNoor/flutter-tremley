class ChatMessageModel {
  int? id;
  int? senderId;
  int? receiverId;
  String? conversationId;
  int? isRead;
  String? message;
  String? image;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;
  int? imageId;
  String? chatimage;

  ChatMessageModel({
    this.id,
    this.senderId,
    this.receiverId,
    this.conversationId,
    this.isRead,
    this.message,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.imageUrl,
    this.imageId,
    this.chatimage,
  });

  ChatMessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? int.tryParse(json['id'].toString()) : null;
    senderId = json['sender_id'] != null ? int.tryParse(json['sender_id'].toString()) : null;
    receiverId = json['receiver_id'] != null ? int.tryParse(json['receiver_id'].toString()) : null;
    conversationId = json['conversation_id']?.toString();
    isRead = json['is_read'] != null ? int.tryParse(json['is_read'].toString()) : null;
    message = json['message']?.toString();
    image = json['image']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    imageUrl = json['image_url']?.toString();
    imageId = json['image_id'] != null ? int.tryParse(json['image_id'].toString()) : null;
    chatimage = json['chatimage']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sender_id'] = senderId;
    data['receiver_id'] = receiverId;
    data['conversation_id'] = conversationId;
    data['is_read'] = isRead;
    data['message'] = message;
    data['image'] = image;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['image_url'] = imageUrl;
    data['image_id'] = imageId;
    data['chatimage'] = chatimage;
    return data;
  }
}
