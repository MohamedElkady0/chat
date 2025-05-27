import 'package:flutter/material.dart';

class PageViewMyChat extends StatefulWidget {
  const PageViewMyChat({super.key});

  @override
  State<PageViewMyChat> createState() => _PageViewMyChatState();
}

class _PageViewMyChatState extends State<PageViewMyChat>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> colorAnim1;
  late Animation<Color?> colorAnim2;
  late Animation<Color?> colorAnim3;

  late Animation<Alignment> topAlignmentAnimation;
  late Animation<Alignment> bottomAlignmentAnimation;

  PageController? _pageController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    topAlignmentAnimation = AlignmentTween(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.decelerate),
    );

    bottomAlignmentAnimation = AlignmentTween(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.decelerate),
    );

    colorAnim1 = ColorTween(
      begin: Colors.deepPurple,
      end: Colors.lightBlueAccent,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.slowMiddle),
    );

    colorAnim2 = ColorTween(
      begin: Colors.pinkAccent,
      end: Colors.greenAccent,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.slowMiddle),
    );

    colorAnim3 = ColorTween(begin: Colors.amber, end: Colors.redAccent).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.slowMiddle),
    );

    _animationController.repeat(reverse: true);

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animationController,
        builder:
            (context, child) => Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: topAlignmentAnimation.value,
                  end: bottomAlignmentAnimation.value,
                  colors: [
                    colorAnim1.value ?? Colors.transparent,
                    colorAnim2.value ?? Colors.transparent,
                    colorAnim3.value ?? Colors.transparent,
                  ],
                ),
              ),
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _animationController.value = index.toDouble();

                    ///edit
                  });
                },
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Center(
                    child: Text(
                      'Page ${index + 1}',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
      ),
    );
  }
}
