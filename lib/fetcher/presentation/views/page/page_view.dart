import 'package:flutter/material.dart';
import 'package:my_chat/core/utils/pageview_string.dart';
import 'package:my_chat/fetcher/presentation/views/page/widget/background_page.dart';
import 'package:my_chat/fetcher/presentation/views/page/widget/blur_background.dart';

class PageViewMyChat extends StatefulWidget {
  const PageViewMyChat({super.key});

  @override
  State<PageViewMyChat> createState() => _PageViewMyChatState();
}

class _PageViewMyChatState extends State<PageViewMyChat> {
  PageController? _pageController;
  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        clipBehavior: Clip.none,
        controller: _pageController,
        onPageChanged: (index) {},
        itemCount: 4,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              BackgroundPage(),
              BlurBackground(),
              Center(
                child: Text(
                  'Page ${index + 1}',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Image.asset(
                PageViewString.pageview1,
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),
            ],
          );
        },
      ),
    );
  }
}
