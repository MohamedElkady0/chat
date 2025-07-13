import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat/core/config/config_app.dart';
import 'package:my_chat/core/config/fixed_sizes_app.dart';
import 'package:my_chat/fetcher/domian/auth/auth_cubit.dart';
import 'package:my_chat/fetcher/presentation/views/auth/view/forget_password_page.dart';
import 'package:my_chat/fetcher/presentation/views/auth/widget/app_bar_auth.dart';
import 'package:my_chat/fetcher/presentation/views/auth/widget/button_auth.dart';
import 'package:my_chat/fetcher/presentation/views/auth/widget/input_field_auth.dart';
import 'package:my_chat/fetcher/presentation/views/splach/splash_view.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool visibility = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
            appBar: AppBarAuth(title: 'Login'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            extendBodyBehindAppBar: true,
            body: Padding(
              padding: AppSpacing.horizontalM,
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(height: height * 0.2),
                      InputFieldAuth(
                        controller: emailController,
                        title: 'Email',
                        icon: Icons.email,
                        obscureText: false,
                        onSaved: (value) => emailController.text = value ?? '',
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
                        onSaved:
                            (value) => passwordController.text = value ?? '',
                      ),
                      SizedBox(height: height * 0.05),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ForgetPasswordPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Forget Password !',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.1),
                      ButtonAuth(
                        title: 'Login',
                        icon: Icons.login,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            BlocProvider.of<AuthCubit>(context).onSignIn(
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
