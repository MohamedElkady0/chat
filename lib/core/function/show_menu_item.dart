import 'package:flutter/material.dart';

Future<dynamic> menuChat(
  BuildContext context, {
  String? title,
  void Function()? onPressed,
}) {
  return showMenu(
    useRootNavigator: true,
    color: Theme.of(context).colorScheme.tertiary,
    context: context,
    items: [
      popMenu(
        context,
        title: title ?? 'الحساب',

        onPressed:
            onPressed ??
            () {
              // Navigate to accounts
            },
      ),
      popMenu(
        context,
        title: title ?? 'الاعدادات',

        onPressed:
            onPressed ??
            () {
              // Navigate to accounts
            },
      ),
      popMenu(
        context,
        title: title ?? 'المساعدة',

        onPressed:
            onPressed ??
            () {
              // Navigate to accounts
            },
      ),
      popMenu(
        context,
        title: title ?? 'تسجيل الخروج',

        onPressed:
            onPressed ??
            () {
              // Navigate to accounts
            },
      ),
    ],
    position: RelativeRect.fromLTRB(0, 0, 0, 0),
  );
}

PopupMenuItem<dynamic> popMenu(
  BuildContext context, {
  String? title,
  void Function()? onPressed,
}) {
  return PopupMenuItem(
    onTap: onPressed,
    child: Text(
      title!,
      style: TextStyle(color: Theme.of(context).colorScheme.onTertiary),
    ),
  );
}
