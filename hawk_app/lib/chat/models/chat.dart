import 'package:hawk_app/auth/models/user.dart';
import 'package:hawk_app/chat/models/message.dart';

class Chat {
  final String id;
  final Map<String, dynamic> numberOfUnread;
  final List<Message> messages;
  final List<User> owners;

  Chat({
    required this.id,
    required this.numberOfUnread,
    required this.messages,
    required this.owners,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
        id: json['id'],
        numberOfUnread: json['numberOfUnread'],
        messages: json['messages']
            .map<Message>((message) => Message.fromJson(message))
            .toList(),
        owners:
            json['owners'].map<User>((owner) => User.fromJson(owner)).toList());
  }
}
