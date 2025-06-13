import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_chat/core/config/config_app.dart';
import 'package:my_chat/core/config/fixed_sizes_app.dart';
import 'package:my_chat/fetcher/presentation/views/auth/widget/button_auth.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late AnimationController _alignmentController;
  late Animation<Alignment> alignment;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();

    _alignmentController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    alignment = Tween<Alignment>(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    ).animate(
      CurvedAnimation(parent: _alignmentController, curve: Curves.easeInBack),
    );

    _alignmentController.repeat(reverse: true);

    super.initState();
  }

  @override
  void dispose() {
    _alignmentController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ConfigApp.initConfig(context);
    double height = ConfigApp.height;
    double width = ConfigApp.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black54,
        body: Stack(
          children: [
            AnimatedBuilder(
              animation: _alignmentController,
              builder: (BuildContext context, Widget? child) {
                return AlignTransition(
                  alignment: alignment,
                  child: Container(
                    height: height * 0.5,
                    width: width * 0.5,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/slack.png'),
                      ),
                    ),
                  ),
                );
              },
              child: SizedBox(),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.1),
                  Text(
                    'Welcome to My Chat',
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      fontFamily: GoogleFonts.praise().fontFamily,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  AppSpacing.vSpaceXXL,
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (BuildContext context, Widget? child) {
                      return Transform.scale(
                        scale: _animation.value,
                        child: Column(
                          children: [
                            ButtonAuth(
                              title: 'Login',
                              icon: FontAwesomeIcons.rightToBracket,
                              onPressed: () {},
                            ),
                            AppSpacing.vSpaceM,
                            ButtonAuth(
                              title: 'Register',
                              icon: FontAwesomeIcons.userAstronaut,
                              onPressed: () {},
                            ),
                            AppSpacing.vSpaceM,
                            ButtonAuth(
                              title: 'Google',
                              icon: FontAwesomeIcons.google,
                              onPressed: () {},
                            ),
                            AppSpacing.vSpaceM,
                            ButtonAuth(
                              title: 'Phone',
                              icon: FontAwesomeIcons.phone,
                              onPressed: () {},
                            ),
                          ],
                        ),
                      );
                    },
                    child: const SizedBox(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
