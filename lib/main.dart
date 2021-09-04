import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  void getData() async {
    try {
      final response =
          await Dio().get("https://pokeapi.co/api/v2/pokemon/ditto");
      print(response.data);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    this.getData();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
            title: Text(
              "Pokemon",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            elevation: 0),
        body: ListView.builder(
            itemCount: 10,
            itemBuilder: (item, index) {
              return Text("Pokemon $index");
            }),
      ),
    );
  }
}
