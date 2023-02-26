import 'package:online_chat/helpers/datetime_helper.dart';

class Message {
  final String content;
  bool fromMe;
  final DateTime createdTime;


  Message({required this.content,
    required this.fromMe,
    required this.createdTime
  });

  Message.fromJson(Map<String, dynamic> json) :
        this.content = json["content"],
        this.fromMe = json["fromMe"],
  this.createdTime=DatetimeHelper.toDateTimeFromTimeStamp(json["createdTime"]);

  Map<String, dynamic> toJson() {
    return {"content": this.content,
      "fromMe":this.fromMe,
      "createdTime":DatetimeHelper.toTimeStampFromDateTime(createdTime),
    };
  }
}
