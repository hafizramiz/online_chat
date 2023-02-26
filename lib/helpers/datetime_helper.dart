import 'package:cloud_firestore/cloud_firestore.dart';

class DatetimeHelper{
  static  Timestamp toTimeStampFromDateTime(DateTime pickedDate){
    Timestamp myTimeStamp = Timestamp.fromDate(pickedDate);
    return myTimeStamp;
  }
  static DateTime toDateTimeFromTimeStamp(Timestamp timestamp){
    DateTime myDateTime=timestamp.toDate();
    return myDateTime;
  }
}