import 'package:flutter/material.dart';
import 'package:my_chat/fetcher/presentation/views/home/widget/chat_w.dart';
import 'package:my_chat/fetcher/presentation/views/home/widget/enjoyment.dart';
import 'package:my_chat/fetcher/presentation/views/home/widget/news.dart';
import 'package:my_chat/fetcher/presentation/views/home/widget/shop.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> items = [ChatW(), News(), Shop(), Enjoyment()];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // الوصول إلى الـ provider لتغيير السمة

    return Scaffold(
      body: items[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items:
            items.map((item) {
              return BottomNavigationBarItem(
                backgroundColor:
                    item is ChatW
                        ? Theme.of(context).colorScheme.primary
                        : item is News
                        ? Theme.of(context).colorScheme.secondary
                        : item is Shop
                        ? Theme.of(context).colorScheme.tertiary
                        : Theme.of(context).colorScheme.primaryContainer,
                icon: Icon(
                  item is ChatW
                      ? Icons.chat
                      : item is News
                      ? Icons.newspaper
                      : item is Shop
                      ? Icons.shopping_cart
                      : Icons.star,
                ),
                label: item.runtimeType.toString(),
              );
            }).toList(),
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
