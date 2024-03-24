import 'dart:convert';
import 'dart:js_util';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crud/apiUserPage.dart';
import 'package:http/http.dart' as http;

class InsertApi extends StatefulWidget {
  Map<String, Object?>? map;

  InsertApi(map) {
    this.map = map;
  }

  @override
  State<InsertApi> createState() => _InsertApiState();
}

class _InsertApiState extends State<InsertApi> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController rankingController = new TextEditingController();
  TextEditingController countryController = new TextEditingController();
  TextEditingController scoreController = new TextEditingController();
  TextEditingController idController = new TextEditingController();

  void initState() {
    nameController.text =
        widget.map == null ? '' : widget.map!["name"].toString();
    rankingController.text =
        widget.map == null ? '' : widget.map!["ranking"].toString();
    countryController.text =
        widget.map == null ? '' : widget.map!['country'].toString();
    scoreController.text =
        widget.map == null ? '' : widget.map!['score'].toString();
    idController.text =
        widget.map == null ? '' : widget.map!['ID'].toString();
  }

  GlobalKey<FormState> validationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Enter User Name',
                labelText: 'Enter User Name',
              ),
            ),
            TextFormField(
              controller: rankingController,
              decoration: InputDecoration(
                hintText: 'Enter Ranking',
                labelText: 'Enter Ranking',
              ),
            ),
            TextFormField(
              controller: countryController,
              decoration: InputDecoration(
                hintText: 'Enter Country',
                labelText: 'Enter Country',
              ),
            ),
            TextFormField(
              controller: scoreController,
              decoration: InputDecoration(
                hintText: 'Enter Score',
                labelText: 'Enter Score',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Map<String, dynamic> map = Map();
                map['name'] = nameController.text;
                map['ranking'] = rankingController.text;
                map['country'] = countryController.text;
                map['score'] = scoreController.text;

                print(map);
                print(idController.text);

                if (widget.map==null) {
                  await insertInApi(map).then((value) => Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => ApiUserPage())));
                }
                else{
                  await updateInApi(map,idController.text.toString()).then((value) => Navigator.of(context)
                      .push(MaterialPageRoute(
                      builder: (context) => ApiUserPage())));
                }
              },
              child: Text('Submit'),
            )
          ],
        ),
      ),
    );
  }

  void displayAlert(context, title, message, onPopAlert) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onPopAlert();
                },
                child: Text('Ok'))
          ],
        );
      },
    );
  }

  Future<void> insertInApi(Map<String, dynamic> user) async {
    print(user);
    var res = await http.post(
        Uri.parse('https://64dcce83e64a8525a0f72b97.mockapi.io/students'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user));
  }

  Future<void> updateInApi(Map<String,dynamic> user,String id)async{
    print("Update");
    print(user);
    print(id);
    var res = await http.put(
        Uri.parse('https://64dcce83e64a8525a0f72b97.mockapi.io/students/'+id),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user));
  }
}
