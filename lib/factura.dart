import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
//import 'package:dart_mssql/dart_mssql.dart';
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

//vista pdf de factura
import 'pdf_viewer.dart' as ppdf;

//vista pdf de ticket
import 'pdf_viewer_ticket.dart' as ticket;

import 'productos.dart';
import 'package:pdf/pdf.dart' as pdfCreator;

//tabs content
import 'tab_factura_editar.dart' as tabFacturaEditar;
import 'tab_factura_archivos.dart' as tanFacturaArchivos;

// class "Client" for ORM example
class Client {
  int client_id;
  String client_name;
  List<Invoice> invoices;

  Client.fromJson(Map<String, dynamic> json) {
    client_id = json['client_id'];
    client_name = json['client_name'];
  }

  Map<String, dynamic> toJson() {
    return {
      'client_id': client_id,
      'client_name': client_name,
    };
  }
}

// class "Invoice" for ORM example
class Invoice {
  int client_id;
  int inv_number;

  Invoice.fromJson(Map<String, dynamic> json) {
    client_id = json['client_id'];
    inv_number = json['inv_number'];
  }

  Map<String, dynamic> toJson() {
    return {
      'client_id': client_id,
      'inv_number': inv_number,
    };
  }
}

class FacturaPage extends StatefulWidget {
  // final String title;
  // FacturaPage(this.title);
  @override
  _FacturaPageState createState() => _FacturaPageState();
}

