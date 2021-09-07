import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:order_app/screens/home_screen.dart';
import 'sign_in.dart';
import 'package:order_app/utility/size_config.dart';


class WelcomeScreen extends StatefulWidget {
  static const String routName = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () {
      FirebaseAuth.instance
          .authStateChanges()
          .listen((User user) {
        if (user == null) {
          Navigator.pushReplacementNamed(context, SignInScreen.routName);
        } else {
          Navigator.pushReplacementNamed(context, HomeScreen.routName);
        }
      });
      Navigator.pushReplacementNamed(context, SignInScreen.routName);
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double sizeH = SizeConfig.safeBlockVertical;
    double sizeW = SizeConfig.safeBlockHorizontal;
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
          image: DecorationImage(
          image: AssetImage("assets/images/background.png"),
          fit: BoxFit.cover,
          ),
      ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/spoon-logo.png"),
            Text(
              'Order App',
              style: TextStyle(fontSize: sizeH * 5, fontWeight: FontWeight.normal,
                      color: Colors.black),
            ),
            SizedBox(
              height: sizeH * 3,
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Version 0.1.1',
                style: TextStyle(fontSize: sizeH * 2.5, fontWeight: FontWeight.normal,
                    color: Colors.white),
              ),
              decoration: BoxDecoration(
                color: Colors.orangeAccent[400],
                  border: Border.all(
                    color: Colors.orangeAccent[400],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
