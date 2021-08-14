import 'package:flutter/material.dart';

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

  Widget _body() {
    return Container(
      child: Center(
        child: const Text("Home"),
      ),
    );
  }
}
