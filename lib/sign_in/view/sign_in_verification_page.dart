import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_feed/authentication/bloc/authentication_bloc.dart';
import 'package:simple_feed/authentication/validator.dart';

class SignInVerification extends StatelessWidget with Validator {
  static String routeName = '/SingInVerify';
  final _formKey = GlobalKey<FormFieldState>();
  @override
  Widget build(BuildContext context) {
    void _handleSubmitted() {
      if (_formKey.currentState.validate()) {
        context.read<AuthenticationBloc>().add(Authenticate());
        // Navigator.pushNamed(context, Home.routeName);
        // onSubmitted: (String phone) {
        //   context
        //       .read<AuthenticationBloc>()
        //       .add(UpdatePhone(phone));
        // },
      }
    }

    return Scaffold(
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
                  Image.asset('assets/images/verify.png'),
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
                              decoration: TextDecoration.none,
                            ),
                          ),
                          TextSpan(
                            text: ' Simple Feed',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 22.0,
                              color: Theme.of(context).accentColor,
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
            Expanded(
              child: Column(
                children: [
                  TextFormField(
                    key: _formKey,
                    keyboardType: TextInputType.number,
                    validator: (value) => validateCode(value),
                    onFieldSubmitted: (_) => _handleSubmitted(),
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
                            vertical: 18.0,
                          ),
                          child: Text(
                            "Verify",
                            style: TextStyle(
                              color: Theme.of(context).backgroundColor,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        onPressed: _handleSubmitted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
