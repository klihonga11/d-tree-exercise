import 'dart:convert';

import 'package:exercise/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text("D Tree Exercise"),
    );
  }

  Future<List<User>> _future() async {
    final response = await http.get(
      Uri.parse('https://exercise-646d.restdb.io/rest/group-1'),
      headers: {
        'x-apikey': '5c5c7076f210985199db5488',
      },
    );

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((i) => User.fromJson(i))
          .toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Widget _body() {
    return FutureBuilder<List<User>>(
      future: _future(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _listView(snapshot.data);
        }

        if (snapshot.hasError) {
          return _showError(snapshot.error.toString());
        }

        return _showLoading();
      },
    );
  }

  Widget _showError(String message) {
    return Center(
      child: Text(message),
    );
  }

  Widget _showLoading() {
    return Center(
      child: const CircularProgressIndicator(),
    );
  }

  Widget _listView(List<User> users) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: users.length,
      itemBuilder: (context, index) {
        return _listItem(users[index]);
      },
    );
  }

  Card _listItem(User user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${user.name}"),
            Text("Surname: ${user.surname}"),
            Text("Age: ${user.age}"),
            Text("City: ${user.city}"),
          ],
        ),
      ),
    );
  }
}
