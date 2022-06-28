import 'package:flutter/material.dart';
import 'package:olx/core/utils/navigator.dart';
import 'package:olx/features/authentication/presentation/provider/auth_states.dart';
import 'package:olx/features/authentication/presentation/view/onboarding/onboarding.dart';
import 'package:olx/features/authentication/presentation/view/phone_authentication/otp_verification.dart';

import '../../../../core/utils/custom_toasts.dart';
import '../../../../data/remote/authentication/phone_auth_service.dart';
import '../../../../di/di.dart';

class AuthProvider extends ChangeNotifier {
  var authService = getIt<PhoneAuthService>();
  String verificationId = '';

  PhoneAuthState _phoneAuthState = PhoneAuthState.initial;

  PhoneAuthState get phoneAuthState => _phoneAuthState;

  set phoneAuthStateChange(PhoneAuthState phoneAuthState) {
    _phoneAuthState = phoneAuthState;
    notifyListeners();
  }

  TextEditingController phoneTextEditingController = TextEditingController();

  Future<void> verifyPhoneNumber(String number) async {
    await authService.verifyPhoneNumber(number, failed: (error) {
      phoneAuthStateChange = PhoneAuthState.error;
      Toasts.showErrorToast(error.toString());
    }, completed: (credential) async {
      if (credential.smsCode != null && credential.verificationId != null) {
        verificationId = credential.verificationId!;
        notifyListeners();
        Toasts.showSuccessToast("OTP Sent");
        await verifyOTP(
            credential.verificationId!, credential.smsCode!, number);
      }
    }, codeAutoRetrievalTimeout: (id) {
      verificationId = id;
      notifyListeners();
      phoneAuthStateChange = PhoneAuthState.codeSent;
    }, codeSent: (String id, int? token) {
      verificationId = id;
      notifyListeners();
      Toasts.showSuccessToast("OTP Sent");
      NavigationService().replaceScreen(
          VerifyOTP(phoneNumber: number, verifyId: verificationId));
      phoneAuthStateChange = PhoneAuthState.codeSent;
    });
  }

  Future<void> verifyOTP(
      String verificationId, String otp, String phone) async {
    phoneAuthStateChange = PhoneAuthState.loading;
    await authService.phoneCredential(verificationId, otp, phone);
    Toasts.showSuccessToast("Verification Completed");
    NavigationService().replaceScreen(OnBoarding());
    notifyListeners();
    phoneAuthStateChange = PhoneAuthState.success;
  }
}
