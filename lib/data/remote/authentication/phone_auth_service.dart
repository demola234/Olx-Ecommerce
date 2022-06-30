import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/utils/custom_toasts.dart';
import '../../../core/utils/navigator.dart';
import '../../../features/authentication/presentation/view/onboarding/onboarding.dart';

abstract class PhoneAuthService {
  Future verifyPhoneNumber(String phoneNumber,
      {required void Function(PhoneAuthCredential)? completed,
      required void Function(FirebaseAuthException)? failed,
      required void Function(String, int?)? codeSent,
      required void Function(String)? codeAutoRetrievalTimeout});

  Future phoneCredential(String verificationId, String otp, String phone);
  Future saveDetails();
}

class PhoneAuthServiceImpl implements PhoneAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
        Toasts.showSuccessToast("Verification Completed");
        NavigationService().replaceScreen(OnBoarding());
      } else {
        Toasts.showErrorToast("Invalid OTP");
      }
    } catch (e) {
      Toasts.showErrorToast("Invalid OTP");
      print(e.toString());
    }
  }

  @override
  Future saveDetails() async {}
}
