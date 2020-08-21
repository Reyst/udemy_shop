import 'package:flutter/material.dart';

Future<bool> showConfirmDialog(
  BuildContext context, {
  String title = 'Are you sure?',
  String content = 'Are you sure?',
}) => showDialog(context: context, builder: (ctx) => _createConfirmDialog(ctx, title, content));

AlertDialog _createConfirmDialog(BuildContext context, String title, String content) {
  return AlertDialog(
    title: Text(
      title,
      textAlign: TextAlign.center,
    ),
    content: Text(content),
    actions: [
      FlatButton(onPressed: () => Navigator.of(context).pop(false), child: Text('NO')),
      FlatButton(onPressed: () => Navigator.of(context).pop(true), child: Text('YES')),
    ],
  );
}
