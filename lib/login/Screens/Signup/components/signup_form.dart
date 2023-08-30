import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Login/login_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key:key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void showErrorDialog(String message) {
    showDialog(
      context:context,
      builder:(BuildContext context) {
        return AlertDialog(
          title:Text("Error"),
          content:Text(message),
          actions:[
            TextButton(
              onPressed:() {
                Navigator.of(context).pop();
              },
              child:Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key:_formKey,
      child : Column(
        children:[
          TextFormField(
            controller : emailController,
            keyboardType : TextInputType.emailAddress,
            textInputAction : TextInputAction.next,
            cursorColor : kPrimaryColor,
            decoration : InputDecoration(
              hintText : "Your email",
              prefixIcon : Padding(
                padding : const EdgeInsets.all(defaultPadding),
                child : Icon(Icons.person),
              ),
            ),
            validator : (value) {
              if(value == null || value.isEmpty) {
                return "Please enter your email";
              }
              return null;
            },
          ),
          Padding(
            padding : const EdgeInsets.symmetric(vertical:defaultPadding),
            child : TextFormField(
              controller : passwordController,
              textInputAction : TextInputAction.done,
              obscureText : true,
              cursorColor : kPrimaryColor,
              decoration : InputDecoration(
                hintText : "Your password",
                prefixIcon : Padding(
                  padding : const EdgeInsets.all(defaultPadding),
                  child : Icon(Icons.lock),
                ),
              ),
              validator : (value) {
                if(value == null || value.isEmpty) {
                  return "Please enter your password";
                }
                return null;
              },
            ),
          ),
          const SizedBox(height:defaultPadding / 2),
          ElevatedButton(
            onPressed:() async {
              if(_formKey.currentState!.validate()) {
                try {
                  UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email:emailController.text,
                      password:passwordController.text);
                  // Navigate to Page1 after successful login
                  if (mounted) {
                    // Display a SnackBar after successful login
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Signed up successfully!'),
                      ),
                    );
                    // Pop routes until the NavigationExample route is reached
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  }
                } on FirebaseAuthException catch(e) {
                  if(e.code == 'weak-password') {
                    showErrorDialog("The password provided is too weak.");
                  } else if(e.code == 'email-already-in-use') {
                    showErrorDialog("The account already exists for that email.");
                  }
                } catch(e) {
                  print(e);
                }
              }
            },
            child:Text("Sign Up".toUpperCase()),
          ),
          const SizedBox(height:defaultPadding),
          AlreadyHaveAnAccountCheck(
            login:false,
            press:() {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:(context) {
                    return LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}