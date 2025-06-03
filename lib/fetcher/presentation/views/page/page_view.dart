import 'package:flutter/material.dart';
import 'package:my_chat/fetcher/presentation/views/page/data/pageview_data.dart';
import 'package:my_chat/fetcher/presentation/views/page/widget/background_page.dart';
import 'package:my_chat/fetcher/presentation/views/page/widget/blur_background.dart';

class PageViewMyChat extends StatefulWidget {
  const PageViewMyChat({super.key});

  @override
  State<PageViewMyChat> createState() => _PageViewMyChatState();
}

class _PageViewMyChatState extends State<PageViewMyChat> {
  final PageController _controller = PageController(initialPage: 0);
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Timer.periodic(const Duration(seconds: 6), (timer) {
    //   if (_currentIndex < pageViewData.length) _currentIndex++;

    //   _controller.animateToPage(
    //     _currentIndex,
    //     duration: const Duration(milliseconds: 300),
    //     curve: Curves.easeIn,
    //   );
    // });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.symmetric(vertical: 8),
      child: Scaffold(
        floatingActionButton:
            _currentIndex < pageViewData.length - 1
                ? FloatingActionButton(
                  onPressed: () {
                    _controller.animateToPage(
                      _currentIndex + 1,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: const Icon(Icons.arrow_downward),
                )
                : Container(),
        body: PageView.builder(
          scrollDirection: Axis.vertical,
          clipBehavior: Clip.none,
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          itemCount: pageViewData.length,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                BackgroundPage(),
                BlurBackground(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    SizedBox(height: 20),
                    Image.asset(
                      pageViewData[index].image!,
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width * 0.5,
                    ),
                    Text(
                      pageViewData[index].title!,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (index == pageViewData.length - 1)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 32,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    SizedBox(height: 20),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
