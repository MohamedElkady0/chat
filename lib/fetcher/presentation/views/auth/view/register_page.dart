import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_chat/core/config/config_app.dart';
import 'package:my_chat/core/config/fixed_sizes_app.dart';
import 'package:my_chat/fetcher/presentation/views/auth/widget/image_auth.dart';

import '../widget/app_bar_auth.dart';
import '../widget/button_auth.dart';
import '../widget/input_field_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool visibility = false;
  bool visibilityConfirm = false;
  bool agree = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ConfigApp.initConfig(context);
    double height = ConfigApp.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBarAuth(title: 'Register'),
        backgroundColor: Theme.of(context).primaryColor,
        extendBodyBehindAppBar: true,
        body: Padding(
          padding: AppSpacing.horizontalS,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: height * 0.15),
                ImageAuth(),
                SizedBox(height: height * 0.02),
                InputFieldAuth(
                  controller: nameController,
                  title: 'Name',
                  icon: FontAwesomeIcons.person,
                  obscureText: false,
                ),
                SizedBox(height: height * 0.02),
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
                SizedBox(height: height * 0.02),
                InputFieldAuth(
                  controller: confirmPasswordController,
                  title: 'Confirm Password',
                  icon:
                      visibilityConfirm
                          ? Icons.visibility
                          : Icons.visibility_off,

                  obscureText: visibilityConfirm,
                  onPressed:
                      () => setState(() {
                        visibilityConfirm = !visibilityConfirm;
                      }),
                ),
                SizedBox(height: height * 0.02),

                SizedBox(height: height * 0.05),
                ButtonAuth(title: 'Register', icon: Icons.person_add),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
