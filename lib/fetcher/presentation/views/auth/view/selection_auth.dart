import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectionAuth extends StatefulWidget {
  const SelectionAuth({super.key});

  @override
  State<SelectionAuth> createState() => _SelectionAuthState();
}

class _SelectionAuthState extends State<SelectionAuth>
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
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 0.5,
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Text(
                    'Welcome to My Chat',
                    style: GoogleFonts.praise(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (BuildContext context, Widget? child) {
                      return Transform.scale(
                        scale: _animation.value,
                        child: Column(
                          children: [
                            ElevatedButton.icon(
                              icon: Icon(FontAwesomeIcons.signInAlt, size: 24),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(200, 50),
                              ),
                              onPressed: () {
                                // Navigate to login page
                              },
                              label: Text(
                                ' Login',
                                style: GoogleFonts.praise(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton.icon(
                              icon: Icon(FontAwesomeIcons.user, size: 24),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(200, 50),
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                // Navigate to registration page
                              },
                              label: Text(
                                'Register',
                                style: GoogleFonts.praise(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton.icon(
                              icon: Icon(FontAwesomeIcons.google, size: 24),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(200, 50),
                              ),
                              onPressed: () {
                                // Navigate to registration page
                              },
                              label: Text(
                                'Google',
                                style: GoogleFonts.praise(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton.icon(
                              icon: Icon(FontAwesomeIcons.phone, size: 24),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(200, 50),
                              ),
                              onPressed: () {
                                // Navigate to registration page
                              },
                              label: Text(
                                'Phone',
                                style: GoogleFonts.praise(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const SizedBox(height: 20),
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
