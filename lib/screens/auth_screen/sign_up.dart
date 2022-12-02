import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/auth_screen/login.dart';

class SignUpScreen extends StatelessWidget {
  static const routeName = '/signUp_screen';

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(
            height: 170,
          ),
          Center(
            child: Container(
              transform: Matrix4.rotationZ(-7 * pi / 180),
              child: Text(
                'Sign-Up',
                style: TextStyle(
                    fontFamily: 'Anton',
                    fontSize: 60,
                    color: Colors.blue.shade700,
                    shadows: const [
                      Shadow(
                        color: Colors.redAccent,
                        blurRadius: 2,
                        offset: Offset(2, 2),
                      ),
                      Shadow(
                        color: Colors.red,
                        blurRadius: 1,
                        offset: Offset(1.2, 1.5),
                      ),
                      Shadow(
                        color: Colors.red,
                        blurRadius: 1,
                        offset: Offset(1.2, 1.4),
                      ),
                      Shadow(
                        color: Colors.red,
                        blurRadius: 1.9,
                        offset: Offset(1.2, 1.6),
                      ),
                      Shadow(
                        color: Colors.redAccent,
                        blurRadius: 1.5,
                        offset: Offset(1.2, 2.4),
                      )
                    ]),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const _SignUpCard(),
        ],
      )),
    );
  }
}

class _SignUpCard extends StatefulWidget {
  const _SignUpCard({Key? key}) : super(key: key);

  @override
  State<_SignUpCard> createState() => _SignUpCardState();
}

class _SignUpCardState extends State<_SignUpCard> {
  Map authData = {
    'username': '',
    'email': '',
    'password': '',
  };

  GlobalKey<FormState> globalKey = GlobalKey();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.maxFinite,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Form(
            key: globalKey,
            child: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 2, bottom: 10),
                  child: const Text('Username'),
                ),
                TextFormField(
                  validator: (val) {
                    if (val!.isEmpty || val.length < 4) {
                      return 'Username can\'t to be less than 4 letter';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                  onSaved: (val) {
                    authData['username'] = val;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(width: .8, color: Colors.blue)),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 2, bottom: 10),
                  child: const Text('Email'),
                ),
                TextFormField(
                  validator: (val) {
                    if (val!.isEmpty || !val.contains('@')) {
                      return 'Invalid-email!';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (val) {
                    authData['email'] = val;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(width: .8, color: Colors.blue)),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 2, bottom: 10),
                  child: const Text(' Create-Password'),
                ),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  validator: (val) {
                    if (val!.isEmpty || val.length < 6) {
                      return 'Password is too short!';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (val) {
                    authData['password'] = val;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(width: .8, color: Colors.blue)),
                    prefixIcon: Icon(Icons.key),
                  ),
                ),
                const SizedBox(
                  height: 12 + 35,
                ),
                Transform.scale(
                  scale: 1.1,
                  child: InkWell(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: isLoading ? 100 : 70),
                      padding: isLoading
                          ? const EdgeInsets.all(8)
                          : const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Colors.redAccent,
                            Colors.redAccent.shade700,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: isLoading
                          ? Transform.scale(
                              scale: 1.5,
                              child: Center(
                                child: LoadingAnimationWidget.staggeredDotsWave(
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            )
                          : const Text(
                              'Sign-Up',
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                    ),
                    onTap: _signUpSupmit,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    const Text("Already have an account?"),
                    Builder(
                      builder: (ctx) {
                        return TextButton(
                          onPressed: () {
                            Navigator.of(ctx)
                                .pushReplacementNamed(LoginScreen.routeName);
                          },
                          child: const Text(
                            "Sign-In",
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              fontFamily: 'Lato',
                            ),
                          ),
                        );
                      }
                    )
                  ],
                ),
              ],
            )),
      ),
    );
  }

  _signUpSupmit() async {
    if (!globalKey.currentState!.validate()) {
      return;
    } else {
      FocusScope.of(context).unfocus();
      globalKey.currentState!.save();
      setState(() {
        isLoading = true;
      });
      try {
        await Provider.of<Auth>(context, listen: false).signUp(authData);
      } on HttpException catch (e) {
        var errorMessage = 'Authentication failed';
        if (e.toString().contains('EMAIL_EXISTS')) {
          errorMessage = 'This email address is already in use.';
        } else if (e.toString().contains('INVALID_EMAIL')) {
          errorMessage = 'This is not a valid email address.';
        } else if (e.toString().contains('WEAK_PASSWORD')) {
          errorMessage = 'This Password is too weak.';
        } else if (e.toString().contains('EMAIL_NOT_FOUND')) {
          errorMessage = "Couldn't find a user with that email.";
        } else if (e.toString().contains('INVALID_PASSWORD')) {
          errorMessage = "Invalid password.";
        }
        showErrorDialog(errorMessage, context);
        setState(() {
          isLoading = false;
        });
      } catch (error) {
        const errorMessage =
            'Could not authenticate you.Please try again later.';
        showErrorDialog(errorMessage, context);
        setState(() {
          isLoading = false;
        });
      }
      setState(() {
        isLoading = false;
      });
    }
  }
}
