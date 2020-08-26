import 'dart:math';

import 'package:bmi_calculator/welcome_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

import 'bmi_history.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return AlertDialog(
            title: Text('Something went wrong'),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
                brightness: Brightness.dark,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                accentColor: Colors.blue,
                fontFamily: 'noto-=sans'),
            home: WelcomePage(),
          );
        }

        return Loading(
          indicator: BallPulseIndicator(),
          size: 10.0,
          color: Colors.blue,
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _sliderValue = 0;
  String gender = 'male';
  double height;
  double bmi;
  static const color1 = Colors.blue;
  static const color2 = Colors.black12;
  var text_color_male = color2;
  var text_color_female = color2;
  bool _validate = false;

  final heightController = TextEditingController();


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    heightController.dispose();
    super.dispose();
  }

  String calculateBMI() {
    if (_sliderValue != 0 && heightController.text != null) {
      var height = double.parse(heightController.text) / 100;
      bmi = _sliderValue / pow(height, 2);

      var newFormat = DateFormat("dd-MM-yyyy   HH:mm:ss");
      String updatedDt = newFormat.format(DateTime.now());

      Firestore.instance.runTransaction((transaction) async {
        CollectionReference reference =
            Firestore.instance.collection('BMI_LIST');

        await reference.add({
          "bmi": double.parse(bmi.toStringAsFixed(3)),
          "date": updatedDt,
        });
      });
    }
    return bmi.toStringAsFixed(3);
  }

  Widget _buildGender() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          child: Container(
            decoration: BoxDecoration(
                color: text_color_male,
                borderRadius: BorderRadius.all(Radius.circular(30))),
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset('assets/images/male_symbol.png'),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Text('Male'),
                )
              ],
            ),
          ),
          onTap: () {
            setState(() {
              text_color_male = color1;
              text_color_female = color2;
            });
            gender = 'male';
          },
        ),
        GestureDetector(
          child: Container(
            decoration: BoxDecoration(
                color: text_color_female,
                borderRadius: BorderRadius.all(Radius.circular(30))),
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset('assets/images/female-symbol.png'),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Text('Female'),
                )
              ],
            ),
          ),
          onTap: () {
            setState(() {
              text_color_male = color2;
              text_color_female = color1;
            });
            gender = 'female';
          },
        )
      ],
    );
  }

  Widget _buildSlider() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        color: color2,
      ),
      margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Text('Weight (in kg)'),
          Expanded(
            flex: 2,
            child: Slider(
              value: _sliderValue,
              min: 0,
              max: 250,
              divisions: 250,
              label: _sliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _sliderValue = value;
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeight() {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: color2,
        ),
        margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: 150,
              child: TextField(
                onTap: () {
                  setState(() {
                    _validate = false;
                  });
                },
                controller: heightController,
                decoration: InputDecoration(
                  hintText: 'Enter your Height',
                  focusColor: Colors.blue,
                  errorText: _validate ? 'Height cannot be left blank' : null,
                  suffixText: 'cm',
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ));
  }

  Widget _buildButton() {
    return GestureDetector(
      onTap: () {

        if (heightController.text.isEmpty) {
          setState(() {
            _validate = true;
          });
        } else {
          setState(() {
            _validate = false;
          });
          return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Center(
                  child: Text('Your BMI is'),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(calculateBMI()),
                    Text(gender),
                  ],
                ),
              );
            },
          );
        }
      },
      child: Container(
          height: 50,
          width: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: color1,
          ),
          margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
          child: Center(
            child: Text(
              'CALCULATE',
              style: TextStyle(color: Colors.white),
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('BMI'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: _launchHistory,
          ),
          GestureDetector(
            child: Center(
              child: Text('Sign Out'),
            ),
            onTap: () {
              signOut();
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _buildGender(),
            _buildSlider(),
            _buildHeight(),
            _buildButton()
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _launchHistory() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return bmi_list();
        },
      ),
    );
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new WelcomePage()));
  }
}
