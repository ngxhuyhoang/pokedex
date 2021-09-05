import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

const URL = 'https://pokeapi.co/api/v2/pokemon';

Future<Response> getData() async {
  final response = await http.get(Uri.parse(URL));
  return Response.fromJson(jsonDecode(response.body));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  late Future<Response> data;

  void initState() {
    super.initState();
    data = getData();
  }

  @override
  Widget build(BuildContext context) {
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
        body: FutureBuilder<Response>(
          future: this.data,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.pokemon.length,
                  itemBuilder: (_, index) {
                    return PokemonCard(
                      name: snapshot.data!.pokemon[index].name,
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class PokemonCard extends StatelessWidget {
  final String name;

  PokemonCard({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext buildContext) {
    return Container(
        margin: EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Card(
            child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            name,
                            style: TextStyle(fontSize: 16),
                          ),
                        ]),
                  ],
                ))));
  }
}

class Response {
  int count = 0;
  String next = '';
  Null previous;
  List<dynamic> pokemon = [];

  Response(
      {required this.count,
      required this.next,
      this.previous,
      required this.pokemon});

  Response.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      pokemon = json['results']
          .map((x) => Pokemon(name: x['name'], url: x['url']))
          .toList();
    }
  }
}

class Pokemon {
  String name = '';
  String url = '';

  Pokemon({required this.name, required this.url});
}
