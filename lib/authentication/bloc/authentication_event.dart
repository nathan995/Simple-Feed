part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

class Authenticate extends AuthenticationEvent {}

class UnAuthenticate extends AuthenticationEvent {}

class UpdatePhone extends AuthenticationEvent {
  final String phone;
  UpdatePhone(this.phone);
}
