import '../helpers/datetime_helper.dart';

class Chat {
  final String sessionOwnerId;
  final String receiverUserId;
  final String receiverDisplayName;
  final String lastMessage;
  final DateTime createdTime;
  final String receiverPhotoUrl;
  bool fromMe;

  Chat(
      {required this.sessionOwnerId,
      required this.receiverUserId,
      required this.receiverDisplayName,
      required this.lastMessage,
      required this.createdTime,
      required this.receiverPhotoUrl,
      required this.fromMe});

  Chat.fromJson(Map<String, dynamic> json)
      : this.sessionOwnerId = json["sessionOwnerId"],
        this.receiverUserId = json["receiverUserId"],
        this.receiverDisplayName = json["receiverDisplayName"],
        this.lastMessage = json["lastMessage"],
        this.createdTime =
            DatetimeHelper.toDateTimeFromTimeStamp(json["createdTime"]),
        this.receiverPhotoUrl = json["receiverPhotoUrl"],
        this.fromMe = json["fromMe"];

  Map<String, dynamic> toJson() {
    return {
      "sessionOwnerId": this.sessionOwnerId,
      "receiverUserId": this.receiverUserId,
      "receiverDisplayName": this.receiverDisplayName,
      "lastMessage": this.lastMessage,
      "createdTime": DatetimeHelper.toTimeStampFromDateTime(createdTime),
      "receiverPhotoUrl": this.receiverPhotoUrl,
      "fromMe": this.fromMe
    };
  }
}
