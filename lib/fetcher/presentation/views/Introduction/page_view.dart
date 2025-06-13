import 'package:flutter/material.dart';
import 'package:my_chat/core/config/config_app.dart';
import 'package:my_chat/core/config/fixed_sizes_app.dart';
import 'package:my_chat/fetcher/presentation/views/Introduction/data/pageview_data.dart';
import 'package:my_chat/fetcher/presentation/views/Introduction/widget/background_page.dart';
import 'package:my_chat/fetcher/presentation/views/Introduction/widget/blur_background.dart';

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
    ConfigApp.initConfig(context);
    double width = ConfigApp.width;

    return SafeArea(
      minimum: EdgeInsets.symmetric(vertical: 8),
      child: Scaffold(
        floatingActionButton:
            _currentIndex < pageViewData.length - 1
                ? FloatingActionButton(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
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
                    SizedBox(height: AppSpacing.vSpaceXXS.height),
                    Image.asset(
                      pageViewData[index].image!,
                      fit: BoxFit.fill,
                      width: width * 0.5,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.horizontalXS.horizontal,
                      ),
                      child: Text(
                        pageViewData[index].title!,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displayMedium!
                            .copyWith(color: Colors.white54),
                      ),
                    ),
                    if (index == pageViewData.length - 1)
                      ElevatedButton(
                        style: Theme.of(context).elevatedButtonTheme.style,
                        onPressed: () {},
                        child: Text(
                          'Get Started',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    SizedBox(height: AppSpacing.vSpaceXXS.height),
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
