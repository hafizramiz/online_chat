import '../helpers/datetime_helper.dart';

class Chat {
  final String sessionOwnerId;
  final String receiverUserId;
  final String lastMessage;
  final DateTime createdTime;
  final String receiverPhotoUrl;

  Chat({required this.sessionOwnerId,
    required this.receiverUserId,
    required this.lastMessage,
    required this.createdTime,
    required this.receiverPhotoUrl});

  Chat.fromJson(Map<String, dynamic>json)
      :
        this.sessionOwnerId=json["sessionOwnerId"],
        this.receiverUserId=json["receiverUserId"],
        this.lastMessage=json["lastMessage"],
        this.createdTime=DatetimeHelper.toDateTimeFromTimeStamp(
            json["createdTime"]),
        this.receiverPhotoUrl=json["receiverPhotoUrl"];

  Map<String, dynamic> toJson() {
    return {
    "sessionOwnerId":this.sessionOwnerId,
    "receiverUserId":this.receiverUserId,
    "lastMessage":this.lastMessage,
    "createdTime":DatetimeHelper.toTimeStampFromDateTime(createdTime),
    "receiverPhotoUrl":this.receiverPhotoUrl};
  }

}