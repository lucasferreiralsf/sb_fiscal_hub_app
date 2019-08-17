import 'package:flutter/material.dart';

class FetchedData<T> {
  bool error;
  int statusCode;
  String message;
  dynamic data;

  FetchedData({@required this.error, @required this.statusCode, @required this.message, @required this.data});
}

// Map<String, Test> fetchedData(
//     {@required bool error,
//     @required int statusCode,
//     @required String message,
//     @required dynamic data}) {
//   return {
//     'error': error,
//     'statusCode': statusCode,
//     'message': message,
//     'data': data,
//   };
// }
