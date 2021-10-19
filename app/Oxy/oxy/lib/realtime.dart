import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'main.dart';
import 'dart:convert';
import 'dart:async';
import 'notifications.dart';

class realtime extends StatefulWidget {
  @override
  _realtimeState createState() => _realtimeState();
}

class _realtimeState extends State<realtime> {
  DateTime currentTime = DateTime.now();
  DateTime delayTime = DateTime.now();
  final List<double> oxygenGraph = [0, 0, 0, 0];
  final List<double> bpmGraph = [0, 0, 0, 0];

  final NotificationService notifi = new NotificationService();

  int _valueTimeOxy = 1;
  int _valueMHOxy = 1;
  int _valueOxyPercent = 1;
  int oxygenPercentNotification = 90;

  List<int> timeTable = [5, 10, 15, 20, 30, 45, 60];

  int notificationDelay = 5;

  String oxygen = '0';
  String bpm = '0';
  
  final List<Color> gradientColors = [
    const Color(0xffb71c1c),
    const Color(0xffef9a9a),
  ];

  void getData() async {
    final ref = referenceDatabase.reference();
    ref.child('oxygen').once().then((DataSnapshot data) {
      oxygen = data.value.toString();
      print(data.value);
      print(data.key);
    });
    ref.child('bpm').once().then((DataSnapshot data) {
      bpm = data.value.toString();
      print(data.value);
      print(data.key);
    });
    if (oxygenGraph.length < 4) {
      oxygenGraph.add(double.parse(oxygen));
    } else {
      oxygenGraph.removeAt(0);
      oxygenGraph.add(double.parse(oxygen));
    }
    if (bpmGraph.length < 4) {
      if (double.parse(bpm) < 120 && double.parse(bpm) >= 0) {
        bpmGraph.add(double.parse(bpm));
      }
    } else {
      if (double.parse(bpm) < 120 && double.parse(bpm) >= 0) {
        bpmGraph.removeAt(0);
        bpmGraph.add(double.parse(bpm));
      }
    }
    if (int.parse(oxygen) < oxygenPercentNotification) {
      if (delayTime.difference(DateTime.now()).inSeconds < 0) {
        notifi.instantNofitication();
        if (_valueMHOxy == 1) {
          delayTime = DateTime.now().add(Duration(seconds: notificationDelay));
        }
        if (_valueMHOxy == 2) {
          delayTime = DateTime.now().add(Duration(hours: notificationDelay));
        }
      }
    }
    setState(() {});
  }

  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => getData());
    //Provider.of<NotificationService>(context, listen: false).initialize();
    notifi.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text("oxy"),
          centerTitle: true,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.camera),
              ),
              Tab(
                icon: Icon(Icons.text_fields),
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          Container(
            child: Center(
              child: Column(
                //shrinkWrap: true,

                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Oxygen =" + oxygen + '%',
                        textScaleFactor: 2,
                      ),
                    ),
                  ),
                  Flexible(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Center(
                        child: LineChart(LineChartData(
                            minX: 0,
                            maxX: 4,
                            minY: 0,
                            maxY: 100,
                            titlesData: LineTitles.getTitleData(),
                            gridData: FlGridData(
                              show: true,
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                  color: Colors.teal,
                                  strokeWidth: 1,
                                );
                              },
                              getDrawingVerticalLine: (value) {
                                return FlLine(
                                    color: Colors.teal, strokeWidth: 1);
                              },
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                  spots: [
                                    FlSpot(0, oxygenGraph[0]),
                                    FlSpot(2, oxygenGraph[1]),
                                    FlSpot(3, oxygenGraph[2]),
                                    FlSpot(4, oxygenGraph[3]),
                                  ],
                                  isCurved: false,
                                  barWidth: 5,
                                  colors: gradientColors,
                                  belowBarData: BarAreaData(
                                      show: true,
                                      colors: gradientColors
                                          .map(
                                              (color) => color.withOpacity(0.3))
                                          .toList()))
                            ])),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Beats per Minute= " + bpmGraph[3].toString(),
                        textScaleFactor: 2,
                      ),
                    ),
                  ),
                  Flexible(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Center(
                        child: LineChart(LineChartData(
                            minX: 0,
                            maxX: 4,
                            minY: 0,
                            maxY: 100,
                            titlesData: LineTitles.getTitleData(),
                            gridData: FlGridData(
                              show: true,
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                  color: Colors.teal,
                                  strokeWidth: 1,
                                );
                              },
                              getDrawingVerticalLine: (value) {
                                return FlLine(
                                    color: Colors.teal, strokeWidth: 1);
                              },
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                  spots: [
                                    FlSpot(0, bpmGraph[0]),
                                    FlSpot(2, bpmGraph[1]),
                                    FlSpot(3, bpmGraph[2]),
                                    FlSpot(4, bpmGraph[3]),
                                  ],
                                  isCurved: false,
                                  barWidth: 5,
                                  colors: gradientColors,
                                  belowBarData: BarAreaData(
                                      show: true,
                                      colors: gradientColors
                                          .map(
                                              (color) => color.withOpacity(0.3))
                                          .toList()))
                            ])),
                      ),
                    ),
                  ),
                  Text(
                    "No Fall Detected",
                    textScaleFactor: 2,
                  )
                ],
              ),
            ),
          ),
          Container(
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Notify Me Every",
                      textScaleFactor: 3,
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton(
                              value: _valueTimeOxy,
                              items: [
                                DropdownMenuItem(
                                  child: Text("5"),
                                  value: 1,
                                ),
                                DropdownMenuItem(
                                  child: Text("10"),
                                  value: 2,
                                ),
                                DropdownMenuItem(
                                  child: Text("15"),
                                  value: 3,
                                ),
                                DropdownMenuItem(
                                  child: Text("20"),
                                  value: 4,
                                ),
                                DropdownMenuItem(
                                  child: Text("30"),
                                  value: 5,
                                ),
                                DropdownMenuItem(
                                  child: Text("45"),
                                  value: 6,
                                ),
                                DropdownMenuItem(
                                  child: Text("60"),
                                  value: 7,
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _valueTimeOxy = value;
                                  notificationDelay = timeTable[value];
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton(
                              value: _valueMHOxy,
                              items: [
                                DropdownMenuItem(
                                  child: Text("Minutes"),
                                  value: 1,
                                ),
                                DropdownMenuItem(
                                  child: Text("Hours"),
                                  value: 2,
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _valueMHOxy = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "If Oxygen Level drops less than",
                        textScaleFactor: 3,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton(
                      value: _valueOxyPercent,
                      items: [
                        DropdownMenuItem(
                          child: Text("90%"),
                          value: 1,
                        ),
                        DropdownMenuItem(
                          child: Text("80%"),
                          value: 2,
                        ),
                        DropdownMenuItem(
                          child: Text("70%"),
                          value: 3,
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _valueOxyPercent = value;
                          if (value == 1) {
                            oxygenPercentNotification = 90;
                          }
                          if (value == 2) {
                            oxygenPercentNotification = 80;
                          }
                          if (value == 3) {
                            oxygenPercentNotification = 70;
                          }
                        });
                      },
                    ),
                  ),
                  ElevatedButton(
                    child: Text("SendNotification"),
                    onPressed: () {
                      notifi.instantNofitication();
                    },
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class LineTitles {
  static getTitleData() => FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 35,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'Last 10 Readings';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: false,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 55:
                return 'Oxygen %';
            }
            return '';
          },
          reservedSize: 35,
          margin: 5,
        ),
      );
}
