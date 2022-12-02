import 'dart:math';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/auth_screen/login.dart';

import 'package:shop_app/screens/auth_screen/sign_up.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const routeName = 'login_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 145,
            ),
            Center(
              child: Container(
                transform: Matrix4.rotationZ(-7 * pi / 180),
                child: Text(
                  'Welcome back',
                  style: TextStyle(
                      fontFamily: 'Anton',
                      fontSize: 43,
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
                      ]),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // Container(
            //   height: 270,
            //   child: Image.asset('assets/images/auth-images/login.jpg'),
            // ),
            _LoginCard(),
          ],
        ),
      ),
    );
  }
}

class _LoginCard extends StatefulWidget {
  const _LoginCard({Key? key}) : super(key: key);

  @override
  State<_LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<_LoginCard> {
  Map authData = {
    'email': '',
    'password': '',
  };

  bool isLoading = false;
  bool isVisible = true;

  GlobalKey<FormState> globalKey = GlobalKey();
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
                  child: const Text('E-mail'),
                ),
                TextFormField(
                  validator: (val) {
                    if (val!.isEmpty || !val.contains('@')) {
                      return 'Invalid email!';
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
                  child: const Text('Password'),
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
                  obscureText: isVisible ? true : false,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(width: .8, color: Colors.blue)),
                    prefixIcon: const Icon(Icons.key),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                      icon: Icon(
                          isVisible ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    const Spacer(),
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        )),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Transform.scale(
                  scale: 1.1,
                  child: InkWell(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: isLoading ? 100 : 70),
                      padding: isLoading
                          ? EdgeInsets.all(8)
                          : EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                              'Sign-in',
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                    ),
                    onTap: _loginSupmit,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Center(
                    child: Text(
                        '--------------------------- or ---------------------------')),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Transform.scale(
                        scale: 1.0,
                        child: InkWell(
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 35),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(10),
                                  right: Radius.circular(2),
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
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    CommunityMaterialIcons.google,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    'Google',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              )),
                          onTap: () async {},
                        )),
                    Transform.scale(
                      scale: 1.0,
                      child: InkWell(
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 30),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(10),
                                right: Radius.circular(2),
                              ),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.purple,
                                  Colors.purpleAccent.shade700
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  CommunityMaterialIcons.facebook,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Facebook',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            )),
                        onTap: () async {},
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    const Text("Don't have an account?"),
                    Builder(builder: (ctx) {
                      return TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pushNamed(SignUpScreen.routeName);
                        },
                        child: const Text(
                          "Sign-Up",
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            fontFamily: 'Lato',
                          ),
                        ),
                      );
                    })
                  ],
                ),
              ],
            )),
      ),
    );
  }

  _loginSupmit() async {
    if (!globalKey.currentState!.validate()) {
      return;
    } else {
      FocusScope.of(context).unfocus();
      globalKey.currentState!.save();
      setState(() {
        isLoading = true;
      });
      try {
        await Provider.of<Auth>(context, listen: false).signIn(authData);
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
        print('___________Error____________');
        print(e.toString());

        showErrorDialog(errorMessage, context);
      } catch (error) {
        const errorMessage =
            'Could not authenticate you.Please try again later.';
        showErrorDialog(errorMessage, context);
      }
      setState(() {
        isLoading = false;
      });
    }
  }
}

showErrorDialog(String message, BuildContext ctx) {
  return showAnimatedDialog(
    context: ctx,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return ClassicGeneralDialogWidget(
        titleText: 'An Error Occurred!',
        contentText: message,
        positiveText: 'Okey!',
        onPositiveClick: () {
          Navigator.of(context).pop();
        },
      );
    },
    animationType: DialogTransitionType.sizeFade,
  );
}
