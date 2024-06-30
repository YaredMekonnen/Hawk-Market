class Message {
  final String id;
  final String image;
  final String text;
  final String type;
  final String senderId;
  final String chatId;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.image,
    required this.text,
    required this.type,
    required this.senderId,
    required this.chatId,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      image: json['image'],
      text: json['text'],
      type: json['type'],
      senderId: json['senderId'],
      chatId: json['chatId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      "image": image,
      "text": text,
      "type": type,
      "senderId": senderId,
      "chatId": chatId,
      "createdAt": createdAt.toIso8601String(),
    };
  }
}
