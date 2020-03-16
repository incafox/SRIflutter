import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_final_sri/provider_productos.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'singleton_formulario_actual.dart' as singleton;
import 'package:card_settings/card_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:file_picker/file_picker.dart';
import 'file_picker_helper.dart' as filepickerhelper;
import 'expansion_list.dart' as expansion;
import 'pdfgenerator.dart' as pdfgenerator;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_collapse/flutter_collapse.dart';
import 'form.dart' as formulario;
import 'tab_factura_archivos.dart';

//vista pdf de factura
import 'pdf_viewer.dart';

//vista pdf de ticket
import 'pdf_viewer_ticket.dart' as ticket;



import 'productos.dart';
import 'package:pdf/pdf.dart' as pdfCreator;


//tabs content
import 'tab_factura_editar.dart' as tabFacturaEditar;
import 'tab_factura_archivos.dart' as tanFacturaArchivos;


class ReenviarPage extends StatefulWidget {
  // final String title;
  // FacturaPage(this.title);
  @override
  _ReenviarPageState createState() => _ReenviarPageState();
}
//with AutomaticKeepAliveClientMixin
class _ReenviarPageState extends State<ReenviarPage> with AutomaticKeepAliveClientMixin<ReenviarPage> {

  //final String title = widget.title;
  // PdfView  pdf_factura = new PdfView();
  //ticket.PdfViewTicket pdf_ticket = new ticket.PdfViewTicket();
  ticket.PdfViewTicket pdf_ticket = new ticket.PdfViewTicket();
  tabFacturaEditar.TabFacturaEditar tabFacturax = new tabFacturaEditar.TabFacturaEditar();
  //FacturaPage({this.title});

