import 'package:flutter/material.dart';
import 'package:my_chat/fetcher/presentation/views/chat/widget/pop_menu.dart';

class PopChats extends StatelessWidget {
  const PopChats({
    super.key,
    required this.index,
    required this.title,
    this.images,
    this.chats,
    this.dates,
    this.onTap,
    required this.isMenu,
  });

  final int index;
  final List<String> title;
  final List<String>? images;
  final List<String>? chats;
  final List<String>? dates;
  final bool isMenu;
  final List<void Function()>? onTap;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<dynamic>(
      itemBuilder: (context) {
        return [
          for (int i = 0; i < index; i++)
            isMenu
                ? popMenu(
                  context,
                  isMenu: true,
                  title: title[i],
                  onTap: onTap?[i] ?? () {},
                )
                : popMenu(
                  context,
                  isMenu: false,
                  title: title[i],
                  image: images?[i] ?? '',
                  chat: chats?[i] ?? '',
                  date: dates?[i] ?? '',
                  onTap: onTap?[i] ?? () {},
                ),
        ];
      },
      onSelected: (value) {
        print('Selected: $value');
      },
      color: Theme.of(context).colorScheme.tertiary,
      offset: isMenu ? const Offset(50, 0) : const Offset(50, -97),
      icon:
          isMenu
              ? const Icon(Icons.menu)
              : const Icon(Icons.chat_bubble_outline),
    );
  }
}
