import 'package:flutter/material.dart';
import '../../components/background.dart';
import '../../constants.dart';
import '../../responsive.dart';
import 'components/sign_up_top_image.dart';
import 'components/signup_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Padding(
            padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 200),
                Row(
                  children: const [
                    Spacer(),
                    Expanded(
                      flex: 8,
                      child: SignUpForm(),
                    ),
                    Spacer(),
                  ],
                ),
                // const SocalSignUp()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
