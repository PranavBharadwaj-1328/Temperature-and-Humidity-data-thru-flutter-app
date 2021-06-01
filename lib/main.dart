import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:syncfusion_flutter_gauges/gauges.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'DHT Data',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage("0", "0", title: 'Weather Monitoring'),
    );
  }
}

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  MyHomePage(this.temp, this.humid, {Key key, this.title}) : super(key: key);
  final String title;
  String temp;
  String humid;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> _getDht() async {
    var url = Uri.parse(
        "https://api.thingspeak.com/channels/1379680/feeds.json?api_key=4509YU9SIR82AAQE&results=1");
    while (true) {
      var result = await http.get(url);
      Map<String, dynamic> feeds = jsonDecode(result.body);
      Map<String, dynamic> fields = feeds["feeds"][0];
      setState(() {
        widget.temp = fields["field1"];
      });
      print(widget.temp);
      setState(() {
        widget.humid = fields["field2"];
      });
      print(widget.humid);
      sleep(Duration(seconds: 5));
    }
  }

  @override
  void initState() {
    super.initState();
    _getDht();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            new Container(
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(minimum: 0.0, maximum: 50.0, ranges: <GaugeRange>[
                    GaugeRange(
                        startValue: 0.0, endValue: 20.0, color: Colors.blue),
                    GaugeRange(
                        startValue: 20.0, endValue: 35.0, color: Colors.orange),
                    GaugeRange(
                        startValue: 35.0, endValue: 50.0, color: Colors.red)
                  ], pointers: <GaugePointer>[
                    NeedlePointer(value: double.parse(widget.temp))
                  ], annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                        widget: Container(
                            child: Text(
                                "Temperature\n     " + widget.temp + "\u2103",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold))),
                        angle: 90,
                        positionFactor: 0.5)
                  ])
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            new Container(
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(minimum: 0.0, maximum: 100.0, ranges: <GaugeRange>[
                    GaugeRange(
                        startValue: 0.0, endValue: 50.0, color: Colors.blue),
                    GaugeRange(
                        startValue: 50.0, endValue: 75.0, color: Colors.orange),
                    GaugeRange(
                        startValue: 75.0, endValue: 100.0, color: Colors.red)
                  ], pointers: <GaugePointer>[
                    NeedlePointer(value: double.parse(widget.humid))
                  ], annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                        widget: Container(
                            child: Text("Humidity\n  " + widget.humid + "%",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold))),
                        angle: 90,
                        positionFactor: 0.5)
                  ])
                ],
              ),
            ),
            Text('2021 \u00a9 K Pranav Bharadwaj'), //copyright should remain if used
          ],
        ),
      ),
    );
  }
}
