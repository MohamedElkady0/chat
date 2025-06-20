import 'package:flutter/material.dart';
import 'package:my_chat/core/config/config_app.dart';
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
  int _currentIndex = 0;

  List<Widget> pages = [ChatW(), News(), Shop(), Enjoyment()];

  @override
  Widget build(BuildContext context) {
    ConfigApp.initConfig(context);
    double w = ConfigApp.width;

    return SafeArea(
      child: Scaffold(
        body: pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          type: BottomNavigationBarType.shifting,
          selectedIconTheme: Theme.of(context).iconTheme.copyWith(
            color: Theme.of(context).colorScheme.onTertiary,
            size: w * 0.08,
          ),
          selectedItemColor: Theme.of(context).colorScheme.onTertiary,
          unselectedItemColor: Theme.of(context).colorScheme.primary,

          unselectedIconTheme: Theme.of(context).iconTheme.copyWith(
            color: Theme.of(context).colorScheme.primary,
            size: w * 0.05,
          ),

          onTap: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'الدردشات',
              backgroundColor: Theme.of(context).colorScheme.tertiary,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'المتجر',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.newspaper),
              label: 'الأخبار',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: 'ترفيه'),
          ],
        ),
      ),
    );
  }
}
