import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

void handleError(BuildContext context, DioError error, void Function() onYes) {
  String msg = error.message;
  if (error.type == DioErrorType.CONNECT_TIMEOUT) {
    msg = 'Connection Timeout';
  }

  else if (error.type == DioErrorType.RECEIVE_TIMEOUT) {
    msg = 'Receive Timeout';
  }

  else if (error.type == DioErrorType.RESPONSE) {
    msg = 'Error occurred - ${error.response.statusCode}';
  }

  showCupertinoDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(''),
        content: Text('$msg. Do you want to retry ?'),
        actions: <Widget>[
          CupertinoButton(
            child: Text('NO'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoButton(
            child: Text('YES'),
            onPressed: () {
              Navigator.of(context).pop();
              onYes();
            },
          ),
        ],
      );
    }
  );
}