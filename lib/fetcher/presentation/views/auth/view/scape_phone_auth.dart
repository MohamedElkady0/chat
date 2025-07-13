import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat/core/config/fixed_sizes_app.dart';
import 'package:my_chat/fetcher/data/model/user_info.dart';
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
  TextEditingController nameController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppSpacing.hSpaceXXL,
                ImageAuth(),
                AppSpacing.hSpaceL,
                InputFieldAuth(
                  controller: nameController,
                  onSaved: (value) {
                    nameController.text = value ?? '';
                  },
                  title: 'Name',
                  icon: Icons.person,
                  obscureText: false,
                ),
                Spacer(),
                Row(
                  children: [
                    ButtonAuth(
                      title: 'متابعة',
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          BlocProvider.of<AuthCubit>(
                            context,
                          ).currentUserInfo = UserInfoData(
                            name: nameController.text,
                            image:
                                await BlocProvider.of<AuthCubit>(
                                  context,
                                ).imageUrl(),
                          );
                          if (!mounted) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => SplashView(),
                              ),
                            );
                          }
                          formKey.currentState!.save();
                        }
                      },
                      icon: Icons.save,
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => SplashView()),
                        );
                      },
                      icon: Icon(Icons.arrow_forward_ios),
                      label: const Text('تخطى'),
                    ),
                  ],
                ),
                AppSpacing.hSpaceM,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
