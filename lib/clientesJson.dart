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

class ClientesJsonSearchPage extends StatefulWidget {
  @override
  _ClientesJsonSearchPageState createState() =>
      _ClientesJsonSearchPageState();
}

class _ClientesJsonSearchPageState extends State<ClientesJsonSearchPage> {
  final SearchBarController<Photo> _searchBarController = SearchBarController();
  bool isReplay = false;

  //  dynamic o = fetchPhotos(http.Client());
  Future<List<Photo>> _getALlPosts(String text) async {
    List<Photo> t = await fetchClientes(http.Client(), text,"10004");//cambiar
    return t;
  }

  @override
  Widget build(BuildContext context) {
    final productoInfo=Provider.of<ProductosArrayInfo>(context);
    //productoInfo.forSearch =
    // fetchPhotos(http.Client()).then((val){
    //   productoInfo.forSearch = val;
    // });
    return Scaffold(
      body: SafeArea(
        child: SearchBar<Photo>(
          searchBarPadding: EdgeInsets.symmetric(horizontal: 15),
          headerPadding: EdgeInsets.symmetric(horizontal: 10),
          listPadding: EdgeInsets.symmetric(horizontal: 10),
          // onSearch: _getALlPosts,
          onSearch: (texto)async{
            List<Photo> t = await fetchClientes(http.Client(), texto,productoInfo.xml_empresaElegida);//cambiar
            return t;
          },
          searchBarController: _searchBarController,
          placeHolder: Center(
            child: 
             Text("Introducir nombre/codigo cliente/r.u.c."
             ,style: TextStyle(fontSize: 20),
             ),
            ),
          // placeHolder: productoJsonPe(
          //   title: 'tu vieja',
          // ), // Text("asda"),
          cancellationWidget: Text("Cancel"),
          emptyWidget: Text("empty"),
          indexedScaledTileBuilder: (int index) =>
              ScaledTile.count(3, 0.27), //, //index.isEven ? 2 : 1),
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
            print("Cancelled triggered");
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
                onPressed: () {
                  // productoInfo.clienteElegido=Container(
                  //   // width: 500,
                  //   child: Column(
                  //     children: <Widget>[
                  //       Align(alignment: Alignment.topLeft,child: Text("Nombre: "+post.nombre_cli,)),
                  //       Align(alignment:Alignment.topLeft,child: Text("Codigo: "+post.codigo_cli,maxLines: 1,)),
                  //       Align(alignment: Alignment.topLeft,child: Text("R.U.C.: "+post.rucci_cli,maxLines: 1,)),
                  //       Align(alignment: Alignment.topLeft, child: Text("email : "+post.telefo_cli,maxLines: 1,)),
                  //       // Text(post.),
                  //     ],
                  //   ),
                  // );

                  ClienteElegido cli = new ClienteElegido(nombre: post.nombre_cli,
                  codigo: post.codigo_cli, ruc: post.rucci_cli,email: post.email_cli ); 
                  //actualiza todos los datos del cloente
                  productoInfo.clienteActual = cli;
                  productoInfo.xml_ruc_comprador = post.rucci_cli;
                  productoInfo.xml_cod_comprador = post.codigo_cli;
                  productoInfo.xml_razonSocial_comprador = post.nombre_cli;
                  productoInfo.xml_email_comprador = post.email_cli;
                }),
                title: Text(post.nombre_cli,textAlign: TextAlign.center),
                isThreeLine: true,
                subtitle: Column(
                  children: <Widget>[
                    Text("cod. cliente : "+post.codigo_cli),
                    Text("R.U.C.: "+post.rucci_cli),
                    Text("email : "+post.email_cli),
                    Text("telefono : "+post.telefo_cli),
                    // Text(post.),
                  ],
                ),
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


Future<List<Photo>> fetchClientes(
    http.Client client,String clientDato ,String empreCod) async {
  // Map map = new Map<String, dynamic>();
  // map["empresa"] = empreCod;
    Map data = {
    'client': clientDato,
    'empresa_id': empreCod
  };
  //encode Map to JSON
  var body = json.encode(data);
  print('asumiendo post > ' + body.toString());
  final response = await client
      .post('http://167.172.203.137/services/mssql/getclient',
      headers: {"Content-Type": "application/json"},
       body: body);
  client.close();
//      await client.get('https://jsonplaceholder.typicode.com/photos')
  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsePhotos, response.body);
}


//buscador termina

List<Photo> temporal = [];
Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response =
      await client.get('http://167.172.203.137/services/mssql/getclient');
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

  final String codigo_cli;
  final String nombre_cli;
  final String razsoc_cli;
  final String rucci_cli;
  final String direcc_cli;
  final String telefo_cli;
  final String email_cli;

//  Photo({this.albumId, this.id, this.title, this.url, this.thumbnailUrl});
  Photo(
      {this.codigo_cli,
      this.nombre_cli,
      this.razsoc_cli,
      this.rucci_cli,
      this.direcc_cli,
      this.telefo_cli,
      this.email_cli

      }); //this.cod_corregir, this.nombre_principal,
//    this.rgb, this.color, this.accion, this.observaciones, this.codificacion, this.des_codificacion, this.aux});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      codigo_cli: json['codigo_cli'],
      nombre_cli: json['nombre_cli'],
      razsoc_cli: json['razsoc_cli'],
      rucci_cli:  json['rucci_cli'],
      direcc_cli: json['direcc_cli'],
      telefo_cli: json['telefo_cli'],
      email_cli: json['email_cli'],
    );
  }
}

//void main() => runApp(MyApp());

// class productoJson extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final appTitle = 'Lista de productos';

//     return MaterialApp(
//       title: appTitle,
//       home: productoJsonPe(title: appTitle),
//     );
//   }
// }

// class productoJsonPe extends StatelessWidget {
//   final String title;

//   productoJsonPe({Key key, this.title}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text(title),
//       // ),
//       body: FutureBuilder<List<Photo>>(
//         future: fetchPhotos(http.Client()),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) print(snapshot.error);

//           return snapshot.hasData
//               ? PhotosList(photos: snapshot.data)
//               : Center(child: CircularProgressIndicator());
//         },
//       ),
//     );
//   }
// }

// class PhotosList extends StatelessWidget {
//   final List<Photo> photos;
//   PhotosList({Key key, this.photos}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 1, crossAxisSpacing: 0, childAspectRatio: 8.1),
//       itemCount: photos.length,
//       itemBuilder: (context, index) {
//         return SizedBox(
//           height: 100,
//           child: Card(
//               child: Column(
//             children: <Widget>[
//               Text("\t" + photos[index].nombre_art == null
//                   ? ''
//                   : "\t" + photos[index].nombre_art),
//               Text("\t" + photos[index].codigo_art == null
//                   ? ''
//                   : "\t" + photos[index].codigo_art)
//             ],
//           )),
//         );
//         //Image.network(photos[index].thumbnailUrl);
//       },
//     );
//   }
// }
