import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:flutter/material.dart';
import 'package:flutter_final_sri/provider_productos.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
// import 'package:path_provider/path_provider.dart';

import 'package:open_file/open_file.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart'as cache_manager;


// void main() => runApp(MyApp());

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   String path;
//   // PDFDocument doc = await PDFDocument.fromURL('http://www.africau.edu/images/default/sample.pdf');

//   @override
//   initState() {
//     super.initState();
//   }

//   Future<String> get _localPath async {
//     final directory = await getApplicationDocumentsDirectory();

//     return directory.path;
//   }

//   Future<File> get _localFile async {
//     final path = await _localPath;
//     return File('$path/teste.pdf');
//   }

//   Future<File> writeCounter(Uint8List stream) async {
//     final file = await _localFile;

//     // Write the file
//     return file.writeAsBytes(stream);
//   }

//   Future<Uint8List> fetchPost() async {
//     final response = await http.get(
//         'https://expoforest.com.br/wp-content/uploads/2017/05/exemplo.pdf');
//     final responseJson = response.bodyBytes;

//     return responseJson;
//   }

//   loadPdf() async {
//     writeCounter(await fetchPost());
//     path = (await _localFile).path;

//     if (!mounted) return;

//     setState(() {});
//   }

//    loadPdfUltimo() async {
//     writeCounter(await fetchPost());
//     path = (await _localFile).path;

//     if (!mounted) return;

//     setState(() {});
//   }
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//         appBar: AppBar(
//           title: Text('Plugin example app'),
//         ),
//         body: Center(
//           child: Column(
//             children: <Widget>[
//               if (path != null)
//                 Container(
//                   height: 300.0,
//                   child: PdfViewer(
//                     filePath: path,
//                   ),
//                 )
//               else
//                 Text("Pdf is not Loaded"),
//               RaisedButton(
//                 child: Text("Load pdf"),
//                 onPressed: loadPdf,
//               )
//               ,
//               RaisedButton(
//                 child: Text("Load pdf ultimo"),
//                 onPressed: loadPdfUltimo,
//               )
//             ],
//           ),
//         ),

