import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'api_manager.dart';

String dialogTitle = 'Переход на BackMoney.net';

dialogWindows(context, Map data) {

  return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            data['title'] ?? dialogTitle,
            style: TextStyle(
              fontSize: 18
            ),
          ),
          content: Text(
            data['mess']
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Нет, позже'
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                'Да, погнали'
              ),
              onPressed: () {
                final String go = 'https://' + siteUrl + data['url'];
                launch(go);
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
  );
}