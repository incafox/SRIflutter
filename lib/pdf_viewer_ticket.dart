import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfwidget;
import 'package:shared_preferences/shared_preferences.dart';

//void main() => runApp(MyApp());

class PdfViewTicket extends StatefulWidget {
  @override
  _PdfViewTicketState createState() => _PdfViewTicketState();
}

class _PdfViewTicketState extends State<PdfViewTicket> with AutomaticKeepAliveClientMixin<PdfViewTicket>{
  String assetPDFPath = "";
  String urlPDFPath = "";
  final pdfwidget.Document pdf = pdfwidget.Document();

  @override
  void initState() {
    //super.initState();
   // getSharedPrefs();
    
    getFileFromAsset("assets/mypdf.pdf").then((f) {
      //setState(() {
        assetPDFPath = f.path;
        print(assetPDFPath);
      //});
    });

//    getFileFromUrl("http://www.pdf995.com/samples/pdf.pdf").then((f) {
//      setState(() {
//        urlPDFPath = f.path;
//        print(urlPDFPath);
//      });
//    });
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      this.controller_razonSocial =
          new TextEditingController(text: prefs.getString("razonSocial"));
      this.controller_ruc =
          new TextEditingController(text: prefs.getString("ruc"));
      this.controller_codDoc =
          new TextEditingController(text: prefs.getString("codDoc"));
      this.controller_estab =
          new TextEditingController(text: prefs.getString("estab"));
      this.controller_ptoEmi =
          new TextEditingController(text: prefs.getString("ptoEmi"));
      this.controller_dirMatriz =
          new TextEditingController(text: prefs.getString("secuencial"));
    });
  }

  TextEditingController controller_razonSocial = TextEditingController();
  TextEditingController controller_ambiente = TextEditingController();
  TextEditingController controller_ruc = TextEditingController();
  TextEditingController controller_tipoEmision = TextEditingController();
  TextEditingController controller_estab = TextEditingController();
  TextEditingController controller_ptoEmi = TextEditingController();
  TextEditingController controller_claveAcceso = TextEditingController();
  TextEditingController controller_codDoc = TextEditingController();
  TextEditingController controller_dirMatriz = TextEditingController();

  Future<File> getFileFromAsset(String asset) async {
    try {
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/mypdf.pdf");

      File assetFile = await file.writeAsBytes(bytes);
      return assetFile;
    } catch (e) {
      throw Exception("Error opening asset file");
    }
  }

  Future<File> getFileFromUrl(String url) async {
    try {
      var data = await http.get(url);
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/mypdfonline.pdf");

      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }

  void tmr() {
    if (assetPDFPath != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PdfViewPage(path: assetPDFPath)));
    }
  }

  @override
  Widget build(BuildContext context) {
    //tmr();
    return Scaffold(
//        appBar: AppBar(
//          title: Text("Flutter PDF Tutorial"),
//        ),
        body: Center(
          child: Builder(
            builder: (context) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
//                RaisedButton(
//                  color: Colors.amber,
//                  child: Text("Abrir PDF url"),
//                  onPressed: () {
//                    if (urlPDFPath != null) {
//                      Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) =>
//                                  PdfViewPage(path: assetPDFPath)));
//                    }
//                  },
//                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text("GENERAR TICKET PDF"),
                  onPressed: () async {
                    pdf.addPage(pdfwidget.Page(
                        pageFormat: PdfPageFormat.a4,
                        build: (pdfwidget.Context context) {
                          return pdfwidget.Center(
                              child: pdfwidget.Container(
                            width: 250,
                            child: pdfwidget.Column(children: [
                              pdfwidget.Text("RAZON SOCIAL"),
                              pdfwidget.Text(this.controller_razonSocial.text),
                              pdfwidget.Text("RUC:" + this.controller_ruc.text),
                              pdfwidget.Text("Dir matriz :" +
                                  this.controller_dirMatriz.text),
                              pdfwidget.Text("____________________________"),
                              pdfwidget.Text("AUTORIZACION/CLAVE DE ACCESO"),
                              pdfwidget.Text(
                                  "1T324Y5UI2737432848\n928478392847382987"
                                  ,textAlign: pdfwidget.TextAlign.center),
                              pdfwidget.Text("____________________________"),
                              pdfwidget.Text("FACTURA No : 1232456 12345678"),
                              pdfwidget.Text(
                                  "Fecha de emision :" + DateTime.now().toString(),textAlign: pdfwidget.TextAlign.center),
                              pdfwidget.Text("____________________________"),
                              pdfwidget.Text("Razon social/nombre y apellidos"),
                              pdfwidget.Text("CONSUMIDOR FINAL"),
                              pdfwidget.Text("RUC/CI: 999929999999"),
                              pdfwidget.Text("_____________________"),
                              pdfwidget.Text("_____________________"),
                              pdfwidget.Table.fromTextArray(
                                  context: context,
                                  data: const <List<String>>[
                                    <String>[
                                      'Cant.',
                                      'Producto',
                                      'P.Unit',
                                      'Total'
                                    ],
                                    <String>['1', 'filete', '44.0', '44.0'],
                                    <String>[
                                      '1',
                                      'Portafilete',
                                      '22.0',
                                      '22.0'
                                    ],
                                    <String>[
                                      '',
                                      'Subtotal 12%',
                                      'Acrobat 1',
                                      '25.00'
                                    ],
                                    <String>[
                                      '',
                                      'IVA12%',
                                      'Acrobat 1',
                                      '25.00'
                                    ],
                                    <String>[
                                      'VALOR TOTAL',
                                      'PDF 1.0',
                                      'Acrobat 1',
                                      '25.00'
                                    ],
                                  ]),
                              pdfwidget.Table.fromTextArray(
                                  context: context,
                                  data: const <List<String>>[
                                    <String>[
                                      '1993',
                                      'PDF 1.0',
                                      'Acrobat 1',
                                      '25.00'
                                    ],
                                    <String>[
                                      '1993',
                                      'PDF 1.0',
                                      'Acrobat 1',
                                      '25.00'
                                    ],
                                    <String>[
                                      '1993',
                                      'PDF 1.0',
                                      'Acrobat 1',
                                      '25.00'
                                    ],
                                  ])
                            ]),
                          ));
//                                    pdfwidget.Table.fromTextArray(
//                                        context: context,
//                                        data: const <List<String>>[
//                                          <St
//
//
                          // Center
                        })); //

                    // On Flutter, use the [path_provider](https://pub.dev/packages/path_provider) library:
                    //final output = await getTemporaryDirectory();
                    final output = await getApplicationDocumentsDirectory();
                    final file = File("${output.path}/mypdf.pdf");
                    //final file = File("example.pdf");
                    await file.writeAsBytes(pdf.save());

                    if (assetPDFPath != null) {
                      
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PdfViewPage(path: assetPDFPath)));
                    }
                  },
                )
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: FloatingActionButton(
            // When the user presses the button, show an alert dialog containing the
            // text that the user has entered into the text field.
            backgroundColor: Colors.green,
            onPressed: () async {
              return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    // Retrieve the text the user has entered by using the
                    // TextEditingController.
                    //content: Text(singleton.MyXmlSingleton().forDebug.text),
                    content: SingleChildScrollView(
                      child: Text(
                        'sadad',
                        style: TextStyle(fontSize: 8),
                      ),
                    ),
                  );
                },
              );
            },
            tooltip: 'Show me the value!',

            child: Icon(Icons.print),
          ),
        ),
      );//,
    
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class PdfViewPage extends StatefulWidget {
  final String path;

  const PdfViewPage({Key key, this.path}) : super(key: key);
  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  int _totalPages = 0;
  int _currentPage = 0;
  bool pdfReady = false;
  PDFViewController _pdfViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text("My Document"),
//      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            autoSpacing: true,
            enableSwipe: true,
            pageSnap: true,
            swipeHorizontal: true,
            nightMode: false,
            onError: (e) {
              print(e);
            },
            onRender: (_pages) {
              setState(() {
                _totalPages = _pages;
                pdfReady = true;
              });
            },
            onViewCreated: (PDFViewController vc) {
              _pdfViewController = vc;
            },
            onPageChanged: (int page, int total) {
              setState(() {});
            },
            onPageError: (page, e) {},
          ),
          !pdfReady
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Offstage()
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          _currentPage > 0
              ? FloatingActionButton.extended(
                  backgroundColor: Colors.red,
                  label: Text("Go to ${_currentPage - 1}"),
                  onPressed: () {
                    _currentPage -= 1;
                    _pdfViewController.setPage(_currentPage);
                  },
                )
              : Offstage(),
          _currentPage + 1 < _totalPages
              ? FloatingActionButton.extended(
                  backgroundColor: Colors.green,
                  label: Text("Go to ${_currentPage + 1}"),
                  onPressed: () {
                    _currentPage += 1;
                    _pdfViewController.setPage(_currentPage);
                  },
                )
              : Offstage(),
        ],
      ),
    );
  }
}