//with AutomaticKeepAliveClientMixin
class _FacturaPageState extends State<FacturaPage>
    with AutomaticKeepAliveClientMixin<FacturaPage> {
  //final String title = widget.title;
  ppdf.MyApp pdf_factura = new ppdf.MyApp();
  //ticket.PdfViewTicket pdf_ticket = new ticket.PdfViewTicket();
  ticket.MyApp pdf_ticket = new ticket.MyApp();
  tabFacturaEditar.TabFacturaEditar tabFacturax =
      new tabFacturaEditar.TabFacturaEditar();

  //FacturaPage({this.title});
  // Establish a connection
//  SqlConnection connection = SqlConnection(host:"SERVERNAME", db:"DBNAME", user:"USERNAME", password:"PASSWORD");

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

  AlertDialog mensaje(String msn){
    return AlertDialog(
      content: SingleChildScrollView(
        child: Text(
          msn,
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }


  Future<bool> _onBackPressed() {
    final productoInfo =
        Provider.of<ProductosArrayInfo>(context, listen: false);
    // List<String> r = [];
    // r.clear();
    // productoInfo.productosDB = ["",""];
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(
              'Salir?',
              textAlign: TextAlign.center,
            ),
            content: new Text(
              'Deseas salir realmente?',
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: roundedButton("No", Colors.red, const Color(0xFFFFFFFF)),
                //FlatButton(color: Colors.green,child: Text('NO'),),
              ),
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: roundedButton(
                    " Yes ", Colors.green, const Color(0xFFFFFFFF)),
                //FlatButton(color: Colors.red,child: Text('SI'),),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final productoInfo = Provider.of<ProductosArrayInfo>(context);

    Widget tabProds = TabProductos();
    //this.pdf_factura.
    //pdf_viewer.MyApp().
    // AutomaticKeepAlive()
    super.build(context);
    return WillPopScope(
      onWillPop: (){
        productoInfo.clearProductosDB();
        productoInfo.calcular_precio_final(); // actualiza los precios finales
        
        return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(
              'Salir?',
              textAlign: TextAlign.center,
            ),
            content: new Text(
              'Deseas salir realmente?',
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              new GestureDetector(
                onTap: () { 
                  productoInfo.control_factura = false;
                  productoInfo.control_ticket = false;
                  Navigator.of(context).pop(false);
                  },
                child: roundedButton("No", Colors.red, const Color(0xFFFFFFFF)),
                //FlatButton(color: Colors.green,child: Text('NO'),),
              ),
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: roundedButton(
                    " Yes ", Colors.green, const Color(0xFFFFFFFF)),
                //FlatButton(color: Colors.red,child: Text('SI'),),
              ),
            ],
          ),
        ) ??
        false;
      } ,//_onBackPressed,

      // Color(0xFF73AEF5),
      //                 Color(0xFF61A4F1),
      //                 Color(0xFF478DE0),
      //                 Color(0xFF398AE5),
      child: Scaffold(
          body: DefaultTabController(
            length: 4,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Color(0xFF478DE0) , elevation: 20,
                bottom: TabBar(
                  tabs: [
                    Tab(
                      icon: Icon(Icons.edit),
                      text: 'Editar',
                    ),
                    Tab(
                      icon: Icon(Icons.picture_as_pdf),
                      text: 'Ticket',
                    ),
                    Tab(
                      icon: Icon(Icons.picture_as_pdf),
                      text: 'Factura',
                    ),
                    Tab(
                      icon: Icon(Icons.pageview),
                      text: 'Resultado',
                    ),
                  ],
                ),
                title: Text('Crear Nueva Factura'),
                //backgroundColor: Colors.red,
                centerTitle: true,
                actions: <Widget>[
                  // PopupMenuButton(color: Colors.deepOrangeAccent,
                  //   itemBuilder: (BuildContext context) {
                  //     return choices.skip(2).map((Choice choice) {
                  //       return PopupMenuItem<Choice>(
                  //         value: choice,
                  //         child: Text(choice.title,style: TextStyle(color: Colors.white),),
                  //       );
                  //     }).toList();
                  //   },
                  // )
                ],
              ),
              body: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  //tabFacturaEditar.TabFacturaEditar(),

                  tabFacturax,

                  this.pdf_factura,
                  this.pdf_ticket,

                  tanFacturaArchivos.TabFacturaArchivos()
                  //Icon(Icons.directions_car),
                  //Icon(Icons.directions_transit),
                  //Icon(Icons.directions_bike),
                ],
              ),
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: SpeedDial(
              // both default to 16
              marginRight: 18,
              marginBottom: 10,
              animatedIcon: AnimatedIcons.menu_close,
              animatedIconTheme: IconThemeData(size: 35.0),
              // this is ignored if animatedIcon is non null
              // child: Icon(Icons.add),
              visible: true, //_dialVisible,
              // If true user is forced to close dial manually
              // by tapping main button and overlay is not rendered.
              closeManually: false,
              curve: Curves.slowMiddle,
              overlayColor: Colors.black54,
              overlayOpacity: 0.5,
              onOpen: () => print('OPENING DIAL'),
              onClose: () => print('DIAL CLOSED'),
              tooltip: 'Speed Dial',
              heroTag: 'speed-dial-hero-tag',
              backgroundColor: Colors.yellow,
              foregroundColor: Colors.white,
              elevation: 4.0,
              shape: CircleBorder(),
              children: [
                SpeedDialChild(
                    child: Icon(Icons.send),
                    backgroundColor: Colors.green,
                    label: 'Enviar Correo',
                    labelStyle: TextStyle(fontSize: 16.0),
                    onTap: () async {
                    print("nombre file " + productoInfo.xml_pdf_ticker_nombre);
                    final p = await http.post('http://167.172.203.137/services/mssql/send_email',
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                            },
                            body: jsonEncode(<String, String>{
                              'empresa_id': productoInfo.xml_empresaElegida,
                              'filename': productoInfo.xml_pdf_ticker_nombre,
                              'receptor': "efren_suarez@hotmail.com"//"lubeck05@gmail.com",
                            }));
                    
                    print("[p ptm]" + p.body.toString());

                    }),
                SpeedDialChild(
                  child: Icon(Icons.cloud_upload),
                  backgroundColor: Colors.red,
                  label: 'Enviar SRI',
                  labelStyle: TextStyle(fontSize: 16.0),
                  onTap: () async {
                    // for (var i = 0; i < 10; i++) {
                    //   print('indice > ' + i.toString());
                    //   print (r[i].toString() + "=" +co[i].toString() +"=" + ca[i].toString() +"=" + to[i].toString());
                    // }
                    // // productoInfo.getDescrip();
                    // print ("final");
                    // List<String> tmr = productoInfo.conceptos();
                    // for (var item in tmr) {
                    //   print (item);
                    // }
                    productoInfo.xml_controller_expanded.expanded = false;
                    productoInfo.xml_enabler = true;
                    double sinIm = 0;
                    double conIm = 0;
                    int contador = 0;
                    for (CartitaProducto i in productoInfo.productosDB) {
                      if (i.activo) {
                        contador+=1;
                        sinIm += double.parse(i.finalPrecioSinImpuesto.text);
                        conIm += double.parse(i.totalPrecioConImpuesto.text);
                      }
                            sinIm = double.parse(sinIm.toStringAsFixed(2));
                            conIm = double.parse(conIm.toStringAsFixed(2));
                      productoInfo.xml_precio_final_sin_im = sinIm.toString();
                      productoInfo.xml_precio_final_con_im = conIm.toString();
                      productoInfo.xml_precionfinalSin = sinIm.toString();
                      productoInfo.xml_precionfinalCon = conIm.toString();
                    }
                    String temporalxc = productoInfo.xml_cod_comprador;
                    if (temporalxc.length > 0 && contador >0){
                      productoInfo.control_nombre_producto = true;
                    }
                    if (productoInfo.control_nombre_producto && productoInfo.control_nombre_producto
                     && productoInfo.control_ticket){
                          // String t = await productoInfo.fetchXML(
                          //     http.Client(),
                          //     productoInfo.xml_empresaElegida,   
                          //     productoInfo.xml_FINAL);
                          http.Response t = await productoInfo.sendXML();
                          // String response = await productoInfo.fetchXML(http.Client(), productoInfo.xml_empresaElegida, productoInfo.xml_FINAL);
                          return showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          // Retrieve the text the user has entered by using the
                          // TextEditingController.
                          //content: Text(singleton.MyXmlSingleton().forDebug.text),
                          content: SingleChildScrollView(
                            child: Text(
                              t.body.toString(),
                              style: TextStyle(fontSize: 8),
                            ),
                          ),
                        );
                      },
                    );
                    }
                    //retorna habiso de completacion de proceso
                    else {
                      //si solamente haya nommbre y productos
                      if ( !productoInfo.control_nombre_producto && 
                        productoInfo.control_factura && productoInfo.control_ticket ){
                         return showDialog(
                            context: context,
                            builder: (context) {
                              return this.mensaje("Para enviar al sri, agregar cliente y/o productos");
                          }
                        );
                      }
                        if ( productoInfo.control_nombre_producto && 
                        !productoInfo.control_factura && productoInfo.control_ticket ){
                         return showDialog(
                            context: context,
                            builder: (context) {
                              return this.mensaje("Para enviar al sri, primero generar el ticket pdf");
                          }
                        );
                      }

                      if ( productoInfo.control_nombre_producto && 
                        productoInfo.control_factura && !productoInfo.control_ticket ){
                         return showDialog(
                            context: context,
                            builder: (context) {
                              return this.mensaje("Para enviar al sri, primer generar la factura pdf");
                          }
                        );
                      }else{
                         return showDialog(
                            context: context,
                            builder: (context) {
                              return this.mensaje("completar los procesos: \ndefinicion de datos(cliente, productos)\npdf (ticket y factura)");
                          }
                        );
                      }
                    }
                  },
                ),
                SpeedDialChild(
                  child: Icon(Icons.cloud_upload),
                  backgroundColor: Colors.blue,
                  label: 'Mostrar XML',
                  labelStyle: TextStyle(fontSize: 16.0),
                  onTap: () async {
                    productoInfo.xml_controller_expanded.expanded = false;
                    productoInfo.xml_enabler = true;
                    double sinIm = 0;
                    double conIm = 0;
                    double total0=0;
                    //calcula el total
                    for (CartitaProducto i in productoInfo.productosDB) {
                      if (i.activo ) {
                        sinIm += double.parse(i.finalPrecioSinImpuesto.text);
                        // conIm += double.parse(i.totalPrecioConImpuesto.text);
                      }
                      if (i.activo && i.impuestoPorcentaje.text =='0'){
                        total0 += double.parse(i.finalPrecioSinImpuesto.text);   
                      }
                      // productoInfo.xml_precio_final_sin_im = sinIm.toString();
                      // productoInfo.xml_precio_final_con_im = conIm.toString();
                      // productoInfo.xml_precionfinalSin = sinIm.toString();
                      // productoInfo.xml_precionfinalCon = conIm.toString();
                    }
                    productoInfo.xml_precio_final_sin_im = sinIm.toString();
                    productoInfo.xml_precionfinalSin = sinIm.toString();
                    double temp3 = 0;
                    double total12 =0;
                    //calcula los de 12
                    for (CartitaProducto i in productoInfo.productosDB) {
                      if (i.activo && i.impuestoPorcentaje.text=="12") {
                        temp3 += double.parse(i.finalPrecioSinImpuesto.text);
                        // conIm += double.parse(i.totalPrecioConImpuesto.text);
                      }
                    }
                    total12 = (temp3 * 0.12) + temp3; 
                    double temp4 = 0;
                    double total14 = 0;
                    //calcula los de 14                    
                    for (CartitaProducto i in productoInfo.productosDB) {
                      if (i.activo && i.impuestoPorcentaje.text=="14") {
                        temp4 += double.parse(i.finalPrecioSinImpuesto.text);
                        // conIm += double.parse(i.totalPrecioConImpuesto.text);
                      }
                    }
                    total14 = (temp4*0.14) + temp4;
                    conIm = total0+total12+total14;
                    productoInfo.xml_precio_final_con_im = conIm.toString();
                    productoInfo.xml_precionfinalCon = conIm.toString();
                    print (productoInfo.get_xml_FINAL());
                    return showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          // Retrieve the text the user has entered by using the
                          // TextEditingController.
                          //content: Text(singleton.MyXmlSingleton().forDebug.text),
                          content: SingleChildScrollView(
                            child: Text(
                              productoInfo.get_xml_FINAL(),
                              style: TextStyle(fontSize: 8),
                            ),
                          ),
                        );
                      },
                    );
                    // StackProductos x = productoInfo.stack;  // getDescripciones();
                    // List<String> r = x.globalKey.currentState.getProductos();
                    // for (var item in r) {
                    //   print (item);
                    // }
                    // print('SECOND CHILD');
                    // List<Widget> y = productoInfo.productos;

                    // print('size > ' + y.length.toString());

                    // List <String> r = productoInfo.descripciones;
                    // List <String> co = productoInfo.costosUnitarios;
                    // List <String> ca = productoInfo.cantidades;
                    // List <String> to = productoInfo.totales;

                    // for (var i = 0; i < 10; i++) {
                    //   print('indice > ' + i.toString());
                    //   print (r[i].toString() + "=" +co[i].toString() +"=" + ca[i].toString() +"=" + to[i].toString());
                    // }
                    // // productoInfo.getDescrip();
                    // print ("final");
                    // List<String> tmr = productoInfo.conceptos();
                    // for (var item in tmr) {
                    //   print (item);
                    // }
                    // print('el precio total');
                    // print(productoInfo.getPrecioTotal());
                  },
                )

                // SpeedDialChild(
                //   child: Icon(Icons.keyboard_voice),
                //   backgroundColor: Colors.green,
                //   label: 'Third',
                //   labelStyle: TextStyle(fontSize: 18.0),
                //   onTap: () => print('THIRD CHILD'),
                // ),
              ],
            ),

