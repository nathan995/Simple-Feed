import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_feed/authentication/bloc/authentication_bloc.dart';
import 'package:simple_feed/sign_in/bloc/sign_in_bloc.dart';
import 'package:simple_feed/sign_in/utils/validator.dart';

class SignInVerification extends StatelessWidget with SignInValidator {
  static String routeName = '/signInVerify';
  final _formKey = GlobalKey<FormFieldState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final SignInBloc signInBloc = BlocProvider.of<SignInBloc>(context);
    void _handleSubmitted() {
      if (_formKey.currentState.validate()) {
        final String _code = _formKey.currentState.value;
        signInBloc.add(AttemptSignInCode(code: _code));
      }
    }

    return BlocListener<SignInBloc, SignInState>(
      listenWhen: (_, current) => current is SignInErrorState,
      listener: (_, state) {
        if (state is SignInErrorState) {
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
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
          iconTheme: IconThemeData(color: Theme.of(context).accentColor),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 50),
          color: Theme.of(context).backgroundColor,
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
                      child: Image.asset('assets/images/verify.png'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 22.0),
                      child: Text(
                        'Verify your number',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontFamily: 'Roboto',
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 18.0,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Text(
                              'We have sent a 6 digit verification code to ',
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          BlocBuilder<AuthenticationBloc, AuthenticationState>(
                            buildWhen: (previous, current) =>
                                previous.phone != current.phone,
                            builder: (context, state) {
                              return RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    TextSpan(
                                      text: 'to your number ',
                                      style: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontFamily: 'Roboto',
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.normal,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' +251${state.phone}',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).accentColor,
                                        decoration: TextDecoration.none,
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
                          validator: (value) => validateCode(value),
                          enabled: state is! SignInLoadingState,
                          onFieldSubmitted: (_) => _handleSubmitted(),
                          style: TextStyle(fontWeight: FontWeight.w600),
                          decoration: InputDecoration(
                            labelText: 'VERIFICATION CODE',
                            labelStyle: TextStyle(
                              color: Theme.of(context).hintColor,
                              letterSpacing: 1.0,
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
                                          "Verify",
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
