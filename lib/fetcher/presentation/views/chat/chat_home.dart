import 'package:flutter/material.dart';
import 'package:my_chat/core/config/config_app.dart';
import 'package:my_chat/fetcher/presentation/views/chat/widget/knowing_friend.dart';
import 'package:my_chat/fetcher/presentation/views/chat/widget/search_app.dart';
import 'package:my_chat/fetcher/presentation/views/chat/widget/side_bar_chat.dart';

class ChatW extends StatefulWidget {
  const ChatW({super.key});

  @override
  State<ChatW> createState() => _ChatWState();
}

class _ChatWState extends State<ChatW> {
  @override
  Widget build(BuildContext context) {
    ConfigApp.initConfig(context);
    double w = ConfigApp.width;
    double h = ConfigApp.height;
    return Stack(
      children: [
        MapScreen(),
        Container(
          height: h,
          width: w,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary.withAlpha(30),
          ),
        ),
        Positioned(
          top: w * 0.1,
          left: w * 0.05 + 60,
          right: w * 0.05,
          child: SearchApp(),
        ),

        Positioned(
          bottom: w * 0.1,
          left: w * 0.05,
          right: w * 0.05,
          child: ElevatedButton.icon(
            style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
              backgroundColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.tertiary.withAlpha(100),
              ),
              foregroundColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.onTertiary,
              ),
            ),
            onPressed: () {},
            icon: const Icon(Icons.airplanemode_on),
            label: const Text('رحله جديدة'),
          ),
        ),
        Positioned(left: w * 0.05, top: w * 0.1, child: SideBarChat()),
      ],
    );
  }
}
