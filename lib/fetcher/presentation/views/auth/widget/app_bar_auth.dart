import 'package:flutter/material.dart';
import 'package:my_chat/fetcher/presentation/views/auth/widget/text_auth.dart';

class AppBarAuth extends StatelessWidget implements PreferredSizeWidget {
  const AppBarAuth({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: TextAuth(data: title),
      actions: [Image.asset('assets/images/slack.png')],

      centerTitle: true,
      backgroundColor: Colors.black54,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
