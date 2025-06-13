import 'package:flutter/material.dart';
import 'package:my_chat/core/config/config_app.dart';
import 'package:my_chat/core/config/fixed_sizes_app.dart';
import 'package:my_chat/fetcher/presentation/views/auth/widget/input_phone.dart';

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
    ConfigApp.initConfig(context);
    double height = ConfigApp.height;
    double width = ConfigApp.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBarAuth(title: 'Phone'),
        backgroundColor: Theme.of(context).primaryColor,
        extendBodyBehindAppBar: true,
        body: Padding(
          padding: AppSpacing.horizontalS,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: height * 0.1),
                Image.asset(
                  'assets/images/smartphone.png',
                  gaplessPlayback: true,
                  width: width * 0.3,
                  height: height * 0.3,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: height * 0.1),
                InputPhone(),
                SizedBox(height: height * 0.1),
                ButtonAuth(title: 'Send', icon: Icons.phone_callback),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
