import 'package:flutter/material.dart';
import 'package:my_chat/fetcher/presentation/views/auth/widget/input_phone.dart';

import '../../../../../core/theme/color_theme_app.dart';

import '../widget/app_bar_auth.dart';
import '../widget/button_auth.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({super.key});

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBarAuth(title: 'Phone'),
        backgroundColor: ColorThemeApp.backgroundColor,
        extendBodyBehindAppBar: true,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Image.asset(
                  'assets/images/smartphone.png',
                  gaplessPlayback: true,
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.width * 0.5,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                InputPhone(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                ButtonAuth(title: 'Send', icon: Icons.phone_callback),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
