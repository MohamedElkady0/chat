import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class InputPhone extends StatefulWidget {
  const InputPhone({super.key});

  @override
  State<InputPhone> createState() => _InputPhoneState();
}

class _InputPhoneState extends State<InputPhone> {
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String initialCountry = 'EG';
  PhoneNumber number = PhoneNumber(isoCode: 'EG');

  String? _verificationId;

  void sendOtp() async {
    if (phoneController.text.trim().isEmpty) {
      return;
    }
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  void verifyOtp() async {
    final otp = _otpController.text.trim();
    if (_verificationId == null) {
      return;
    }
    if (otp.isEmpty) {
      return;
    }
    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: otp,
    );
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      debugPrint('Error verifying OTP: $e');
      // Handle error, e.g., show a snackbar or dialog
    }
  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number = await PhoneNumber.getRegionInfoFromPhoneNumber(
      phoneNumber,
      'US',
    );

    setState(() {
      this.number = number;
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      height: MediaQuery.of(context).size.height * .09,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[900],
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: InternationalPhoneNumberInput(
        textStyle: const TextStyle(color: Colors.white),
        onInputChanged: (PhoneNumber number) {
          this.number = number;
        },
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'يرجى إدخال رقم الهاتف';
          }
          return null;
        },
        onInputValidated: (bool value) {},
        selectorConfig: const SelectorConfig(
          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
          useBottomSheetSafeArea: true,
        ),
        ignoreBlank: false,
        autoValidateMode: AutovalidateMode.disabled,
        selectorTextStyle: const TextStyle(color: Colors.grey),
        initialValue: number,
        textFieldController: phoneController,
        formatInput: true,
        keyboardType: const TextInputType.numberWithOptions(
          signed: true,
          decimal: true,
        ),
        inputBorder: const OutlineInputBorder(),
        onSaved: (PhoneNumber number) {},
        inputDecoration: const InputDecoration(
          hintText: 'Enter Your Phone Number',
          hintStyle: TextStyle(color: Colors.grey),
          suffixIcon: Icon(Icons.phone, color: Colors.grey),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 152, 2, 252)),
          ),
        ),
      ),
    );
  }
}
