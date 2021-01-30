import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_feed/authentication/bloc/authentication_bloc.dart';
/////////////////////////////////////////////////////////////
import './splash/splash.dart';
import './sign_in/sign_in.dart';
import './home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationBloc(),
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Feed',
      theme: ThemeData(
        primaryColor: Color(0xFFE9446A),
        accentColor: Color(0xFF0E0E0E),
        hintColor: Color(0xFF9B9B9B),
        backgroundColor: Colors.white,
        fontFamily: 'Roboto',
      ),
      routes: {
        Home.routeName: (context) => Home(),
        SignIn.routeName: (context) => SignIn(),
        SignInVerification.routeName: (context) => SignInVerification(),
      },
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                _navigator.pushNamedAndRemoveUntil(
                  Home.routeName,
                  (route) => false,
                );
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator.pushNamedAndRemoveUntil(
                  SignIn.routeName,
                  (route) => false,
                );
                break;
              default:
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (context) => MaterialPageRoute(
        builder: (context) => Splash(),
      ),
    );
  }
}
