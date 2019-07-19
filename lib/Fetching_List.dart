import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FetchingList extends StatefulWidget {
  _FetchingListState createState() => _FetchingListState();
}

class _FetchingListState extends State<FetchingList> {
  String uri = 'https://jsonplaceholder.typicode.com/users';
  List<Users> listOfUsers;
  Future<List<Users>> _fetchUsers() async {
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var items = data as List;
      listOfUsers =
          items.map<Users>((parsedJson) => Users.fromJson(parsedJson)).toList();
    } else {
      throw Exception('Failed');
    }
    return listOfUsers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetching data from JSON - ListView'),
      ),
      body: FutureBuilder<List<Users>>(
        future: _fetchUsers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return ListView(
            children: snapshot.data
                .map((user) => ListTile(
                      title: Text(user.name),
                      subtitle: Text(user.email),
                      leading: CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Text(user.name[0],
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            )),
                      ),
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}

class Users {
  int id;
  String name;
  String username;
  String email;

  Users({this.id, this.name, this.username, this.email});

  //for constructing a new User instance from a map structure.
  Users.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        name = parsedJson['name'],
        username = parsedJson['username'],
        email = parsedJson['email'];

  //which converts a User instance into a map.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'username': username,
        'email': email,
      };
}
