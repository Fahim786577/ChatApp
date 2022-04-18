
import 'package:meta/meta.dart';

@immutable
class MessageData{
  const MessageData({
    required this.senderName,
    required this.senderMessage,
    required this.profilePic,
    required this.messageDate,
    required this.dateMessage,

  });
  final String senderName;
  final String senderMessage;
  final String profilePic;
  final DateTime messageDate;
  final String dateMessage;



}