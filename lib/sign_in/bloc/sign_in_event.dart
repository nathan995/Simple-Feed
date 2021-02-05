part of 'sign_in_bloc.dart';

@immutable
abstract class SignInEvent {}

class AttemptSignIn extends SignInEvent {
  final String phone;
  AttemptSignIn({this.phone});
}

class AttemptSignInCode extends SignInEvent {
  final String code;
  AttemptSignInCode({this.code});
}

class SignInFailedEvent extends SignInEvent {
  final String message;
  SignInFailedEvent({this.message});
}

class CodeSentEvent extends SignInEvent {}

class SignInCompletedEvent extends SignInEvent {}
