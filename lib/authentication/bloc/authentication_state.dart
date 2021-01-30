part of 'authentication_bloc.dart';

enum AuthenticationStatus { authenticated, unauthenticated }

@immutable
abstract class AuthenticationState {
  final AuthenticationStatus status = AuthenticationStatus.unauthenticated;
  final String phone = '';
}

class AuthenticationInitial extends AuthenticationState {
  final AuthenticationStatus status;
  final String phone;
  AuthenticationInitial(this.status, this.phone) : super();
}

class StatusState extends AuthenticationState {
  final AuthenticationStatus status;
  StatusState(this.status);
}

class PhoneState extends AuthenticationState {
  final String phone;
  PhoneState(this.phone);
}
