import 'package:bloc/bloc.dart';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:latlong2/latlong.dart';
import 'package:my_chat/fetcher/data/model/user_info.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  UserInfoData? _currentUserInfo;

  UserInfoData? get currentUserInfo => _currentUserInfo;

  bool isRegister = true;
  File? img;
  final String _otp = '';
  String? _verificationId;
  PhoneNumber? number;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _credential = FirebaseAuth.instance;

  LatLng? _currentPosition;
  String _currentAddress = 'لم يتم تحديد العنوان بعد';
  MapController? _mapController;
  bool _isLoading = true;

  // ignore: unused_element
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _currentAddress = 'خدمات الموقع معطلة. يرجى تفعيلها.';
      _isLoading = false;

      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _currentAddress = 'تم رفض إذن الوصول للموقع.';
        _isLoading = false;

        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _currentAddress =
          'تم رفض إذن الوصول للموقع بشكل دائم. يرجى تفعيله من إعدادات التطبيق.';
      _isLoading = false;

      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final newPosition = LatLng(position.latitude, position.longitude);

      _currentPosition = newPosition;
      _isLoading = false;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_currentPosition != null) {
          _mapController?.move(_currentPosition!, 2.0);
        }
      });

      _getAddressFromLatLng(position);
    } catch (e) {
      debugPrint("Error getting location: $e");
      // if (!mounted) return;

      _currentAddress = "خطأ في تحديد الموقع: ${e.toString()}";
      _isLoading = false;
    }
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        _currentAddress = '${place.country},${place.street},${place.locality}';
      }
    } catch (e) {
      debugPrint(e.toString());

      _currentAddress = "لا يمكن جلب العنوان";
    }
  }

  void onSignUp() async {
    emit(AuthLoading());

    try {
      await _credential.createUserWithEmailAndPassword(
        email: _currentUserInfo?.email ?? '',
        password: _currentUserInfo?.password ?? '',
      );

      if (img == null) {
        emit(AuthFailure(message: 'Please select an image.'));
        return;
      }

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('UserImages')
          .child('${_credential.currentUser!.uid}.png');
      await storageRef.putFile(img!);
      final imgUrl = await storageRef.getDownloadURL();

      final userInfo = UserInfoData(
        image: imgUrl,
        email: _currentUserInfo?.email ?? '',
        password: _currentUserInfo?.password ?? '',

        phoneNumber: number?.phoneNumber ?? '',
        userId: _credential.currentUser!.uid,
        name: _currentUserInfo?.name ?? '',
        friends: _currentUserInfo?.friends ?? [],
        userPlace:
            '${_currentPosition?.latitude}-${_currentPosition?.longitude}',
        userCity:
            '${_currentAddress.split(',')[1]}-${_currentAddress.split(',')[2]}',
        userCountry: _currentAddress.split(',')[0],
      );

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(_credential.currentUser!.uid)
          .set(userInfo.toJson());

      _currentUserInfo = userInfo;
      emit(AuthSuccess(userInfo: _currentUserInfo!));
    } on FirebaseAuthException {
      emit(
        AuthFailure(
          message: 'Error creating user: ${_credential.currentUser!.email}',
        ),
      );
    } on FirebaseException catch (e) {
      emit(AuthFailure(message: 'Error uploading image: ${e.message}'));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  void onSignIn() async {
    emit(AuthLoading());
    try {
      await _credential.signInWithEmailAndPassword(
        email: _currentUserInfo?.email ?? '',
        password: _currentUserInfo?.password ?? '',
      );

      final userDoc =
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(_credential.currentUser!.uid)
              .get();

      if (userDoc.exists) {
        _currentUserInfo = UserInfoData.fromJson(userDoc.data()!);
      } else {
        emit(
          state is AuthInitial
              ? AuthFailure(message: 'User does not exist.')
              : AuthFailure(message: 'User data not found.'),
        );
        return;
      }

      emit(AuthSuccess(userInfo: _currentUserInfo!));
    } on FirebaseAuthException {
      emit(
        AuthFailure(
          message: 'Error signing in: ${_credential.currentUser!.email}',
        ),
      );
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  signInWithGoogle() async {
    emit(AuthLoading());
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        emit(AuthFailure(message: 'Google sign-in cancelled by user.'));
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _credential
          .signInWithCredential(credential);

      UserInfoData userInfo = UserInfoData(
        userId: userCredential.user!.uid,
        name: userCredential.user!.displayName ?? '',
        email: userCredential.user!.email ?? '',
        phoneNumber: userCredential.user!.phoneNumber ?? '',
        image: userCredential.user!.photoURL ?? '',
        friends: _currentUserInfo?.friends ?? [],
        userPlace:
            '${_currentPosition?.latitude}-${_currentPosition?.longitude}',
        userCity:
            '${_currentAddress.split(',')[1]}-${_currentAddress.split(',')[2]}',
        userCountry: _currentAddress.split(',')[0],
      );

      final userDoc =
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(userCredential.user!.uid)
              .get();

      if (userDoc.exists) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userCredential.user!.uid)
            .update(userInfo.toJson());
      } else {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userCredential.user!.uid)
            .set(userInfo.toJson());
      }
      _currentUserInfo = userInfo;
      emit(AuthSuccess(userInfo: _currentUserInfo!));
    } catch (e) {
      if (e is FirebaseAuthException) {
        emit(AuthFailure(message: e.message ?? 'خطأ في تسجيل الدخول'));
      } else {
        emit(AuthFailure(message: 'خطأ غير معروف: ${e.toString()}'));
      }
    }
  }

  void sendOtp() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _currentUserInfo?.phoneNumber ?? '',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        _currentUserInfo = _currentUserInfo?.copyWith(
          userId: _credential.currentUser!.uid,
          phoneNumber: _currentUserInfo?.phoneNumber ?? '',
        );
        emit(AuthSuccess(userInfo: _currentUserInfo!));
      },
      verificationFailed: (FirebaseAuthException e) {
        emit(AuthFailure(message: "فشل التحقق: ${e.message}"));
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        emit(AuthFailure(message: "تم إرسال OTP!"));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  void verifyOtp() async {
    if (_verificationId == null) {
      emit(AuthFailure(message: "لم يتم إرسال OTP بعد."));

      return;
    }
    if (_otp.isEmpty) {
      emit(AuthFailure(message: "يرجى إدخال رمز التحقق."));
      return;
    }
    print('otp قبل التحقق =============================== $_otp');
    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: _otp,
    );
    print('otp=============================== $_otp');
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      _currentUserInfo = _currentUserInfo?.copyWith(
        phoneNumber: _currentUserInfo?.phoneNumber ?? '',
        userId: _credential.currentUser!.uid,
      );
      emit(AuthSuccess(userInfo: _currentUserInfo!));
    } catch (e) {
      emit(AuthFailure(message: "فشل التحقق: ${e.toString()}"));
    }
  }

  void getPhoneNumber(String phoneNumber) async {
    try {
      number = await PhoneNumber.getRegionInfoFromPhoneNumber(
        phoneNumber,
        'US',
      );
    } catch (e) {
      emit(AuthFailure(message: 'فشل الحصول على معلومات الهاتف: $e'));
    }
  }

  void forgetPassword(String email) async {
    emit(AuthLoading());

    try {
      await _credential.sendPasswordResetEmail(email: email);
      emit(
        ForGetPasswordSuccess(
          message: 'تم إرسال بريد إعادة تعيين كلمة المرور إلى $email',
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'auth/user-not-found') {
        emit(
          AuthFailure(
            message: 'لم يتم العثور على مستخدم بهذا البريد الإلكتروني.',
          ),
        );
      } else {
        emit(
          AuthFailure(
            message: 'فشل إرسال بريد إعادة تعيين كلمة المرور: ${e.message}',
          ),
        );
      }
    } catch (e) {
      emit(AuthFailure(message: 'خطأ غير متوقع: ${e.toString()}'));
    }
  }

  void updateUserNextPhoneAuth() async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('UserImages')
        .child('${_credential.currentUser!.uid}.png');
    await storageRef.putFile(img!);
    final imgUrl = await storageRef.getDownloadURL();
    emit(AuthLoading());
    try {
      _currentUserInfo = _currentUserInfo?.copyWith(
        name: _currentUserInfo?.name ?? '',
        friends: _currentUserInfo?.friends ?? [],
        userPlace:
            '${_currentPosition?.latitude}-${_currentPosition?.longitude}',
        userCity:
            '${_currentAddress.split(',')[1]}-${_currentAddress.split(',')[2]}',
        userCountry: _currentAddress.split(',')[0],

        email: _currentUserInfo?.email ?? '',
        image: imgUrl,
      );

      emit(AuthSuccess(userInfo: _currentUserInfo!));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  void signOut() async {
    emit(AuthLoading());
    try {
      await _credential.signOut();

      await _googleSignIn.signOut();

      _currentUserInfo = null;
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  void changeRegister() {
    isRegister = !isRegister;
    emit(AuthInitial());
  }

  void updateName(String name) {
    _currentUserInfo = _currentUserInfo?.copyWith(name: name);
  }

  void updatePhoneNumber(String phoneNumber) {
    _currentUserInfo = _currentUserInfo?.copyWith(phoneNumber: phoneNumber);
  }

  void updateImage(String image) {
    _currentUserInfo = _currentUserInfo?.copyWith(image: image);
  }

  void updatePassword(String password) {
    _currentUserInfo = _currentUserInfo?.copyWith(password: password);
  }

  void updateEmail(String email) {
    _currentUserInfo = _currentUserInfo?.copyWith(email: email);
  }
}
