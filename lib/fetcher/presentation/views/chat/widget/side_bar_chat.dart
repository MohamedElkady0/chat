import 'package:flutter/material.dart';
import 'package:my_chat/fetcher/presentation/views/chat/widget/pop_chats.dart';

class SideBarChat extends StatelessWidget {
  const SideBarChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary.withAlpha(150),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PopChats(
            index: 4,
            title: ['الحساب', 'الاعدادات', 'المساعدة', 'تسجيل الخروج'],
            isMenu: true,
            onTap: [() {}, () {}, () {}, () {}],
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.groups)),
          PopChats(
            isMenu: false,
            index: 16,
            title: [
              'Ali',
              'Adel',
              'Samy',
              'Mohamed',
              'Ali',
              'Adel',
              'Samy',
              'Mohamed',
              'Ali',
              'Adel',
              'Samy',
              'Mohamed',
              'Ali',
              'Adel',
              'Samy',
              'Mohamed',
            ],
            images: [
              'assets/images/chat.png',
              'assets/images/house.png',
              'assets/images/slack.png',
              'assets/images/translate.png',
              'assets/images/chat.png',
              'assets/images/house.png',
              'assets/images/slack.png',
              'assets/images/translate.png',
              'assets/images/chat.png',
              'assets/images/house.png',
              'assets/images/slack.png',
              'assets/images/translate.png',
              'assets/images/chat.png',
              'assets/images/house.png',
              'assets/images/slack.png',
              'assets/images/translate.png',
            ],
            chats: [
              'Hello world',
              'Hello world',
              'Hello world',
              'Hello world',
              'Hello world',
              'Hello world',
              'Hello world',
              'Hello world',
              'Hello world',
              'Hello world',
              'Hello world',
              'Hello world',
              'Hello world',
              'Hello world',
              'Hello world',
              'Hello world',
            ],
            dates: [
              'today',
              'yesterday',
              '2 days ago',
              '3 days ago',
              'today',
              'yesterday',
              '2 days ago',
              '3 days ago',
              'today',
              'yesterday',
              '2 days ago',
              '3 days ago',
              'today',
              'yesterday',
              '2 days ago',
              '3 days ago',
            ],
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.web_stories)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.event_note)),
        ],
      ),
    );
  }
}
