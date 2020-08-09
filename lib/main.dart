import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        accentColor: Colors.blue,
      ),
      home: MyHomePage(title: 'BMI Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

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
    }
    return bmi.toString();
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
                  child: Image.asset('graphics/male_symbol.png'),
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
                  child: Image.asset('graphics/female-symbol.png'),
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
        title: Text(widget.title),
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
}
