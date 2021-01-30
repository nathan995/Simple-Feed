part of 'sign_in_bloc.dart';

@immutable
abstract class SignInState {
  final String code = '';
}

class SignInInitial extends SignInState {
  final String code;
  SignInInitial(this.code);
}
