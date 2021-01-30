import 'package:flutter/material.dart';
import 'package:simple_feed/authentication/validator.dart';
import 'package:simple_feed/sign_in/view/sign_in_verification_page.dart';

// class SignIn extends StatefulWidget {
//   @override
//   _SignInState createState() => _SignInState();
// }

// class _SignInState extends State<SignIn> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: EdgeInsets.only(top: 100),
//         child: Center(
//           child: Column(
//             children: [
//               BlocBuilder<AuthenticationBloc, AuthenticationState>(
//                 builder: (context, state) {
//                   return Text('${state.status.toString()}');
//                 },
//               ),
//               IconButton(
//                   icon: Icon(Icons.favorite),
//                   onPressed: () {
//                     // _authenticationBloc.add(Authenticate());
//                     context.read<AuthenticationBloc>().add(Authenticate());
//                   })
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class SignIn extends StatelessWidget with Validator {
  static String routeName = '/';
  final _formKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    void _handleSubmitted() {
      if (_formKey.currentState.validate()) {
        Navigator.pushNamed(context, SignInVerification.routeName);
        // onSubmitted: (String phone) {
        //   context
        //       .read<AuthenticationBloc>()
        //       .add(UpdatePhone(phone));
        // },
      }
    }

    return Scaffold(
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
                  Image.asset('assets/images/logo.png'),
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
                    validator: (value) => validatePhone(value),
                    onFieldSubmitted: (_) => _handleSubmitted(),
                    decoration: InputDecoration(
                      labelText: 'PHONE NUMBER',
                      labelStyle: TextStyle(
                        color: Theme.of(context).hintColor,
                        letterSpacing: 1.0,
                      ),
                      prefix: Text(
                        '+251 ',
                        style: TextStyle(color: Theme.of(context).accentColor),
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
                            "Sign In",
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
