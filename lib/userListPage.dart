import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crud/userEntry.dart';

import 'database.dart';

class UserListPage extends StatefulWidget {
  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return UserEntry(null);
                  },
                ),
              ).then((value) {
                setState(() {});
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.add,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder(future: MyDatabase().copyPasteAssetFileToRoot(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FutureBuilder(
                  future: MyDatabase().getUserListFromUserTable(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index)
                          {
                            return Card(
                              margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                              child: Padding  (
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(snapshot.data![index]['Name']
                                          .toString()),
                                    ),
                                    // SizedBox(width: 10,),
                                    Expanded(
                                      child: Text(snapshot.data![index]['CityName']
                                          .toString()),
                                    ),
                                    SizedBox(width: 10,),
                                    // SizedBox(width: 10,),
                                    IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () async {
                                          await Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) {
                                              return UserEntry(snapshot.data![index]);
                                            },)).then((value) => setState(() {}),);
                                        }
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          displayAlert(context, 'Delete', 'Are you Sure want to delete',
                                                  ()
                                              {
                                                MyDatabase().deleteUserByUserId(
                                                    snapshot.data![index]["UserID"])
                                                    .then((value) => setState(() {}),);
                                              });
                                        }
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    }
                    else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }
              );
            }
            if (snapshot.data == null) {
              return Text("No Data Found");
            }
            else {
              return Text("Data Copy");
            }
          }
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
                },
                child: Text('Cancel')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onPopAlert();
                },
                child: Text('Ok')),
          ],
        );
      },
    );
  }
}
