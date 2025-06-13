import 'package:flutter/material.dart';
import 'package:my_chat/core/config/config_app.dart';
import 'package:my_chat/core/utils/auth_string.dart';

import '../widget/app_bar_auth.dart';
import '../widget/button_auth.dart';
import '../widget/input_field_auth.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ConfigApp.initConfig(context);
    double height = ConfigApp.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBarAuth(title: 'Password Recovery'),
        backgroundColor: Theme.of(context).primaryColor,
        extendBodyBehindAppBar: true,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: height * 0.1),
                Image.asset(
                  AuthString.forgetpasswordImage,
                  height: height * 0.3,
                ),
                SizedBox(height: height * 0.1),
                InputFieldAuth(
                  controller: emailController,
                  title: 'Email',
                  icon: Icons.email,
                  obscureText: false,
                ),

                SizedBox(height: height * 0.1),
                ButtonAuth(title: AuthString.resetPassword, icon: Icons.login),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
