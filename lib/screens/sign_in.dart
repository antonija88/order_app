import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:order_app/api/firebase_api.dart';
import 'package:order_app/models/user_model.dart';
import 'package:order_app/providers/user_provider.dart';
import 'package:order_app/screens/home_screen.dart';
import 'package:order_app/utility/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:order_app/screens/sing_up.dart';
import 'package:order_app/constants.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:order_app/widgets/error_dialog.dart';



class SignInScreen extends StatefulWidget {
  static const routName = 'sign_in_screen';

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formkey = GlobalKey<FormState>();
  FocusNode focusNodeEmail;
  FocusNode focusNodePassword;
  final _auth = FirebaseAuth.instance;
  String email, password;


  @override
  void initState() {
    super.initState();
    focusNodeEmail = FocusNode();
    focusNodePassword = FocusNode();
  }

  @override
  void dispose() {
    focusNodeEmail.dispose();
    focusNodePassword.dispose();
    super.dispose();
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<Map<String, dynamic>> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult result = await FacebookAuth.instance.login(); // by default we request the email and the public profile or FacebookAuth.i.login()
    if (result.status == LoginStatus.success) {
      // you are logged
      final AccessToken accessToken = result.accessToken;
      final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken.token);
      await FirebaseAuth.instance.signInWithCredential(credential);

      return await FacebookAuth.instance.getUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double sizeH = SizeConfig.safeBlockVertical;
    double sizeW = SizeConfig.safeBlockHorizontal;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundColor.withOpacity(1),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
      },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: sizeW * 5),
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  SizedBox(
                    height: sizeH * 4,
                  ),
                  Image.asset("assets/images/spoon-logo-02.png", height: sizeH * 30),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                          spreadRadius: 2.0,
                        ),
                      ],
                    ),
                    child: TextFormField(
                      focusNode: focusNodeEmail,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter e-mail';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        email = value;
                      },
                      onFieldSubmitted: (term) {
                        focusNodeEmail.unfocus();
                        FocusScope.of(context).requestFocus(focusNodePassword);
                      },
                      style: TextStyle(fontSize: sizeH * 2.5, color: Colors.black),
                        keyboardType: TextInputType.emailAddress,
                        autofocus: false,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        isDense: false,
                        hintText: "Email",
                        prefix: Padding(
                          padding: EdgeInsets.symmetric(horizontal: sizeW * 2),
                        ),
                        prefixIcon: Container(
                          padding: EdgeInsets.symmetric(vertical: sizeH * 2),
                          decoration: BoxDecoration(
                            border: Border(
                                right: BorderSide(width: sizeW * 0.3,
                                  color: Colors.grey,
                            )),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: sizeW * 4),
                            child: FaIcon(FontAwesomeIcons.envelope, color: kPinkTextColor),
                          ),
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: sizeW * 0.5),
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        errorBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.white, width: sizeW * 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: kBackgroundColor, width: sizeW * 0.5),
                            borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                  ),
                  SizedBox(
                    height: sizeH * 3,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                          spreadRadius: 2.0,
                        ),
                      ],
                    ),
                    child: TextFormField(
                      focusNode: focusNodePassword,
                      validator: (value) {
                        if (value.length < 6) {
                          return 'Password must be longer than 6 characters';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        password = value;
                      },
                      onFieldSubmitted: (term) {
                        focusNodePassword.unfocus();
                      },
                      style: TextStyle(fontSize: sizeH * 2.5, color: Colors.black),
                      obscureText: true,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        isDense: false,
                        hintText: "Password",
                        prefix: Padding(
                          padding: EdgeInsets.symmetric(horizontal: sizeW * 2),
                        ),
                        prefixIcon: Container(
                          padding: EdgeInsets.symmetric(vertical: sizeH * 2),
                          decoration: BoxDecoration(
                            border: Border(
                                right: BorderSide(width: sizeW * 0.3,
                                  color: Colors.grey,
                                )),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: sizeW * 4.5),
                            child: FaIcon(FontAwesomeIcons.unlock, color: kPinkTextColor),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: sizeW * 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        errorBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.white, width: sizeW * 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: kBackgroundColor, width: sizeW * 0.5),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: sizeH * 2,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if(formkey.currentState.validate()){
                        try {
                          final newUser = await _auth.signInWithEmailAndPassword(email: email, password: password).catchError((e) {
                            // print("Wrong email or password");
                            showDialog(
                              context: context,
                              builder: (buildContext) {
                                return ErrorDialog();
                              },
                            );
                          }
                          );
                          if (newUser != null) {
                            Navigator.pushReplacementNamed(context, HomeScreen.routName);
                          }
                        }
                        catch (e) {
                          print(e);
                        }
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: sizeH * 3),
                      height: sizeH * 7,
                      width: sizeW * 70,
                      decoration: BoxDecoration(
                        color: kRedColor,
                        border: Border.all(color: kRedColor),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text('Sign In',
                            style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: sizeH * 3,
                  ),
                  Container(
                    child: Text('Or sign up with your social profiles',
                      style: TextStyle(color: kGreyTextColor, fontSize: sizeH * 2),
                    ),
                  ),
                  SizedBox(
                    height: sizeH * 4,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                              try {
                                await signInWithGoogle().then((value) {
                                  if (value != null) {
                                    UserModel newUser = UserModel();
                                    newUser.email = value.user.email;
                                    newUser.uid = value.user.uid;
                                    newUser.username = value.user.displayName;
                                    FirebaseApi.createUserData(newUser).then((value) {
                                      Navigator.pushReplacementNamed(context, HomeScreen.routName);
                                    });
                                  }
                                } );
                              }
                              catch (e) {
                                print(e);
                              }
                          },
                          child: Column(
                            children: [
                              FaIcon(FontAwesomeIcons.google, color: kRedColor),
                              SizedBox(height: sizeH * 2),
                              Text('Google',
                              style: TextStyle(
                                color: kGreyTextColor,
                              ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: sizeW * 6,
                        ),
                        GestureDetector(
                          onTap: () async {
                            try {
                              await signInWithFacebook().then((value) {
                                if (value != null) {
                                  UserModel newUser = UserModel();
                                  newUser.email = value['email'];
                                  newUser.username = value['name'];
                                  newUser.profileImage = value['picture']['data']['url'];
                                  newUser.uid = FirebaseAuth.instance.currentUser.uid;
                                  // newUser.uid = value;
                                  // newUser.username = value.user.displayName;
                                  FirebaseApi.createUserData(newUser).then((value) {
                                    Navigator.pushReplacementNamed(context, HomeScreen.routName);
                                  });
                                }
                              } );
                            }
                            catch (e) {
                              print(e);
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              FaIcon(FontAwesomeIcons.facebook, color: kRedColor),
                              SizedBox(height: sizeH * 2),
                              Text('Facebook',
                                style: TextStyle(
                                  color: kGreyTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: sizeH * 2.5,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: sizeH * 1),
                    height: sizeH * 7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            child: Text(
                              'Forgot password?',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: kGreyTextColor,
                                fontSize: sizeH * 1.7,
                              ),
                            ),
                            onTap: () {
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, SingUp.routName);
                          },
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Sign Up',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: kGreyTextColor,
                                  fontSize: sizeH * 1.7,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


