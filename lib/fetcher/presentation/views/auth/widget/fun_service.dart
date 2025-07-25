import 'package:flutter/material.dart';
import 'package:my_chat/fetcher/presentation/views/auth/widget/check_service.dart';

Future<bool?> funService(
  BuildContext context, {
  required bool initialAgreeValue,
}) {
  bool agree = initialAgreeValue;
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter dialogSetState) {
          return CheckService(
            value: agree,
            onChanged: (val) {
              dialogSetState(() {
                agree = val!;
              });
            },

            onPressed: () {
              if (agree) {
                Navigator.of(context).pop(true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('يجب الموافقة على الشروط أولاً'),
                  ),
                );
              }
            },

            onCancel: () {
              Navigator.of(context).pop(false);
            },
          );
        },
      );
    },
  );
}
