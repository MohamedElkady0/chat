import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_chat/core/config/config_app.dart';
import 'package:my_chat/core/config/fixed_sizes_app.dart';
import 'package:my_chat/fetcher/domian/auth/auth_cubit.dart';
import 'package:my_chat/fetcher/presentation/views/auth/widget/image_auth.dart';
import 'package:my_chat/fetcher/presentation/views/splach/splash_view.dart';

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
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          Center(child: CircularProgressIndicator());
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is AuthSuccess) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => SplashView()),
          );
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBarAuth(title: 'Register'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            extendBodyBehindAppBar: true,
            body: Padding(
              padding: AppSpacing.horizontalS,
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
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
                        onSaved: (value) {
                          nameController.text = value ?? '';
                        },
                      ),
                      SizedBox(height: height * 0.02),
                      InputFieldAuth(
                        controller: emailController,
                        title: 'Email',
                        icon: Icons.email,
                        obscureText: false,
                        onSaved: (value) {
                          emailController.text = value ?? '';
                        },
                      ),
                      SizedBox(height: height * 0.02),
                      InputFieldAuth(
                        controller: passwordController,
                        title: 'Password',

                        icon:
                            visibility
                                ? Icons.visibility
                                : Icons.visibility_off,

                        obscureText: visibility,
                        onPressed:
                            () => setState(() {
                              visibility = !visibility;
                            }),
                        onSaved: (value) {
                          passwordController.text = value ?? '';
                        },
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
                        onSaved:
                            (value) =>
                                confirmPasswordController.text = value ?? '',
                      ),
                      SizedBox(height: height * 0.02),

                      SizedBox(height: height * 0.05),
                      ButtonAuth(
                        title: 'Register',
                        icon: Icons.person_add,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            BlocProvider.of<AuthCubit>(context).onSignUp(
                              name: nameController.text,
                              email: emailController.text,
                              password: passwordController.text,
                            );
                            formKey.currentState!.save();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please fill all fields')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
