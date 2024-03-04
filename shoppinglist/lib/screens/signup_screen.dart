import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shoppinglist/screens/home_screen.dart';
import 'package:shoppinglist/backend/firebase_auth.dart';
import 'package:shoppinglist/backend/validator.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
// ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrangeAccent,
          // ignore: prefer_const_constructors
          title: Text('Create Account'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _registerFormKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _nameTextController,
                        focusNode: _focusName,
                        validator: (value) => Validator.validateName(
                          name: value,
                        ),
                        decoration: InputDecoration(
                          hintText: "Name",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            // ignore: prefer_const_constructors
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      // ignore: prefer_const_constructors
                      SizedBox(height: 12.0),
                      TextFormField(
                        controller: _emailTextController,
                        focusNode: _focusEmail,
                        validator: (value) => Validator.validateEmail(
                          email: value,
                        ),
                        decoration: InputDecoration(
                          hintText: "Email",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            // ignore: prefer_const_constructors
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      // ignore: prefer_const_constructors
                      SizedBox(height: 12.0),
                      TextFormField(
                        controller: _passwordTextController,
                        focusNode: _focusPassword,
                        obscureText: true,
                        validator: (value) => Validator.validatePassword(
                          password: value,
                        ),
                        decoration: InputDecoration(
                          hintText: "Password",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            // ignore: prefer_const_constructors
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      // ignore: prefer_const_constructors
                      SizedBox(height: 32.0),
                      _isProcessing
                          // ignore: prefer_const_constructors
                          ? CircularProgressIndicator()
                          : Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        _isProcessing = true;
                                      });

                                      if (_registerFormKey.currentState!
                                          .validate()) {
                                        User? user = await FirebaseAuthHelper
                                            .registerUsingEmailPassword(
                                          name: _nameTextController.text,
                                          email: _emailTextController.text,
                                          password:
                                              _passwordTextController.text,
                                        );

                                        setState(() {
                                          _isProcessing = false;
                                        });

                                        if (user != null) {
                                          // ignore: use_build_context_synchronously
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeScreen(user: user),
                                            ),
                                            ModalRoute.withName('/'),
                                          );
                                        }
                                      } else {
                                        setState(() {
                                          _isProcessing = false;
                                        });
                                      }
                                    },
                                    // ignore: sort_child_properties_last, prefer_const_constructors
                                    child: Text(
                                      'Sign up',
                                      // ignore: prefer_const_constructors
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.deepOrangeAccent),
                                    ),
                                  ),
                                ),
                              ],
                            )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
