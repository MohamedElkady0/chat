import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat/core/config/config_app.dart';
import 'package:my_chat/fetcher/domian/auth/auth_cubit.dart';
import 'package:my_chat/fetcher/presentation/views/auth/widget/button_auth.dart';
import 'package:my_chat/fetcher/presentation/views/auth/widget/check_service.dart';
import 'package:my_chat/fetcher/presentation/views/auth/widget/image_auth.dart';
import 'package:my_chat/fetcher/presentation/views/auth/widget/input_field_auth.dart';

class ScapePhoneAuth extends StatefulWidget {
  const ScapePhoneAuth({super.key});

  @override
  State<ScapePhoneAuth> createState() => _ScapePhoneAuthState();
}

class _ScapePhoneAuthState extends State<ScapePhoneAuth> {
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool check = false;

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

                  ButtonAuth(
                    isW: false,
                    title: 'متابعة',
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        final authCubit = context.read<AuthCubit>();
                        authCubit.uploadAndUpdateProfileImage();

                        authCubit.updateName(nameController.text);

                        showDialog(
                          context: context,
                          builder:
                              (context) => CheckService(
                                value: check,
                                onChanged: (val) {
                                  setState(() {
                                    check = val!;
                                  });
                                },
                              ),
                        );
                      }
                    },
                    icon: Icons.save,
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
