import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthentication {
  // FirebaseAuth auth = FirebaseAuth.instance;
  // void sendCode(String phone) async {
  //   await auth.verifyPhoneNumber(
  //     phoneNumber: phone,
  //     verificationCompleted: (PhoneAuthCredential credential) async {
  //       await auth.signInWithCredential(credential);
  //     },
  //     verificationFailed: (FirebaseAuthException e) {},
  //     codeSent: (String verificationId, int resendToken) async {
  //       String smsCode = '';
  //       PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
  //           verificationId: verificationId, smsCode: smsCode);

  //       await auth.signInWithCredential(phoneAuthCredential);
  //     },
  //     codeAutoRetrievalTimeout: (String verificationId) {},
  //   );
  // }
}