  Widget roundedButton(String buttonLabel, Color bgColor, Color textColor) {
    var loginBtn = new Container(
      padding: EdgeInsets.all(5.0),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: bgColor,
        borderRadius: new BorderRadius.all(const Radius.circular(10.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF696969),
            offset: Offset(1.0, 3.0),
            blurRadius: 0.001,
          ),
        ],
      ),
      child: Text(
        buttonLabel,
        style: new TextStyle(
            color: textColor, fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
    return loginBtn;
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Salir?', textAlign: TextAlign.center,),
        content: new Text('Deseas salir realmente?', textAlign: TextAlign.center,),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child:roundedButton("No", Colors.red,
                const Color(0xFFFFFFFF)),
            //FlatButton(color: Colors.green,child: Text('NO'),),
          ),
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(true),
            child: roundedButton(" Yes ", Colors.green,
                const Color(0xFFFFFFFF)),
            //FlatButton(color: Colors.red,child: Text('SI'),),
          ),
        ],
      ),
    ) ??
        false;
  }


  @override
  Widget build(BuildContext context) {
    final productoInfo=Provider.of<ProductosArrayInfo>(context);

    Widget tabProds = TabProductos();
    //this.pdf_factura.
    //pdf_viewer.MyApp().
    // AutomaticKeepAlive()
    super.build(context);
    return WillPopScope(
          // onWillPop: _onBackPressed,
          child: Scaffold(
            
          body: TabFacturaArchivos()
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  
}
/*
class ScreenEditar extends StatefulWidget {
  @override
  _ScreenEditarState createState() => new _ScreenEditarState();
}*/

//class _ScreenEditarState extends State<ScreenEditar> {
class ScreenEditar extends StatelessWidget {
  /*
  const ScreenEditar({
    Key key,
    @required this.color,
    @required this.name,
  }) : super(key: key);
*/
  //final Color color;
  //final String name;
  String title = "Spheria";
  String author = "Cody Leet";
  String url = "http://www.codyleet.com/spheria";
  List<String> infoFactura = [
    'fechaEmision',
    'dirEstablecimiento',
    'obligadoContabilidad',
    'tipoIdentificacionComprador',
    'razonSocialComprador',
    'identificacionComprador',
    'totalSinImpuestos',
    'totalDescuento',
    'codigoImpuesto',
    'codigoPorcentaje',
    ''
  ];

  @override
  Widget build(BuildContext context) {
    return Form(
      //key: _formKey,
      child: CardSettings(
        children: <Widget>[
          CardSettingsHeader(
            labelAlign: TextAlign.center,
            label: 'Datos de factura',
            color: Colors.blueAccent,
          ),
          CardSettingsText(
            labelWidth: 150,
            label: 'Fecha emision',
            initialValue: title,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Title is required.';
            },
            onSaved: (value) => title = value,
          ),
          CardSettingsText(
            labelWidth: 150,
            label: 'Direccion',
            initialValue: 'Editar direccion',
            validator: (value) {
              if (!value.startsWith('http:')) return 'Must be a valid website.';
            },
            onSaved: (value) => url = value,
          ),
          CardSettingsText(
            labelWidth: 150,
            label: 'A contabilidad',
            initialValue: 'Editar estado',
            validator: (value) {
              if (!value.startsWith('http:')) return 'Must be a valid website.';
            },
            onSaved: (value) => url = value,
          ),
          CardSettingsText(
            labelWidth: 150,
            label: 'Tipo Identificacion',
            initialValue: 'Editar tipo identificacion',
            validator: (value) {
              if (!value.startsWith('http:')) return 'Must be a valid website.';
            },
            onSaved: (value) => url = value,
          ),
          CardSettingsText(
            labelWidth: 150,
            label: 'Razon social',
            initialValue: 'Editar razon social',
            validator: (value) {
              if (!value.startsWith('http:')) return 'Must be a valid website.';
            },
            onSaved: (value) => url = value,
          ),
          CardSettingsText(
            labelWidth: 150,
            label: 'Identificacion',
            initialValue: 'Editar identificacion',
            validator: (value) {
              if (!value.startsWith('http:')) return 'Must be a valid website.';
            },
            onSaved: (value) => url = value,
          ),
          CardSettingsText(
            labelWidth: 150,
            label: 'auxiliar',
            initialValue: 'Editar auxiliar',
            validator: (value) {
              if (!value.startsWith('http:')) return 'Must be a valid website.';
            },
            onSaved: (value) => url = value,
          ),


          Padding(
            padding: EdgeInsets.all(20.0),
            child: RaisedButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.red)),
              onPressed: () {

                //mediante funcion de otro .dart con parametros todos los datos de
                //del form, generar el xml, codificar y enviar
              },
              color: Colors.red,
              textColor: Colors.white,
              child: Text("Debug".toUpperCase(),
                  style: TextStyle(fontSize: 17)),
            ),
          ),


        ],
      ),
    );
  }
}

class ScreenPreview extends StatelessWidget {
  const ScreenPreview({
    Key key,
    @required this.color,
    @required this.name,
  }) : super(key: key);

  final Color color;
  final String name;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          color: Colors.grey,
          height: 510,
        ),
        Container(
          color: Colors.red,
          height: 110,
        ),
      ],
    );
  }
}


//para los resultados
class NewScreen extends StatelessWidget {
  const NewScreen({
    Key key,
    //@required this.color,
    //@required this.name,
  }) : super(key: key);

