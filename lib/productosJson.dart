import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final_sri/docume.dart';
import 'package:flutter_final_sri/provider_productos.dart';
import 'package:http/http.dart' as http;
// import 'package:search_widget/search_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/scaled_tile.dart';
import 'package:provider/provider.dart';
//buscador

class Post {
  final String title;
  final String body;
  Post(this.title, this.body);
}

class   ProductosJsonSearchPage extends StatefulWidget {
  @override
  _ProductosJsonSearchPageState createState() =>
      _ProductosJsonSearchPageState();
}

class _ProductosJsonSearchPageState extends State<ProductosJsonSearchPage> {
  final SearchBarController<Photo> _searchBarController = SearchBarController();
  bool isReplay = false;

  //  dynamic o = fetchPhotos(http.Client());
  Future<List<Photo>> _getALlPosts(String text) async {
    //await Future.delayed(Duration(seconds: text.length == 4 ? 1 : 1));
    // if (isReplay) return [Post("Replaying !", "Replaying body")];
    // if (text.length == 5) throw Error();
    // if (text.length == 6) return [];
    // List<Post> posts = [];
    // List<Photo> t = await fetchPhotos(http.Client());
    List<Photo> t = await fetchPhotos(http.Client());
    //print("gol > "+temporal.length.toString());
    List<Photo> temi = [];
    for (Photo item in t) {
      if (item.codigo_art.contains(text.toUpperCase()) ||
          item.nombre_art.contains(text.toUpperCase())) {
        temi.add(item);
      }
    }
    return temi;
    // return List.generate(text.length, (int index) {
    //   t.
    // return Photo(nombre_art: "$text $index",
    // codigo_art: "$text $index"
    //   //"def :$text $index",
    //   );
    // });

    // final productoInfo=Provider.of<ProductosArrayInfo>(context);
    // posts = productoInfo.productosJson;
    // var random = new Random();
    // for (int i = 0; i < 10; i++) {
    //   posts.add(Post("$text $i", "body random number : ${random.nextInt(100)}"));
    // }
    //return posts;
    // return t;
  }

  @override
  Widget build(BuildContext context) {
    final productoInfo=Provider.of<ProductosArrayInfo>(context);
    //productoInfo.forSearch =
    // fetchPhotos(http.Client()).then((val){
    //   productoInfo.forSearch = val;
    // });
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blueAccent),
      body: SafeArea(
        child: SearchBar<Photo>(
          searchBarPadding: EdgeInsets.symmetric(horizontal: 15),
          headerPadding: EdgeInsets.symmetric(horizontal: 10),
          listPadding: EdgeInsets.symmetric(horizontal: 10),
          onSearch: _getALlPosts,
          searchBarController: _searchBarController,
          placeHolder: productoJsonPe(
            title: 'tu vieja',
          ), // Text("asda"),
          cancellationWidget: Text("Cancel"),
          emptyWidget: Text("empty"),
          indexedScaledTileBuilder: (int index) =>
              ScaledTile.count(3, 0.2), //, //index.isEven ? 2 : 1),
          header: Row(
            children: <Widget>[
              // RaisedButton(
              //   child: Text("sort"),
              //   onPressed: () {
              //     _searchBarController.sortList((Post a, Post b) {
              //       return a.body.compareTo(b.body);
              //     });
              //   },
              // ),
              // RaisedButton(
              //   child: Text("Desort"),
              //   onPressed: () {
              //     _searchBarController.removeSort();
              //   },
              // ),
              // RaisedButton(
              //   child: Text("Replay"),
              //   onPressed: () {
              //     isReplay = !isReplay;
              //     _searchBarController.replayLastSearch();
              //   },
              // ),
            ],
          ),
          onCancelled: () {
            // print("Cancelled triggered");
          },
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          // shrinkWrap: true,
          crossAxisCount: 1,
          onItemFound: (Photo post, int index) {
            return Card(
              // height: 10,
              color: Colors.white,
              child: ListTile(
                leading: IconButton(icon: Icon(Icons.add), 
                onPressed: () async{
                  productoInfo.productosDB=[post.nombre_art,post.codigo_art];
                  Navigator.pop(context);

                }),
                title: Text(post.nombre_art),
                isThreeLine: true,
                subtitle: Text(post.codigo_art),
                onTap: () {
                  // Navigator.of(context)
                  //     .push(MaterialPageRoute(builder: (context) => Detail()));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class Detail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Text("Detalles"),
          ],
        ),
      ),
    );
  }
}

//buscador termina
List<Photo> temporal = [];
Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response =
      await client.get('http://167.172.203.137/services/mssql/getproductos');
  client.close();
//      await client.get('https://jsonplaceholder.typicode.com/photos');
  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsePhotos, response.body);
}

// A function that converts a response body into a List<Photo>.
List<Photo> parsePhotos(String responseBody) {
  // final productoInfo=Provider.of<ProductosArrayInfo>(context);
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  //return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
  temporal = parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
  return temporal;
}

class Photo {
//  final int albumId;
//  final int id;
//  final String title;
//  final String url;
//  final String thumbnailUrl;

  final String codigo_art;
  final String nombre_art;
//  final String cod_corregir;
//  final String nombre_principal;
//  final String rgb;
//  final String color;
//  final String accion;
//  final String observaciones;
//  final String codificacion;
//  final String des_codificacion;
//  final String aux;

//  Photo({this.albumId, this.id, this.title, this.url, this.thumbnailUrl});
  Photo(
      {this.codigo_art,
      this.nombre_art}); //this.cod_corregir, this.nombre_principal,
//    this.rgb, this.color, this.accion, this.observaciones, this.codificacion, this.des_codificacion, this.aux});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      codigo_art: json['codigo_art'],
      nombre_art: json['nombre_art'],
//      cod_corregir: json['cod_corregir'],
//      nombre_principal: json['nombre_principal'],
//      rgb: json['rgb'],
//      color: json['color'],
//      accion: json['accion'] ,
//      observaciones: json['observaciones'] ,
//      codificacion: json['codificacion'] ,
//      des_codificacion: json['des_codificacion'],
//      aux: json['aux'] ,

//      albumId: json['albumId'] as int,
//      id: json['id'] as int,
//      title: json['title'] as String,
//      url: json['url'] as String,
//      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }
}

//void main() => runApp(MyApp());

class productoJson extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Lista de productos';

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
      // appBar: AppBar(
      //   title: Text(title),
      // ),
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
          crossAxisCount: 1, crossAxisSpacing: 0, childAspectRatio: 8.1),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return SizedBox(
          height: 100,
          child: Card(
              child: Column(
            children: <Widget>[
              Text("\t" + photos[index].nombre_art == null
                  ? ''
                  : "\t" + photos[index].nombre_art),
              Text("\t" + photos[index].codigo_art == null
                  ? ''
                  : "\t" + photos[index].codigo_art)
            ],
          )),
        );
        //Image.network(photos[index].thumbnailUrl);
      },
    );
  }
}
