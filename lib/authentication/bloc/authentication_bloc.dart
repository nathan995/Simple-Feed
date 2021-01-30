import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc()
      : super(AuthenticationInitial(AuthenticationStatus.unauthenticated, ''));

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is UnAuthenticate) {
      yield StatusState(AuthenticationStatus.unauthenticated);
    } else if (event is Authenticate) {
      yield StatusState(AuthenticationStatus.authenticated);
    } else if (event is UpdatePhone) {
      yield PhoneState(event.phone);
    }
  }
}
