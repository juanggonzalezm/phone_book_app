import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  var apiUrl = Uri.parse('https://randomuser.me/api/?results=10');

  Future<List<dynamic>> fetchUsers() async {
    var result = await http.get(apiUrl);
    return json.decode(result.body)['results'];
  }

  String _name(dynamic user) {
    return user['name']['title'] +
        " " +
        user['name']['first'] +
        " " +
        user['name']['last'];
  }

  String _location(dynamic user) {
    return user['location']['country'];
  }

  String _age(Map<dynamic, dynamic> user) {
    return "Age: " + user['dob']['age'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyApp',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Phone Book'),
        ),
        body: Container(
          child: FutureBuilder<List<dynamic>>(
            future: fetchUsers(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(snapshot
                                      .data[index]['picture']['large'])),
                              title: Text(_name(snapshot.data[index])),
                              subtitle: Text(_location(snapshot.data[index])),
                              trailing: Text(_age(snapshot.data[index])),
                            )
                          ],
                        ),
                      );
                    });
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}