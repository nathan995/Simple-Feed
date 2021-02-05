import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(SignInInitial());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId;
  @override
  Stream<SignInState> mapEventToState(
    SignInEvent event,
  ) async* {
    if (event is AttemptSignIn) {
      yield* _attemptSignIn(event.phone);
    } else if (event is AttemptSignInCode) {
      yield* _attemptSignInCode(event.code);
    } else if (event is CodeSentEvent) {
      yield CodeSentState();
    } else if (event is SignInCompletedEvent) {
      yield SignInCompletedState();
    } else if (event is SignInFailedEvent) {
      yield SignInErrorState(message: event.message);
    }
  }

  void _onCodeSent(String verificationId, int resendToken) async {
    this._verificationId = verificationId;
    this.add(CodeSentEvent());
  }

  void _onCodeAutoRetrievalTimeout(String verificationId) {
    this.add(
      SignInFailedEvent(message: 'Sign in timed out. Please try again '),
    );
  }

  void _onComplete(PhoneAuthCredential credential) async {
    await _auth.signInWithCredential(credential);
    this.add(SignInCompletedEvent());
  }

  void _onVerificationFailed(FirebaseAuthException authException) {
    this.add(SignInFailedEvent(message: authException.message));
  }

  Stream<SignInState> _attemptSignIn(String phone) async* {
    yield SignInLoadingState();

    await _auth.verifyPhoneNumber(
      phoneNumber: '+1 650-555-3434',
      // phoneNumber: '+251$phone',
      timeout: Duration(seconds: 90),
      codeSent: _onCodeSent,
      codeAutoRetrievalTimeout: _onCodeAutoRetrievalTimeout,
      verificationCompleted: _onComplete,
      verificationFailed: _onVerificationFailed,
    );
  }

  Stream<SignInState> _attemptSignInCode(String code) async* {
    yield SignInLoadingState();
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: code);
    await _auth.signInWithCredential(phoneAuthCredential);
    _onComplete(phoneAuthCredential);
  }
}
