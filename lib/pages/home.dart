import 'dart:convert';

import 'package:exercise/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _controller = TextEditingController();

  String _query = "";

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
      _getUri(),
      headers: {
        'x-apikey': '5c5c7076f210985199db5488',
      },
    );

    if (response.statusCode == 200) {
      final users = (json.decode(response.body) as List)
          .map((i) => User.fromJson(i))
          .toList();

      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }

  Uri _getUri() {
    Uri uri;

    if (_query.isEmpty) {
      uri = Uri(
        scheme: 'https',
        host: 'exercise-646d.restdb.io',
        path: 'rest/group-1',
      );
    } else {
      uri = Uri(
        scheme: 'https',
        host: 'exercise-646d.restdb.io',
        path: 'rest/group-1',
        queryParameters: {'q': '{"CITY":"$_query"}'},
      );
    }

    return uri;
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [_filterByCity(), _content()],
      ),
    );
  }

  Widget _showEmptyPrompt() {
    return Center(
      child: Text("No users in '$_query' found"),
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

  Widget _content() {
    return FutureBuilder<List<User>>(
      future: _future(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _showLoading();
        }

        if (snapshot.hasData) {
          if (snapshot.data.isEmpty) {
            return _showEmptyPrompt();
          }

          return Expanded(child: _listView(snapshot.data));
        }

        if (snapshot.hasError) {
          return _showError(snapshot.error.toString());
        }

        return _showLoading();
      },
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
    setState(() {
      _query = _controller.text;
    });
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