//     );
//   }
// }
// var dio = Dio();
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with AutomaticKeepAliveClientMixin<MyApp>{
  bool _isLoading = true;
  PDFDocument document;
  String url_descarga= "";
  String downloadMessage  = 'iniciando';
  bool _isDownloading=false;
  String nombrepdf="";
  String _openResult = 'Unknown';
  var dio = Dio();


  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  Future<void> openFile() async {

    final filePath = '/storage/emulated/0/update.apk';
    final result = await OpenFile.open(filePath);

    setState(() {
      _openResult = "type=${result.type}  message=${result.message}";
    });

  }

  loadDocument() async {
    // document = await PDFDocument.fromAsset('assets/sample.pdf');

    setState(() => _isLoading = false);
  }

  createPDF() async {
    setState(() => _isLoading = true);
    //genera el pdf nombre
    final p = await http.post('http://167.172.203.137/getpdfticketname',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{}));
    print(p.body.toString());
    String nombreTicket = p.body.toString();

    document = await PDFDocument.fromURL(
        "http://167.172.203.137/getpdfticket/" + nombreTicket);
    // "http://conorlastowka.com/book/CitationNeededBook-Sample.pdf");
    setState(() => _isLoading = false);
  }

  Future<http.Response> createAlbum(String title) {
    return http.post(
      'https://jsonplaceholder.typicode.com/albums',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
      }),
    );
  }
   void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }


  Future download1(Dio dio, String url, savePath) async {
    CancelToken cancelToken = CancelToken();
    try {
      await dio.download(url, savePath,
          onReceiveProgress: showDownloadProgress, cancelToken: cancelToken);
    } catch (e) {
      print(e);
    }
  }


  Future download2(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );
      print(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    final productoInfo = Provider.of<ProductosArrayInfo>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          backgroundColor: Colors.white,
          leading: Container(),
          centerTitle: true,
          title: Row(
            children: <Widget>[
              RaisedButton(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  color: Colors.red,
                  child: Text(
                    "Generar PDF",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    // createPDF();
                    List<Map<String, dynamic>> send=[] ;
                    setState(() => _isLoading = true);
                    for (CartitaProducto i in productoInfo.productosDB) {
                          if (i.activo) {
                            Map<String, dynamic> producto = {
                              "nombre":i.nombre,
                              "unitario":i.actualPrecio.text,
                              "cantidad":i.cantidad.toString(),
                              "total": i.finalPrecioSinImpuesto.text,
                              "impuesto": i.impuestoDescripcion.text,
                              "codigo": i.codigo
                              // "dscsf": send
                            } ;
                            send.add(producto) ;
                      }
                    }
                    //genera el pdf nombre
                    final p =
                        await http.post('http://167.172.203.137/getpdfticketname',
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                            },
                            body: jsonEncode(<String, String>{
                              'tipo_pdf':'2',
                              'ambiente':'2',//productoInfo.xml_ambiente,
                              'dirSucursal':productoInfo.xml_dirEstablecimiento,
                              'empresa_id':productoInfo.xml_empresaElegida,
                              'ruc': productoInfo.xml_ruc,
                              'rucComprador': productoInfo.xml_ruc_comprador,
                              'emailComprador': productoInfo.xml_email_comprador,
                              'clave': productoInfo.xml_claveAcceso,
                              'secuencial':productoInfo.xml_secuencial,
                              'dirMatriz':productoInfo.xml_dirMatriz,
                              'fecha':productoInfo.xml_fecha,
                              'secuencial':productoInfo.xml_secuencial,
                              'fecha' : productoInfo.xml_fecha,
                              // 'fecha':productoInfo,
                              //'xml':productoInfo.xml_FINAL,
                              'iva12':productoInfo.xml_iva12.text,
                              'subtotal12':productoInfo.xml_subtotal_12.text,
                              'subtotal0':productoInfo.xml_subtotal_0.text,
                              'subtotal':productoInfo.xml_precio_final_sin_im,
                              'razonSocialComprador':productoInfo.xml_razonSocial_comprador,
                              'razonSocial':productoInfo.xml_razonSocial,
                              'totalCon':productoInfo.xml_precio_final_con_im,
                              'totalSin' : productoInfo.xml_precionfinalSin,
                              'conceptos': jsonEncode(send),
                              'total':productoInfo.xml_precio_final_con_im_controller.text
                            }));
                    print(p.body.toString());  
                    String nombreTicket = p.body.toString();
                    //guarda el nombre del pdf para poder descargarlo
                    productoInfo.xml_pdf_ticker_nombre = nombreTicket;
                    document = await PDFDocument.fromURL(
                        "http://167.172.203.137/getpdfticket/" + nombreTicket);
                    url_descarga="http://167.172.203.137/getpdfticket/" + nombreTicket;
                    // "http://conorlastowka.com/book/CitationNeededBook-Sample.pdf");
                    this.nombrepdf = nombreTicket;
                    setState(() => _isLoading = false);
                    productoInfo.control_factura = true;
                  }),
                  VerticalDivider(),
                  RaisedButton(
                     shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                    child: Text("Abrir PDF",style: TextStyle(color: Colors.white),)
                    ,color:Colors.green
                    ,onPressed: () async{
                      String urlTemp = "http://167.172.203.137/getpdfticket/" + productoInfo.xml_pdf_ticker_nombre;
                      var tempDir = await getTemporaryDirectory();
                      String fullPath = tempDir.path + "/${productoInfo.xml_pdf_ticker_nombre}";
                      // print('full path ${fullPath}');
                      download2(dio, urlTemp, fullPath);
                      // var file = await cache_manager.DefaultCacheManager().getSingleFile(urlTemp);
                      // OpenFile.open(file.path);
                      OpenFile.open(fullPath);
                    })
            ],
          ),
        ),
      ),
      body: Container(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : PDFViewer(
                  document: document,
                  showPicker: false,
                )),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:http/http.dart' as http;
// import 'package:pdf/widgets.dart' as pdfwidget;
// import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

// //void main() => runApp(MyApp());

// class PdfView extends StatefulWidget {
//   @override
//   _PdfViewState createState() => _PdfViewState();
// }

// class _PdfViewState extends State<PdfView> with AutomaticKeepAliveClientMixin<PdfView> {
//   String assetPDFPath = "";
//   String urlPDFPath = "";
//   final pdfwidget.Document pdf = pdfwidget.Document();

