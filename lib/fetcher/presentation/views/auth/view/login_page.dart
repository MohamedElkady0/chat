import 'package:flutter/material.dart';
import 'package:my_chat/core/config/config_app.dart';
import 'package:my_chat/core/config/fixed_sizes_app.dart';
import 'package:my_chat/fetcher/presentation/views/auth/widget/app_bar_auth.dart';
import 'package:my_chat/fetcher/presentation/views/auth/widget/button_auth.dart';
import 'package:my_chat/fetcher/presentation/views/auth/widget/input_field_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool visibility = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ConfigApp.initConfig(context);
    double height = ConfigApp.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBarAuth(title: 'Login'),
        backgroundColor: Theme.of(context).primaryColor,
        extendBodyBehindAppBar: true,
        body: Padding(
          padding: AppSpacing.horizontalM,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: height * 0.2),
                InputFieldAuth(
                  controller: emailController,
                  title: 'Email',
                  icon: Icons.email,
                  obscureText: false,
                ),
                SizedBox(height: height * 0.02),
                InputFieldAuth(
                  controller: passwordController,
                  title: 'Password',
                  icon: visibility ? Icons.visibility : Icons.visibility_off,

                  obscureText: visibility,
                  onPressed:
                      () => setState(() {
                        visibility = !visibility;
                      }),
                ),
                SizedBox(height: height * 0.05),
                TextButton(onPressed: () {}, child: Text('Forget Password ?')),
                SizedBox(height: height * 0.1),
                ButtonAuth(title: 'Login', icon: Icons.login),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
