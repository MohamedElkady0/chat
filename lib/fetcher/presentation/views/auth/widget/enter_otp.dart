import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat/fetcher/domian/auth/auth_cubit.dart';

class EnterOTP extends StatelessWidget {
  const EnterOTP({super.key, required this.otpController});
  final TextEditingController otpController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.close),
      ),
      backgroundColor: Colors.grey,
      title: const Text("تحقق من الرقم المرسل"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: otpController,

            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'يرجى إدخال الرمز';
              }
              if (value.length < 6) {
                return 'الرمز يجب أن يكون 6 أرقام';
              }
              return null;
            },
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "أدخل OTP"),
          ),
          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              final otpCode = otpController.text.trim();
              if (otpCode.isNotEmpty) {
                BlocProvider.of<AuthCubit>(context).setOtp(otpCode);

                BlocProvider.of<AuthCubit>(context).verifyOtp();
              }
            },
            child: const Text("تحقق"),
          ),

          TextButton(
            onPressed: () {
              Navigator.of(context).pop();

              BlocProvider.of<AuthCubit>(context).sendOtp();
            },
            child: const Text(
              "إعادة إرسال الرمز",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
