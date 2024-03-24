import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'database.dart';

class UserEntry extends StatefulWidget {
  Map<String, Object?>? map;

  UserEntry(map) {
    this.map = map;
  }

  @override
  State<UserEntry> createState() => _UserEntryState();
}

class _UserEntryState extends State<UserEntry> {
  TextEditingController nameController = TextEditingController();
  TextEditingController cityIdController = TextEditingController();

  void initState() {
    nameController.text =
    widget.map == null ? '' : widget.map!["Name"].toString();
    cityIdController.text =
    widget.map == null ? '' : widget.map!["CityID"].toString();
  }

  GlobalKey<FormState> validationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'User Detail',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: validationKey,
          child: Column(
            children: [
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'ENTER NAME OF USER';
                  }
                },
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                  ),
                  hintText: 'Enter User Name',
                  labelText: 'Enter User Name',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'ENTER CityId';
                  }
                },
                controller: cityIdController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                  ),
                  hintText: 'Enter CityId',
                  labelText: 'Enter CityId',
                  suffix: Icon(
                    Icons.clear,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: () async {
                  if (validationKey.currentState!.validate()) {
                    if (widget.map == null) {
                      insertUser().then((value) {
                        print(value);
                        if (value>0) {
                          displayAlert(context, 'Success',
                              'User Detail Inserted Successfully',
                                  () {
                                Navigator.pop(context, true);
                              });
                        } else {
                          displayAlert(context, 'Success',
                              'User Detail  not Inserted Successfully',
                                  () {
                                Navigator.pop(context, true);
                              });
                        }
                      });
                    }
                    else {
                      editUser(widget.map!["UserID"]).then((value) {
                        if (value>0) {
                          displayAlert(context, 'Success',
                              'User Detail Updated Successfully',
                                  () {
                                Navigator.pop(context, true);
                              });
                        } else {
                          displayAlert(context, 'Success',
                              'User Detail not Updated Successfully',
                                  () {
                                Navigator.pop(context, true);
                              });
                        }

                      });
                    }
                  }
                },
                child: Text(
                  'SUBMIT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              )
            ],
          ),
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

  Future<int> insertUser() async {
    Map<String, Object?> map = Map<String, Object?>();
    map["Name"] = nameController.text;
    map["CityID"] = cityIdController.text;

    var res = await MyDatabase().insertDetailInTblUser(map);
    return res;
  }



  Future<int> editUser(UserID) async {
    Map<String, Object?> map = Map<String, Object?>();
    map["Name"] = nameController.text;
    map["CityID"] = cityIdController.text;

    var res = await MyDatabase().updateDetailInTblUserByUserId(map, UserID);
    return res;
  }
}
