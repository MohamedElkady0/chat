import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:latlong2/latlong.dart';
import 'package:my_chat/fetcher/data/model/user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  late StreamSubscription _authSubscription;
  final FirebaseAuth _credential = FirebaseAuth.instance;

  UserInfoData? _currentUserInfo;

  UserInfoData? get currentUserInfo => _currentUserInfo;
  set currentUserInfo(UserInfoData? userInfo) {
    _currentUserInfo = userInfo;
    emit(AuthInitial());
  }

  bool isRegister = true;
  File? img;
  String _otp = '';
  String get otp => _otp;
  void setOtp(String value) => _otp = value;
  String? _verificationId;
  PhoneNumber number = PhoneNumber(isoCode: 'EG');
  String _phoneNumber = '';
  void setPhoneNumber(String value) => _phoneNumber = value;
  String get phoneNumber => _phoneNumber;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  LatLng? currentPosition;
  String currentAddress = 'لم يتم تحديد العنوان بعد';
  MapController? mapController;
  bool isLoading = true;
  SharedPreferences? prefs;

  AuthCubit() : super(AuthInitial());

  Future<String> imageUrl() async {
    if (img == null) {
      emit(AuthFailure(message: 'Please select an image.'));
      return '';
    }

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('UserImages')
        .child('${_credential.currentUser!.uid}.png');
    await storageRef.putFile(img!);
    final imgUrl = await storageRef.getDownloadURL();

    return imgUrl;
  }

  Future<void> checkAppState() async {
    final prefs = await SharedPreferences.getInstance();
    final bool hasSeenOnboarding = prefs.getBool('seenOnboarding') ?? false;

    if (!hasSeenOnboarding) {
      emit(ShowOnboardingState());
    } else {
      final user = _credential.currentUser;
      if (user != null) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthUnauthenticated());
      }
    }
  }

  Future<void> onIntroEnd() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);

    emit(AuthUnauthenticated());
  }

  void pickImage({required String title}) async {
    final ImagePicker picker = ImagePicker();
    XFile? pickedFile;
    if (title == 'Gallery') {
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
    } else {
      pickedFile = await picker.pickImage(source: ImageSource.camera);
    }
    if (pickedFile == null) {
      return;
    }

    img = File(pickedFile.path);
    emit(AuthImagePicked(img!));
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      currentAddress = 'خدمات الموقع معطلة. يرجى تفعيلها.';
      isLoading = false;

      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        currentAddress = 'تم رفض إذن الوصول للموقع.';
        isLoading = false;

        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      currentAddress =
          'تم رفض إذن الوصول للموقع بشكل دائم. يرجى تفعيله من إعدادات التطبيق.';
      isLoading = false;

      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final newPosition = LatLng(position.latitude, position.longitude);

      currentPosition = newPosition;
      isLoading = false;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (currentPosition != null) {
          mapController?.move(currentPosition!, 2.0);
        }
      });

      getAddressFromLatLng(position);
    } catch (e) {
      debugPrint("Error getting location: $e");
      // if (!mounted) return;

      currentAddress = "خطأ في تحديد الموقع: ${e.toString()}";
      isLoading = false;
    }
  }

  Future<void> getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        currentAddress = '${place.country},${place.street},${place.locality}';
      }
    } catch (e) {
      debugPrint(e.toString());

      currentAddress = "لا يمكن جلب العنوان";
    }
  }

  void onSignUp({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    try {
      await _credential.createUserWithEmailAndPassword(
        email: email,
        password: password,
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
        email: email,
        password: password,

        phoneNumber: number.phoneNumber ?? '',
        userId: _credential.currentUser!.uid,
        name: name,
        friends: _currentUserInfo?.friends ?? [],
        userPlace: '${currentPosition?.latitude}-${currentPosition?.longitude}',
        userCity:
            '${currentAddress.split(',')[1]}-${currentAddress.split(',')[2]}',
        userCountry: currentAddress.split(',')[0],
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

  void onSignIn({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      await _credential.signInWithEmailAndPassword(
        email: email,
        password: password,
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
      emit(AuthFailure(message: 'Error signing in: '));
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
        userPlace: '${currentPosition?.latitude}-${currentPosition?.longitude}',
        userCity:
            '${currentAddress.split(',')[1]}-${currentAddress.split(',')[2]}',
        userCountry: currentAddress.split(',')[0],
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
    emit(AuthLoading());
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        if (FirebaseAuth.instance.currentUser != null) {
          emit(AuthSuccess(userInfo: _currentUserInfo!));
        } else {
          emit(AuthFailure(message: "فشل التحقق التلقائي"));
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        emit(AuthFailure(message: "فشل التحقق: ${e.message}"));
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;

        emit(AuthCodeSentSuccess());
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

    emit(AuthLoading());
    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: _otp,
    );

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      if (userCredential.user != null) {
        final userInfo = UserInfoData(
          image: '',
          email: '',
          password: '',

          phoneNumber: number.phoneNumber ?? '',
          userId: userCredential.user!.uid,
          name: '',
          friends: _currentUserInfo?.friends ?? [],
          userPlace:
              '${currentPosition?.latitude}-${currentPosition?.longitude}',
          userCity:
              '${currentAddress.split(',')[1]}-${currentAddress.split(',')[2]}',
          userCountry: currentAddress.split(',')[0],
        );

        final userDoc =
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(userCredential.user!.uid)
                .get();

        if (userDoc.exists) {
          _currentUserInfo = UserInfoData.fromJson(userDoc.data()!);
        } else {
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(userCredential.user!.uid)
              .set(userInfo.toJson());
          _currentUserInfo = userInfo;
        }

        emit(AuthSuccess(userInfo: _currentUserInfo!));
      } else {
        emit(AuthFailure(message: "فشل التحقق، لم يتم العثور على المستخدم."));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        emit(AuthFailure(message: "رمز التحقق غير صحيح."));
      } else {
        emit(AuthFailure(message: "فشل التحقق: ${e.message}"));
      }
    } catch (e) {
      emit(AuthFailure(message: "حدث خطأ غير متوقع: ${e.toString()}"));
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

  void forgetPassword({required String email}) async {
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
        userPlace: '${currentPosition?.latitude}-${currentPosition?.longitude}',
        userCity:
            '${currentAddress.split(',')[1]}-${currentAddress.split(',')[2]}',
        userCountry: currentAddress.split(',')[0],

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
      emit(AuthUnauthenticated());
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  void changeRegister() {
    isRegister = !isRegister;
    emit(AuthInitial());
  }

  void updateName(String name) async {
    _currentUserInfo = _currentUserInfo?.copyWith(name: name);
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(_credential.currentUser!.uid)
        .update(_currentUserInfo!.toJson());
  }

  void updatePhoneNumber(String phoneNumber) async {
    _currentUserInfo = _currentUserInfo?.copyWith(phoneNumber: phoneNumber);
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(_credential.currentUser!.uid)
        .update(_currentUserInfo!.toJson());
  }

  void updateImage(String image) async {
    _currentUserInfo = _currentUserInfo?.copyWith(image: image);
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(_credential.currentUser!.uid)
        .update(_currentUserInfo!.toJson());
  }

  void updatePassword(String password) async {
    _currentUserInfo = _currentUserInfo?.copyWith(password: password);
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(_credential.currentUser!.uid)
        .update(_currentUserInfo!.toJson());
  }

  void updateEmail(String email) async {
    _currentUserInfo = _currentUserInfo?.copyWith(email: email);
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(_credential.currentUser!.uid)
        .update(_currentUserInfo!.toJson());
  }
}
