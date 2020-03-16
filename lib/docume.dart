import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response = await client.get('http://167.172.203.137/services/mssql/getdocume');
  client.close();
//      await client.get('https://jsonplaceholder.typicode.com/photos');

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsePhotos, response.body);
}

// A function that converts a response body into a List<Photo>.
List<Photo> parsePhotos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

class Photo {
//  final int albumId;
//  final int id;
//  final String title;
//  final String url;
//  final String thumbnailUrl;

  final String empresa_id;
  final String codigo_doc;
  final String descrip_doc;
  final String numero_doc;

//  Photo({this.albumId, this.id, this.title, this.url, this.thumbnailUrl});
  Photo({this.empresa_id, this.codigo_doc, this.descrip_doc, this.numero_doc});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      empresa_id: json['empresa_id'] ,
      codigo_doc: json['codigo_doc'] ,
      descrip_doc: json['descrip_doc'],
      numero_doc: json['numero_doc'],

//      albumId: json['albumId'] as int,
//      id: json['id'] as int,
//      title: json['title'] as String,
//      url: json['url'] as String,
//      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }
}

//void main() => runApp(MyApp());

class documeJson extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Isolate Demo';

    return MaterialApp(
      title: appTitle,
      home: productoJsonPe(title: appTitle),
    );
  }
}

class productoJsonPe extends StatelessWidget {
  final String title;

  productoJsonPe({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Photo>>(
        future: fetchPhotos(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? PhotosList(photos: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class PhotosList extends StatelessWidget {
  final List<Photo> photos;

  PhotosList({Key key, this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,crossAxisSpacing: 0,childAspectRatio: 3.9
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return SizedBox(
          height: 120,
          child: Card(child: Text(photos[index].descrip_doc + "\n" + photos[index].empresa_id),),) ;
        //Image.network(photos[index].thumbnailUrl);
      },
    );
  }
}