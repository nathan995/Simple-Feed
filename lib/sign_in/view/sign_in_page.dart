import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_feed/authentication/bloc/authentication_bloc.dart';
import 'package:simple_feed/sign_in/bloc/sign_in_bloc.dart';
import 'package:simple_feed/sign_in/utils/validator.dart';
import 'package:simple_feed/sign_in/view/sign_in_verification_page.dart';

class SignIn extends StatelessWidget with SignInValidator {
  static String routeName = '/signIn';
  final _formKey = GlobalKey<FormFieldState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authenticationBloc =
        BlocProvider.of<AuthenticationBloc>(context);
    final SignInBloc signInBloc = BlocProvider.of<SignInBloc>(context);

    void _handleSubmitted() {
      if (_formKey.currentState.validate()) {
        String _phone = _formKey.currentState.value;
        _phone = _phone.startsWith('0') ? _phone.substring(1) : _phone;
        authenticationBloc.add(UpdatePhone(_phone));
        signInBloc.add(AttemptSignIn(phone: _phone));
      }
    }

    return BlocListener<SignInBloc, SignInState>(
      listenWhen: (_, current) =>
          current is CodeSentState ||
          current is SignInCompletedState ||
          current is SignInErrorState,
      listener: (context, state) {
        if (state is CodeSentState) {
          Navigator.pushNamed(context, SignInVerification.routeName);
        } else if (state is SignInCompletedState) {
          authenticationBloc.add(Authenticate());
        } else if (state is SignInErrorState) {
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text("${state.message}"),
              duration: Duration(seconds: 5),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(30.0),
            ),
          );
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: Container(
          color: Theme.of(context).backgroundColor,
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.asset('assets/images/logo.png')),
                    Padding(
                      padding: const EdgeInsets.only(top: 48.0),
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            TextSpan(
                              text: 'Welcome to',
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontFamily: 'Roboto',
                                fontSize: 22.0,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            TextSpan(
                              text: ' Simple Feed',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 22.0,
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              BlocBuilder<SignInBloc, SignInState>(
                buildWhen: (previous, current) =>
                    current is SignInLoadingState ||
                    previous is SignInLoadingState,
                builder: (context, state) {
                  return Expanded(
                    child: Column(
                      children: [
                        TextFormField(
                          key: _formKey,
                          keyboardType: TextInputType.number,
                          validator: (value) => validatePhone(value),
                          onFieldSubmitted: (_) => _handleSubmitted(),
                          enabled: state is! SignInLoadingState,
                          decoration: InputDecoration(
                            labelText: 'PHONE NUMBER',
                            labelStyle: TextStyle(
                              color: Theme.of(context).hintColor,
                              letterSpacing: 1.0,
                            ),
                            prefix: Text(
                              '+251 ',
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 48.0,
                          ),
                          child: Container(
                            width: double.infinity,
                            child: FlatButton(
                              color: Theme.of(context).primaryColor,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14.0,
                                ),
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Center(
                                        child: Text(
                                          "Sign In",
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .backgroundColor,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                    state is SignInLoadingState
                                        ? SizedBox(
                                            height: 18,
                                            width: 18,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 3,
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      Theme.of(context)
                                                          .backgroundColor),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              onPressed: state is SignInLoadingState
                                  ? null
                                  : _handleSubmitted,
                              disabledColor: Color(0x99E9446A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