//   @override
//   void initState() {
//     //super.initState();
//     //getSharedPrefs();
//     // getFileFromAsset("assets/mypdf.pdf").then((f) {
//     //   //setState(() {
//     //     assetPDFPath = f.path;
//     //     print(assetPDFPath);
//     //   //});
//     // });

//   }

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   getSharedPrefs();
//   // }

//   // Future<Null> getSharedPrefs() async {
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   setState(() {
//   //     this.controller_razonSocial = new TextEditingController(text: prefs.getString("razonSocial"));
//   //     this.controller_ruc = new TextEditingController(text: prefs.getString("ruc"));
//   //     this.controller_codDoc = new TextEditingController(text:prefs.getString("codDoc"));
//   //     this.controller_estab = new TextEditingController(text: prefs.getString("estab"));
//   //     this.controller_ptoEmi = new TextEditingController(text: prefs.getString("ptoEmi"));
//   //     this.controller_dirMatriz = new TextEditingController(text: prefs.getString("secuencial"));
//   //   });
//   // }
//   // Future<File> getFileFromAsset(String asset) async {
//   //   try {
//   //     var data = await rootBundle.load(asset);
//   //     var bytes = data.buffer.asUint8List();
//   //     var dir = await getApplicationDocumentsDirectory();
//   //     File file = File("${dir.path}/mypdf.pdf");

//   //     File assetFile = await file.writeAsBytes(bytes);
//   //     return assetFile;
//   //   } catch (e) {
//   //     throw Exception("Error opening asset file");
//   //   }
//   // }

//   Future<File> getFileFromUrl(String url) async {
//     try {
//       var data = await http.get(url);
//       var bytes = data.bodyBytes;
//       var dir = await getApplicationDocumentsDirectory();
//       File file = File("${dir.path}/mypdfonline.pdf");

//       File urlFile = await file.writeAsBytes(bytes);
//       return urlFile;
//     } catch (e) {
//       throw Exception("Error opening url file");
//     }
//   }

//   // void tmr() {
//   //   if (assetPDFPath != null) {
//   //     Navigator.push(
//   //         context,
//   //         MaterialPageRoute(
//   //             builder: (context) => PdfViewPage(path: assetPDFPath)));
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     //tmr();
//     getFileFromUrl("http://www.pdf995.com/samples/pdf.pdf").then((f) {
//      setState(() {
//        urlPDFPath = f.path;
//        print(urlPDFPath);
//      });
//    });
//     return //MaterialApp(
//       // debugShowCheckedModeBanner: false,
//       //home:
//       Scaffold(
// //        appBar: AppBar(
// //          title: Text("Flutter PDF Tutorial"),
// //        ),
//         body: Center(
//           child:  Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
// //                RaisedButton(
// //                  color: Colors.amber,
// //                  child: Text("Abrir PDF url"),
// //                  onPressed: () {
// //                    if (urlPDFPath != null) {
// //                      Navigator.push(
// //                          context,
// //                          MaterialPageRoute(
// //                              builder: (context) =>
// //                                  PdfViewPage(path: assetPDFPath)));
// //                    }
// //                  },
// //                ),

//                 RaisedButton(
//                   color: Colors.red,
//                   textColor: Colors.white,
//                   child: Text("GENERAR FACTURA PDF"),
//                   // child: Text("Abrir pdf test"),
//                   onPressed: () {
// //                     pdf.addPage(pdfwidget.Page(
// //                         pageFormat: PdfPageFormat.a4,
// //                         build: (pdfwidget.Context context) {
// //                           return
// //                             pdfwidget.Column(children: [

// //                             pdfwidget.Row(
// //                             children: [
// //                               //pdfwidget.Container(),
// //                               pdfwidget.Container(

// //                                   child: pdfwidget.Column(children: [
// //                                     pdfwidget.Table(columnWidths: const <int, pdfwidget.TableColumnWidth>{
// //                                       0: pdfwidget.FlexColumnWidth(19.0),
// //                                       1: pdfwidget.FlexColumnWidth(50.0),
// //                                     },
// //                                       //border: pdfwidget.TableBorder. all(color: Colors.black45),
// //                                       children: [
// //                                         pdfwidget.TableRow(children: [
// //                                           pdfwidget.Text(' Descripcion'),
// //                                           pdfwidget.Text('\tdsdfefffff'),
// //                                         ]),

// //                                       ],
// //                                     )
// //                                       ,

// //                                     pdfwidget.Text("LOGO",
// //                                         style:
// //                                             pdfwidget.TextStyle(fontSize: 30)),
// //                                     pdfwidget.Container(
// //                                       width: 250,
// //                                       child: pdfwidget.Text("Dir Matriz"),
// //                                     ),
// //                                     pdfwidget.Padding(padding: pdfwidget.EdgeInsets.all(10),child:
// //                                     pdfwidget.Table.fromTextArray(
// //                                         context: context,
// //                                         data: <List<String>>[
// //                                           <String>[
// //                                                 controller_razonSocial.text+
// //                                                 '\n\nFACTURA' +
// //                                                 '\nNo.\t' + '312133243554365234'+
// //                                                 '\nNumero de Autorizacion' +
// //                                                 '\n1234567890876543212345673456' +
// //                                                 '\nFECHA Y HORA DE AUTORIZACION : 12/12/1212 15:!5:5 ' +
// //                                                 '\nAMBIENTE : Pruebas' +
// //                                                 '\n\nEMISION: normal' +
// //                                                 '\nClave ACCESO'
// //                                           ],
// //                                           <String>[
// //                                             '1993                    sadsadasdas   sadsadasdasdasdaaddd '
// //                                           ],
// //                                           //<String>['1994'],
// //                                         ])
// //                                     ),

// //                                   ])),

// //                               pdfwidget.Wrap(children:
// //                                   [pdfwidget.Padding(padding: pdfwidget.EdgeInsets.all(10),child:

// //                                   pdfwidget.Table.fromTextArray(
// //                                       context: context,
// //                                       data: const <List<String>>[
// //                                         <String>[
// //                                           'R.U.C.: ' + '12345643234565'+
// //                                               '\n\nFACTURA' +
// //                                               '\nNo.\t' + '312133243554365234'+
// //                                               '\nNumero de Autorizacion' +
// //                                               '\n1234567890876543212345673456' +
// //                                               '\nFECHA Y HORA DE AUTORIZACION : 12/12/1212 15:!5:5 ' +
// //                                               '\nAMBIENTE : Pruebas' +
// //                                               '\n\nEMISION: normal' +
// //                                               '\nClave ACCESO'
// //                                         ],
// //                                         <String>[
// //                                           '1993               sadsadasdasdasdaaddd '
// //                                         ],
// //                                         //<String>['1994'],
// //                                       ])
// //                                   )]

// //                               ),

// //                             ],
// //                           ),

// //                           pdfwidget.Text('INFORMACION DEL CLIENTE'),

// // //INFORMACION CLIENTE
// //                               pdfwidget.Table.fromTextArray(
// //                                   context: context,
// //                                   data: const <List<String>>[
// //                                     <String>[
// //                                       'R.U.C.: ' +
// //                                           '\nFACTURA' +
// //                                           '\nNo: 13245678' +
// //                                           '\nNumero de Autorizacion' +
// //                                           '\n1234567890876543212345673456'
// //                                     ],
// //                                     //<String>['1993                    sadsadasdas   sadsadasdasdasdaaddd '],
// //                                     //<String>['1994'],
// //                                   ])
// //                               ,
// //                               pdfwidget.Text('\n'),

// //                               //INFO DESCRIPOCION ETC ...
// //                               pdfwidget.Table.fromTextArray(
// //                                   context: context,
// //                                   data: const <List<String>>[
// //                                     <String>[
// //                                       'R.U.C.: ' +
// //                                           '\nFACTURA' +
// //                                           '\nNo: 13245678' +
// //                                           '\nNumero de Autorizacion' +
// //                                           '\n1234567890876543212345673456'
// //                                     ],
// //                                     //<String>['1993                    sadsadasdas   sadsadasdasdasdaaddd '],
// //                                     //<String>['1994'],
// //                                   ])

// //                               ,pdfwidget.Text("INFORMACION ADICIONAL"),

// //                             ]);
// //                           // Center
// //                         })); //

//                     // On Flutter, use the [path_provider](https://pub.dev/packages/path_provider) library:
//                     //final output = await getTemporaryDirectory();
//                     // final output = await getApplicationDocumentsDirectory();
//                     // final file = File("${output.path}/mypdf.pdf");
//                     // //final file = File("example.pdf");
//                     // await file.writeAsBytes(pdf.save());

//                     // if (assetPDFPath != null) {
//                     //   Navigator.push(
//                     //       context,
//                     //       MaterialPageRoute(
//                     //           builder: (context) =>
//                     //               PdfViewPage(path: assetPDFPath)));
//                     // }
//                     if (this.urlPDFPath != null) {
//                       Navigator.push(
//                           context,

//                           MaterialPageRoute(
//                               builder: (context) =>
//                                   PdfViewPage(path: urlPDFPath)));
//                     }
//                   },
//                 )
//               ],
//             )

//         ),
//         // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//         // floatingActionButton: Padding(
//         //   padding: const EdgeInsets.only(bottom: 0.0),
//         //   child: FloatingActionButton(
//         //     // When the user presses the button, show an alert dialog containing the
//         //     // text that the user has entered into the text field.
//         //     backgroundColor: Colors.green,
//         //     onPressed: () async {
//         //       return showDialog(
//         //         context: context,
//         //         builder: (context) {
//         //           return AlertDialog(
//         //             // Retrieve the text the user has entered by using the
//         //             // TextEditingController.
//         //             //content: Text(singleton.MyXmlSingleton().forDebug.text),
//         //             content: SingleChildScrollView(
//         //               child: Text(
//         //                 'sadad',
//         //                 style: TextStyle(fontSize: 8),
//         //               ),
//         //             ),
//         //           );
//         //         },
//         //       );
//         //     },
//         //     tooltip: 'Show me the value!',

//         //     child: Icon(Icons.print),
//         //   ),
//         // ),
//       )
//     ;
//   }

//   @override
//   // TODO: implement wantKeepAlive
//   bool get wantKeepAlive => true;
// }

// class PdfViewPage extends StatefulWidget {
//   final String path;

//   const PdfViewPage({Key key, this.path}) : super(key: key);
//   @override
//   _PdfViewPageState createState() => _PdfViewPageState();
// }

// class _PdfViewPageState extends State<PdfViewPage> {
//   int _totalPages = 0;
//   int _currentPage = 0;
//   bool pdfReady = false;
//   PDFViewController _pdfViewController;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
// //      appBar: AppBar(
// //        title: Text("My Document"),
// //      ),
//       body: Stack(
//         children: <Widget>[
//           PDFView(
//             filePath: widget.path,
//             autoSpacing: true,
//             enableSwipe: true,
//             pageSnap: true,
//             swipeHorizontal: true,
//             nightMode: false,
//             onError: (e) {
//               print(e);
//             },
//             onRender: (_pages) {
//               setState(() {
//                 _totalPages = _pages;
//                 pdfReady = true;
//               });
//             },
//             onViewCreated: (PDFViewController vc) {
//               _pdfViewController = vc;
//             },
//             onPageChanged: (int page, int total) {
//               setState(() {});
//             },
//             onPageError: (page, e) {},
//           ),
//           !pdfReady
//               ? Center(
//                   child: CircularProgressIndicator(),
//                 )
//               : Offstage()
//         ],
//       ),
//       floatingActionButton: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: <Widget>[
//           _currentPage > 0
//               ? FloatingActionButton.extended(
//                   backgroundColor: Colors.red,
//                   label: Text("Go to ${_currentPage - 1}"),
//                   onPressed: () {
//                     _currentPage -= 1;
//                     _pdfViewController.setPage(_currentPage);
//                   },
//                 )
//               : Offstage(),
//           _currentPage + 1 < _totalPages
//               ? FloatingActionButton.extended(
//                   backgroundColor: Colors.green,
//                   label: Text("Go to ${_currentPage + 1}"),
//                   onPressed: () {
//                     _currentPage += 1;
//                     _pdfViewController.setPage(_currentPage);
//                   },
//                 )
//               : Offstage(),
//         ],
//       ),
//     );
//   }
// }
