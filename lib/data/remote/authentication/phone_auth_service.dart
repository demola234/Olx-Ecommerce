import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:olx/core/utils/navigator.dart';
import 'package:olx/features/authentication/presentation/view/onboarding/onboarding.dart';

import '../../../features/authentication/presentation/view/phone_authentication/otp_verification.dart';

abstract class PhoneAuthService {
  Future verifyPhoneNumber(String phoneNumber,
      {required void Function(PhoneAuthCredential)? completed,
      required void Function(FirebaseAuthException)? failed,
      required void Function(String, int?)? codeSent,
      required void Function(String)? codeAutoRetrievalTimeout});

  Future phoneCredential(String verificationId, String otp, String phone);
}

class PhoneAuthServiceImpl implements PhoneAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? verifyId;
  @override
  Future<void> verifyPhoneNumber(String phone,
      {required void Function(PhoneAuthCredential)? completed,
      required void Function(FirebaseAuthException)? failed,
      required void Function(String, int?)? codeSent,
      required void Function(String)? codeAutoRetrievalTimeout}) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: completed!,
      verificationFailed: failed!,
      codeSent: codeSent!,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout!,
    );
  }

  @override
  Future phoneCredential(
      String verificationId, String otp, String phone) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);
      final authCredential = await _auth.signInWithCredential(credential);
      final User user = authCredential.user!;

      if (user != null) {
        final uid = authCredential.user!.uid;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