  //final Color color;
  //final String name;
  //String dropdownValue = 'One';
  //String title = "Spheria";
  //String author = "Cody Leet";
  //String url = "http://www.codyleet.com/spheria";

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Form(
        //key: _formKey,
        child: CardSettings(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: RaisedButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.red)),
                onPressed: () {
                  print (singleton.MyXmlSingleton().infoTributaria);
                  //singleton.MyXmlSingleton().ruc = 'tmr';


                },
                color: Colors.red,
                textColor: Colors.white,
                child: Text("Debug".toUpperCase(),
                    style: TextStyle(fontSize: 17)),
              ),
            ),
            CardSettingsHeader(
              color: Colors.blueAccent,
              label: 'Facturas pasadas',
              labelAlign: TextAlign.center,
            ),
            Row(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Text(
                      'Factura 2020/3/1 21:44',
                      style: TextStyle(fontSize: 16),
                    )),
                Padding(
                  padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.blueAccent)),
                    onPressed: () {
                      //mediante funcion de otro .dart con parametros todos los datos de
                      //del form, generar el xml, codificar y enviar
                    },
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    child: Text("pdf".toUpperCase(),
                        style: TextStyle(fontSize: 12)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.blueAccent)),
                    onPressed: () {
                      //mediante funcion de otro .dart con parametros todos los datos de
                      //del form, generar el xml, codificar y enviar
                    },
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    child: Text("ticket".toUpperCase(),
                        style: TextStyle(fontSize: 12)),
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Text(
                      'Factura 2020/3/1 21:44',
                      style: TextStyle(fontSize: 16),
                    )),
                Padding(
                  padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.blueAccent)),
                    onPressed: () {
                      //mediante funcion de otro .dart con parametros todos los datos de
                      //del form, generar el xml, codificar y enviar
                    },
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    child: Text("pdf".toUpperCase(),
                        style: TextStyle(fontSize: 12)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.blueAccent)),
                    onPressed: () {
                      //mediante funcion de otro .dart con parametros todos los datos de
                      //del form, generar el xml, codificar y enviar
                    },
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    child: Text("ticket".toUpperCase(),
                        style: TextStyle(fontSize: 12)),
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Text(
                      'Factura 2020/3/1 21:44',
                      style: TextStyle(fontSize: 16),
                    )),
                Padding(
                  padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.blueAccent)),
                    onPressed: () {
                      //mediante funcion de otro .dart con parametros todos los datos de
                      //del form, generar el xml, codificar y enviar
                    },
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    child: Text("pdf".toUpperCase(),
                        style: TextStyle(fontSize: 12)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.blueAccent)),
                    onPressed: () {
                      //mediante funcion de otro .dart con parametros todos los datos de
                      //del form, generar el xml, codificar y enviar
                    },
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    child: Text("ticket".toUpperCase(),
                        style: TextStyle(fontSize: 12)),
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Text(
                      'Factura 2020/3/1 21:44',
                      style: TextStyle(fontSize: 16),
                    )),
                Padding(
                  padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.blueAccent)),
                    onPressed: () {
                      //mediante funcion de otro .dart con parametros todos los datos de
                      //del form, generar el xml, codificar y enviar
                    },
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    child: Text("pdf".toUpperCase(),
                        style: TextStyle(fontSize: 12)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.blueAccent)),
                    onPressed: () {
                      //mediante funcion de otro .dart con parametros todos los datos de
                      //del form, generar el xml, codificar y enviar
                    },
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    child: Text("ticket".toUpperCase(),
                        style: TextStyle(fontSize: 12)),
                  ),
                )


              ],
            ),

            TextField(readOnly: true,controller: singleton.MyXmlSingleton().forDebug,)
          ],
        ),
      ),
    );
  }
}

class Pdfview extends StatefulWidget {
  @override
  _PdfviewState createState() => _PdfviewState();
}

class _PdfviewState extends State<Pdfview> {
  String path;

  @override
  initState() {
    super.initState();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/teste.pdf');
  }

  Future<File> writeCounter(Uint8List stream) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsBytes(stream);
  }

  Future<Uint8List> fetchPost() async {
    final response = await http.get(
        'https://expoforest.com.br/wp-content/uploads/2017/05/exemplo.pdf');
    final responseJson = response.bodyBytes;

    return responseJson;
  }

  loadPdf() async {
    writeCounter(await fetchPost());
    path = (await _localFile).path;

    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        //if (path != null)
        Container(
          //height: 300.0,
          child: PdfViewer(
            filePath: path,
          ),
        ),
        //else
        Text("Pdf is not Loaded"),
        RaisedButton(
          child: Text("Load pdf"),
          onPressed: loadPdf,
        ),
      ],
    );
  }
}
