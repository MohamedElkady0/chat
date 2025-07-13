import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat/core/config/config_app.dart';
import 'package:my_chat/core/config/fixed_sizes_app.dart';
import 'package:my_chat/fetcher/domian/auth/auth_cubit.dart';
import 'package:my_chat/fetcher/presentation/views/auth/view/scape_phone_auth.dart';
import 'package:my_chat/fetcher/presentation/views/auth/widget/input_phone.dart';
import '../widget/app_bar_auth.dart';
import '../widget/button_auth.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({super.key});

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ConfigApp.initConfig(context);
    double height = ConfigApp.height;
    double width = ConfigApp.width;
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
            MaterialPageRoute(builder: (context) => ScapePhoneAuth()),
          );
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBarAuth(title: 'Phone'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            extendBodyBehindAppBar: true,
            body: Padding(
              padding: AppSpacing.horizontalS,
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
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
                      InputPhone(phoneController: phoneController),
                      SizedBox(height: height * 0.1),
                      ButtonAuth(
                        title: 'Send',
                        icon: Icons.phone_callback,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            BlocProvider.of<AuthCubit>(context).sendOtp();
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder:
                                  (context) => AlertDialog.adaptive(
                                    icon: IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: Icon(Icons.close),
                                    ),
                                    title: const Text(
                                      'Please check your phone',
                                    ),
                                    content: TextFormField(
                                      autofocus: true,
                                      controller: otpController,
                                      keyboardType: TextInputType.number,
                                      onSaved: (newValue) {
                                        BlocProvider.of<AuthCubit>(context)
                                            .otp = newValue ?? '';
                                      },
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            BlocProvider.of<AuthCubit>(
                                              context,
                                            ).verifyOtp();
                                            Navigator.of(
                                              context,
                                            ).pushReplacement(
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        ScapePhoneAuth(),
                                              ),
                                            );
                                            formKey.currentState!.save();
                                          }
                                        },
                                        child: const Text('OK'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          BlocProvider.of<AuthCubit>(
                                            context,
                                          ).sendOtp();
                                        },
                                        child: const Text('ارسل من جديد'),
                                      ),
                                    ],
                                  ),
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
