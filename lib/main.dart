import 'dart:math';

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
  var text_color_male = null;
  var text_color_female = null;

  final heightController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    heightController.dispose();
    super.dispose();
  }

  String calculateBMI() {
    if (_sliderValue != 0 && heightController.text != null) {
      bmi = _sliderValue / pow(double.parse(heightController.text), 2);
    }
    return bmi.toString();
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                    color: text_color_male,
                    child: InkWell(
                      splashColor: Colors.blue,
                      child: Container(
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
                          text_color_male = Colors.blue;
                          text_color_female = null;
                        });
                        gender = 'male';
                      },
                    )),
                Card(
                    color: text_color_female,
                    child: InkWell(
                      splashColor: Colors.blue,
                      child: Container(
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
                          text_color_male = null;
                          text_color_female = Colors.blue;
                        });
                        gender = 'female';
                      },
                    )),
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Row(
                children: [
                  Text('Weight'),
                  Expanded(
                    flex: 3,
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
            ),
            Container(
                margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 100,
                      child: TextField(
                        controller: heightController,
                        decoration: InputDecoration(
                          labelText: 'Height',
                          focusColor: Colors.blue,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        'cm',
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                )),
            Container(
              margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: RaisedButton(
                onPressed: () {
                  return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Your BMI is'),
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
                },
                child: SizedBox(
                  height: 20,
                  width: 300,
                  child: Center(child: Text('Calculate')),
                ),
              ),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
