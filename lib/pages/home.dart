import 'dart:convert';

import 'package:exercise/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final apiKey = "";
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
          return _content(snapshot.data);
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

  Widget _content(List<User> users) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _filterByCity(),
          Expanded(child: _listView(users)),
        ],
      ),
    );
  }

  Widget _filterByCity() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(child: _textField()),
          _filterButton(),
        ],
      ),
    );
  }

  Widget _textField() {
    return TextField(
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Filter By City',
      ),
      controller: _controller,
    );
  }

  Widget _filterButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: RaisedButton(
        onPressed: _onFilterButtonPressed,
        child: const Text("Filter"),
      ),
    );
  }

  void _onFilterButtonPressed() {
    print("Button pressed");
  }

  Widget _listView(List<User> users) {
    return ListView.builder(
      shrinkWrap: true,
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
