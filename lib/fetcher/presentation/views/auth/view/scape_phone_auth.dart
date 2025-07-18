import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat/core/config/config_app.dart';
import 'package:my_chat/fetcher/domian/auth/auth_cubit.dart';
import 'package:my_chat/fetcher/presentation/views/auth/widget/button_auth.dart';
import 'package:my_chat/fetcher/presentation/views/auth/widget/image_auth.dart';
import 'package:my_chat/fetcher/presentation/views/auth/widget/input_field_auth.dart';
import 'package:my_chat/fetcher/presentation/views/splach/splash_view.dart';

class ScapePhoneAuth extends StatefulWidget {
  const ScapePhoneAuth({super.key});

  @override
  State<ScapePhoneAuth> createState() => _ScapePhoneAuthState();
}

class _ScapePhoneAuthState extends State<ScapePhoneAuth> {
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ConfigApp.initConfig(context);
    double height = ConfigApp.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: formKey,

            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    kToolbarHeight -
                    MediaQuery.of(context).padding.top,
              ),
              child: Column(
                children: [
                  SizedBox(height: height * 0.1),
                  ImageAuth(),
                  SizedBox(height: height * 0.08),
                  InputFieldAuth(
                    controller: nameController,
                    title: 'Name',
                    icon: Icons.person,
                    obscureText: false,
                  ),

                  SizedBox(height: height * 0.3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ButtonAuth(
                        isW: false,
                        title: 'متابعة',
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();

                            final authCubit = context.read<AuthCubit>();
                            authCubit.updateName(nameController.text);
                            authCubit.updateImage(await authCubit.imageUrl());

                            if (!context.mounted) return;

                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const SplashView(),
                              ),
                            );
                          }
                        },
                        icon: Icons.save,
                      ),
                      const SizedBox(width: 16),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const SplashView(),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        label: Text(
                          'تخطى',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