//         FloatingActionButton(
//           backgroundColor: Colors.green,onPressed: () async{
//           SharedPreferences pref = await SharedPreferences.getInstance();
//           String infoTributaria = """
// <?xml version="1.0" encoding="UTF-8"?>
// <factura id="comprobante" version="1.0.0">
//     <infoTributaria>
//     <ambiente>${pref.getString('ambiente')}</ambiente>
//     <tipoEmision>${pref.getString('tipoEmision')}</tipoEmision>
//     <razonSocial>${pref.getString('razonSocial')}</razonSocial>
//     <ruc>${pref.getString('ruc')}</ruc>
//     <claveAcceso>${pref.getString('claveAcceso')}</claveAcceso>
//     <codDoc>${pref.getString('codDoc')}</codDoc>
//     <estab>${pref.getString('estab')}</estab>
//     <ptoEmi>${pref.getString('ptoEmi')}</ptoEmi>
//     <secuencial>${pref.getString('secuencial')}</secuencial>
//     <dirMatriz>${pref.getString('dirMatriz')}</dirMatriz>
//   </infoTributaria>
//     """;
//           String infoFactura = singleton.MyXmlSingleton().getInfoFactura();

//           final Email email = Email(
//             body: 'Email body',
//             subject: 'Email subject',
//             recipients: ['lubeck05@gmail.com'],
//             cc: ['cc@example.com'],
//             bcc: ['bcc@example.com'],
//             attachmentPath: 'assets/mypdf.pdf',
//             isHTML: false,
//           );
//             return showDialog(
//               context: context,
//               builder: (context) {
//                 return AlertDialog(
//                   // Retrieve the text the user has entered by using the
//                   // TextEditingController.
//                   //content: Text(singleton.MyXmlSingleton().forDebug.text),
//                   content:
//                   SingleChildScrollView(
//                     child:
//                     Text(infoTributaria+infoFactura,style: TextStyle(fontSize: 8),)
//                     ,)
//                   ,
//                 );
//               },
//             );
//           },
//           tooltip: 'Show me the value!',
//           child: Icon(Icons.send),
//         ),
          )),
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
              child:
                  Text("Debug".toUpperCase(), style: TextStyle(fontSize: 17)),
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
                  print(singleton.MyXmlSingleton().infoTributaria);
                  //singleton.MyXmlSingleton().ruc = 'tmr';
                },
                color: Colors.red,
                textColor: Colors.white,
                child:
                    Text("Debug".toUpperCase(), style: TextStyle(fontSize: 17)),
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
            TextField(
              readOnly: true,
              controller: singleton.MyXmlSingleton().forDebug,
            )
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
