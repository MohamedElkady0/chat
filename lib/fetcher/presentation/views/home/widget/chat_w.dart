import 'package:flutter/material.dart';
import 'package:my_chat/core/config/config_app.dart';
import 'package:my_chat/fetcher/presentation/views/home/widget/knowing_friend.dart';

class ChatW extends StatelessWidget {
  const ChatW({super.key});

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
        Positioned(
          left: w * 0.05,
          top: w * 0.1,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary.withAlpha(150),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.groups)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.chat)),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.web_stories),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.event_note),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
