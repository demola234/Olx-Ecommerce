import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/utils/custom_toasts.dart';

abstract class GoogleAuthServices {
  Future googleAuthentication();
}

class GoogleAuthServiceImpl implements GoogleAuthServices {
  final GoogleSignIn googleSignIn;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  GoogleAuthServiceImpl(this.googleSignIn);

  @override
  Future googleAuthentication() async {
    final googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final googleSignInAuth = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuth.accessToken,
        idToken: googleSignInAuth.idToken,
      );

      try {
        final UserCredential _userCredential =
            await _auth.signInWithCredential(credential);

        return _userCredential.user;
      } on FirebaseAuthException catch (err) {
        Toasts.showErrorToast(err.toString());
      }
    }
  }
}
