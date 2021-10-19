import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:oxy/home.dart';
import 'boxes.dart';
import 'package:get/get.dart';
import 'main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

class addPatient extends StatefulWidget {
  addPatient({Key? key}) : super(key: key);

  @override
  State<addPatient> createState() => _addPatientState();
}

class _addPatientState extends State<addPatient> {
  List list_items = [];
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/asset.json');
    final data = await json.decode(response);
    setState(() {
      list_items = data["items"];
    });
  }

  var box = Hive.openBox('testbox');
  var dir;

  final TextEditingController _controllerName = TextEditingController();

  final TextEditingController _controllerAge = TextEditingController();

  final TextEditingController _controllerMQTT = TextEditingController();

  final TextEditingController _controllerDeviceID = TextEditingController();

  final TextEditingController _controllerKey = TextEditingController();

  final TextEditingController _controllerMedicalHistory =
      TextEditingController();

  void hiveDispose() {
    Hive.close();
  }

  void textControllerDispose() async {
    _controllerName.dispose();
    _controllerAge.dispose();
    _controllerMQTT.dispose();
    _controllerDeviceID.dispose();
    _controllerKey.dispose();
    _controllerMedicalHistory.dispose();
    print("Disposed Text controllers");

    // var valueList = await Hive.openBox<Person>('persons');
    //var data = valueList.keys;
    //print(data);
  }

  Future openBox() async {
    //dir = await getApplicationSupportDirectory();
    //Hive.init(dir.path);
    Box box = await Hive.openBox('testbox');
  }

  @override
  void initState() {
    super.initState();
    openBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter New Patient Data"),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          elevation: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Patient Name'),
                    controller: _controllerName,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Age'),
                    controller: _controllerAge,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Device ID'),
                    controller: _controllerDeviceID,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Key'),
                    controller: _controllerKey,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Patient medical history'),
                    controller: _controllerMedicalHistory,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.1,
                child: RaisedButton(
                  elevation: 100,
                  onPressed: () async {
                    Navigator.pop(context, {
                      "ID": _controllerDeviceID.text,
                      "Name": _controllerName.text,
                      "Age": _controllerAge.text,
                      "History": _controllerMedicalHistory.text
                    });
                  },
                  child: Text("Add Patient"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
