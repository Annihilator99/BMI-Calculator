import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';
import 'main.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildWelcomePage(context),
    );
  }

  _buildWelcomePage(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    new Future.delayed(new Duration(seconds: 4), () {
      //pop dialog
      changeScreen(context);
    });

    return Container(
      width: double.infinity,
      height: size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Text(
              'BMI Calculator',
              textScaleFactor: 3,
            ),
          ),
          Flexible(
            child: CircularProgressIndicator(
              value: null,
            ),
            flex: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RotateAnimatedTextKit(
                text: ['Initialising', 'Gathering Resources', 'Setting Up'],
                alignment: Alignment.center,
                textStyle: TextStyle(color: Colors.blue, fontSize: 17.0),
              )
            ],
          ),
        ],
      ),
    );
  }

  changeScreen(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
        Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => new LoginPage()));
      } else {
        print('User is signed in!');
        Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => new MyHomePage()));
      }
    });
  }
}
