import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crud/insertApi.dart';

class ApiUserPage extends StatefulWidget {
  const ApiUserPage({super.key});

  @override
  State<ApiUserPage> createState() => _ApiUserPageState();
}

class _ApiUserPageState extends State<ApiUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => InsertApi(null)));
              },
              icon: Icon(Icons.add_box))
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getDataFromApi(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Column(
                        children: [
                          // Image.network(snapshot.data![index]['image']),
                          // if (snapshot.data != null)
                          Text(snapshot.data![index]['name']),
                          Text(snapshot.data![index]['country']),
                          IconButton(
                            onPressed: () {
                              deleteFromApi(snapshot.data![index]['ID'])
                                  .then((value) {
                                setState(() {});
                              });
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      InsertApi(snapshot.data![index])));
                            },
                            icon: Icon(Icons.add),
                          ),
                        ],
                      ),
                    );
                  });
            }
          }
          return Text("Hello");
        },
      ),
    );
  }

  Future<List<dynamic>> getDataFromApi() async {
    var res = await http
        .get(Uri.parse('https://64dcce83e64a8525a0f72b97.mockapi.io/students'));
    print(res.body);
    return jsonDecode(res.body);
  }

  Future<void> deleteFromApi(String id) async {
    await http.delete(
        Uri.parse('https://64dcce83e64a8525a0f72b97.mockapi.io/students/$id'));
  }

  Future<void> insertInApi(Map<String, dynamic> user) async {
    var res = await http.post(
        Uri.parse('https://64dcce83e64a8525a0f72b97.mockapi.io/students'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user));
  }
}
