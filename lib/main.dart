import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<CatPhoto> fetchAlbum() async {
  int number = generateRamdomNumber();
  String url = 
  'https://api.thecatapi.com/v1/images/search';

  final response = await http
      .get(Uri.parse(url));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return CatPhoto.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

int generateRamdomNumber(){
  Random numeroAleatorio = new Random();
  return numeroAleatorio.nextInt(5000);
}

class Album {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  const Album({
    required this.albumId,
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });


  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      albumId: json['albumId'],
      id: json['id'],
      title: json['title'],
      url: json['url'],
      thumbnailUrl: json['thumbnailUrl'],
    );
  }
}

class CatPhoto {
  final String id;
  final String url;
  final int width;
  final int height;

  const CatPhoto({
    required this.id,
    required this.url,
    required this.width,
    required this.height,
  });


  factory CatPhoto.fromJson(List<dynamic> json) {
    return CatPhoto(
      id: json[0]['id'],
      url: json[0]['url'],
      width: json[0]['width'],
      height: json[0]['height'],
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<CatPhoto> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minha aplicação',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example hehe'),
        ),
        body: Center(
          child: FutureBuilder<CatPhoto>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                
                return Container(
                  child: Image.network(snapshot.data!.url),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}