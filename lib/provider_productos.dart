import 'dart:ffi';
// import 'dart:html';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'form_descripcion.dart';
import 'package:flutter_final_sri/productosJson.dart';

import 'package:flutter_final_sri/screens/login_screen.dart' as loginScreen;

class StackProductos extends StatefulWidget {
  @override
  final globalKey = GlobalKey<_StackProductosState>();

  @override
  _StackProductosState createState() => _StackProductosState();
}

class _StackProductosState extends State<StackProductos>
    with AutomaticKeepAliveClientMixin<StackProductos> {
  List<Widget> productos;
  // CardProduct t = CardProduct();

  List<String> getProductos() {
    List<String> descrip = [];
    for (var item in productos) {
      if (item is CardProduct) {
        descrip.add(item.globalKey.currentState.descripcion);
      }
    }
    return descrip;
  }

  @override
  void initState() {
    this.productos = [];
    super.initState();
    final productoInfo =
        Provider.of<ProductosArrayInfo>(context, listen: false);
    List<String> temp = productoInfo.descripciones;
    temp.add("");
    productoInfo.descripciones = temp;
  }

  function(value) => setState(() {
        productos[value] = Container(
          color: Colors.cyan,
          height: 0.1,
        );
        // this.productos.removeAt(value);
      });

  @override
  Widget build(BuildContext context) {
    final productoInfo = Provider.of<ProductosArrayInfo>(context);
    return Container(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            SizedBox(
              width: 200,
              child: MaterialButton(
                  textColor: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.add_box),
                      Text('\t    Agrega Concepto')
                    ],
                  ),
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductosJsonSearchPage()));

                    // setState(() {
                    //   this.productos.add(CardProduct(
                    //         func: function,
                    //         indice: this.productos.length,
                    //       ));
                    //   productoInfo.productos = this.productos;
                    //   // List<Widget> todos = productoInfo.productos;
                    // });
                  }),
            ),
            Column(
              children: this.productos.toList(),
            ),
          ],
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class PhotoImpuesto {
  final String descripcion;
  final String porcentaje;
//  Photo({this.albumId, this.id, this.title, this.url, this.thumbnailUrl});
  PhotoImpuesto({
    this.descripcion,
    this.porcentaje,
  });
  factory PhotoImpuesto.fromJson(Map<String, dynamic> json) {
    return PhotoImpuesto(
      descripcion: json['descrip_tim'],
      porcentaje: json['porcen_tim'],
    );
  }
}

Future<List<PhotoImpuesto>> fetchImpuesto(
    http.Client client, String codigo) async {
  // Map map = new Map<String, dynamic>();
  // map["empresa"] = empreCod;
  Map data = {'codigo': codigo};
  //encode Map to JSON
  var body = json.encode(data);
  print('asumiendo post > ' + body.toString());
  final response = await client.post(
      'http://167.172.203.137/services/mssql/getimpuesto',
      headers: {"Content-Type": "application/json"},
      body: body);
  client.close();
//      await client.get('https://jsonplaceholder.typicode.com/photos')
  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsePhotosImpuesto, response.body);
}

List<PhotoImpuesto> temporals = [];

List<PhotoImpuesto> parsePhotosImpuesto(String responseBody) {
  // final productoInfo=Provider.of<ProductosArrayInfo>(context);
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  //return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
  temporals = parsed
      .map<PhotoImpuesto>((json) => PhotoImpuesto.fromJson(json))
      .toList();
  return temporals;
}

class PhotoPrice {
  final String codigo;
  final String precio;
//  Photo({this.albumId, this.id, this.title, this.url, this.thumbnailUrl});
  PhotoPrice({
    this.codigo,
    this.precio,
  });
  factory PhotoPrice.fromJson(Map<String, dynamic> json) {
    return PhotoPrice(
      codigo: json['codpre_arp'],
      precio: json['precio_arp'],
    );
  }
}

Future<List<PhotoPrice>> fetchClientes(
    http.Client client, String codigo) async {
  // Map map = new Map<String, dynamic>();
  // map["empresa"] = empreCod;
  Map data = {'codigo': codigo};
  //encode Map to JSON
  var body = json.encode(data);
  print('asumiendo post > ' + body.toString());
  final response = await client.post(
      'http://167.172.203.137/services/mssql/getprice',
      headers: {"Content-Type": "application/json"},
      body: body);
  client.close();
//      await client.get('https://jsonplaceholder.typicode.com/photos')
  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsePhotos, response.body);
}

List<PhotoPrice> temporalc = [];

List<PhotoPrice> parsePhotos(String responseBody) {
  // final productoInfo=Provider.of<ProductosArrayInfo>(context);
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  //return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
  temporalc =
      parsed.map<PhotoPrice>((json) => PhotoPrice.fromJson(json)).toList();
  return temporalc;
}

// class CartitaProducto extends StatefulWidget{
//   final String nombre;
//   final String codigo;
//   CartitaProducto({this.nombre,this.codigo});
//   @override
//   _CartitaProductoState createState() => _CartitaProductoState();
// }
class CartitaProducto extends StatelessWidget {
  //State<CartitaProducto> {

  final String nombre;
  final String codigo;

  CartitaProducto({this.nombre, this.codigo});
  bool activo = true;
  bool tienePrecio = false;
  double precio = 0;
  int cantidad = 1;
  String xmlConcepto = "";

  bool primeraVez=false;
  TextEditingController input = TextEditingController(text: "1");
  TextEditingController finalPrecio = TextEditingController(text: "");
  TextEditingController actualPrecio = TextEditingController(text: "");
  ExpandableController control = ExpandableController();
  TextEditingController impuestoDescripcion = TextEditingController(text: "");
  TextEditingController impuestoPorcentaje = TextEditingController(text: "");
  TextEditingController totalPrecioConImpuesto =
      TextEditingController(text: "");
  TextEditingController cantidadImpuesto = TextEditingController(text: "");

  void _getALlPosts(String codigo) async {
    List<PhotoPrice> t = await fetchClientes(http.Client(), codigo);
    List<PhotoImpuesto> r = await fetchImpuesto(http.Client(), codigo);

    this.actualPrecio.text = t[0].precio;
    this.finalPrecio.text = t[0].precio;
    this.impuestoDescripcion.text = r[0].descripcion;
    this.impuestoPorcentaje.text = r[0].porcentaje;
    // this.impuestoCantidad
    this.tienePrecio = true;
    if (this.impuestoPorcentaje.text != "0") {
      double temp = double.parse(this.finalPrecio.text) *
          (double.parse(this.impuestoPorcentaje.text) / 100);
      double resto = temp;
      temp = double.parse(this.actualPrecio.text) + temp;
      this.cantidadImpuesto.text = resto.toString();
      this.totalPrecioConImpuesto.text = temp.toString();
    } else {
      this.cantidadImpuesto.text = "0";
      this.totalPrecioConImpuesto.text = this.finalPrecio.text;
    }
    

    String val = "1";
    this.cantidad = int.parse(val);
    // productoInfo.xml_controller_expanded.expanded = true;
    // productoInfo.xml_enabler = false;
    double tx;
    tx = double.parse(val) * double.parse(this.actualPrecio.text);
    tx = double.parse(tx.toStringAsFixed(2));
    this.finalPrecio.text = tx.toString();
    if (this.impuestoPorcentaje.text != "0") {
      double temp = double.parse(this.finalPrecio.text) *
          (double.parse(this.impuestoPorcentaje.text) /
              100);
      temp = double.parse(temp.toStringAsFixed(2));

      double resto = temp;
      temp += double.parse(this.finalPrecio.text);
      temp = double.parse(temp.toStringAsFixed(2));
      resto = double.parse(resto.toStringAsFixed(2));

      this.cantidadImpuesto.text = resto.toString();
      this.totalPrecioConImpuesto.text = temp.toString();
    } else {
      this.cantidadImpuesto.text = "0";
      this.totalPrecioConImpuesto.text =
          this.finalPrecio.text;
    }



    // return t;
  }

  @override
  Widget build(BuildContext context) {
    final productoInfo = Provider.of<ProductosArrayInfo>(context);
    // TODO: implement build
    //pide info al server si la cantidad es 1
    if (!this.primeraVez) {
        this._getALlPosts(this.codigo);
        this.primeraVez = true;
    }
    this.finalPrecio.text = this.actualPrecio.text;
    this.totalPrecioConImpuesto.text = this.actualPrecio.text;
    // double t;
    // t = double.parse(this.actualPrecio.text);
    // this.finalPrecio.text = t.toString();
    productoInfo.xml_enabler = false;

    // if (this.cantidad == 1) {
    //     //this._getALlPosts(this.codigo);
    // String val = "1";
    // this.cantidad = int.parse(val);
    // productoInfo.xml_controller_expanded.expanded = true;
    // productoInfo.xml_enabler = false;
    // double t;
    // t = double.parse(val) *
    //     double.parse(this.actualPrecio.text);
    // t = double.parse(t.toStringAsFixed(2));
    // this.finalPrecio.text = t.toString();
    // if (this.impuestoPorcentaje.text != "0") {
    //   double temp = double.parse(this.finalPrecio.text) *
    //       (double.parse(this.impuestoPorcentaje.text) /
    //           100);
    //   temp = double.parse(temp.toStringAsFixed(2));

    //   double resto = temp;
    //   temp += double.parse(this.finalPrecio.text);
    //   temp = double.parse(temp.toStringAsFixed(2));
    //   resto = double.parse(resto.toStringAsFixed(2));

    //   this.cantidadImpuesto.text = resto.toString();
    //   this.totalPrecioConImpuesto.text = temp.toString();
    // } else {
    //   this.cantidadImpuesto.text = "0";
    //   this.totalPrecioConImpuesto.text =
    //       this.finalPrecio.text;
    // }

    // }
  
    
    this.xmlConcepto = """
                          <detalle>
                          <codigoPrincipal>${this.codigo}</codigoPrincipal>
                          <descripcion>${this.nombre}</descripcion>
                          <cantidad>1</cantidad>
                          <precioUnitario>${this.actualPrecio.text}</precioUnitario>
                          <descuento>0</descuento>
                          <precioTotalSinImpuesto>${this.finalPrecio.text}</precioTotalSinImpuesto>
                          <impuestos>
                            <impuesto>
                              <codigo>2</codigo>
                              <codigoPorcentaje>2</codigoPorcentaje>
                              <tarifa>${this.impuestoPorcentaje.text}</tarifa>
                              <baseImponible>${this.finalPrecio.text}</baseImponible>
                              <valor>${this.cantidadImpuesto.text}</valor>
                            </impuesto>
                          </impuestos>
                        </detalle>
                          """;

    return ExpandablePanel(
      controller: control,
      tapBodyToCollapse: true, hasIcon: false,
      // tapHeaderToExpand: true,
      // header: Text("tuvieja"),
      //  collapsed: Text("tuvieja") ,
      collapsed: Container(
        // height: 70,
        // width: double.infinity,
        // color: Colors.white,
        child: Card(
            child: Column(
          children: <Widget>[
            Divider(),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 60,
                    height: 30,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(29.0),
                            side: BorderSide(color: Colors.red)),
                        color: Colors.red,
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          control.expanded = true;
                          this.activo = false;
                          // print(this.visib);
                        }),
                  ),
                ),
                VerticalDivider(),
                SizedBox(
                  child: Column(
                    children: <Widget>[
                      Text(this.nombre),
                      Text(this.codigo),
                      Divider(),
                    ],
                  ),
                ),
              ],
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Text("cantidad : "),
                    Container(
                      width: 50,
                      child: TextFormField(
                        onChanged: (val) {
                          this.cantidad = int.parse(val);
                          productoInfo.xml_controller_expanded.expanded = true;
                          productoInfo.xml_enabler = false;
                          double t;
                          t = double.parse(val) *
                              double.parse(this.actualPrecio.text);
                          t = double.parse(t.toStringAsFixed(2));
                          this.finalPrecio.text = t.toString();
                          if (this.impuestoPorcentaje.text != "0") {
                            double temp = double.parse(this.finalPrecio.text) *
                                (double.parse(this.impuestoPorcentaje.text) /
                                    100);
                            temp = double.parse(temp.toStringAsFixed(2));

                            double resto = temp;
                            temp += double.parse(this.finalPrecio.text);
                            temp = double.parse(temp.toStringAsFixed(2));
                            resto = double.parse(resto.toStringAsFixed(2));

                            this.cantidadImpuesto.text = resto.toString();
                            this.totalPrecioConImpuesto.text = temp.toString();
                          } else {
                            this.cantidadImpuesto.text = "0";
                            this.totalPrecioConImpuesto.text =
                                this.finalPrecio.text;
                          }
                          this.xmlConcepto = """
                          <detalle>
                          <codigoPrincipal>${this.codigo}</codigoPrincipal>
                          <descripcion>${this.nombre}</descripcion>
                          <cantidad>${val.toString()}</cantidad>
                          <precioUnitario>${this.actualPrecio.text}</precioUnitario>
                          <descuento>0.0</descuento>
                          <precioTotalSinImpuesto>${this.finalPrecio.text}</precioTotalSinImpuesto>
                          <impuestos>
                            <impuesto>
                              <codigo>2</codigo>
                              <codigoPorcentaje>2</codigoPorcentaje>
                              <tarifa>${this.impuestoPorcentaje.text}</tarifa>
                              <baseImponible>${this.finalPrecio.text}</baseImponible>
                              <valor>${this.cantidadImpuesto.text}</valor>
                            </impuesto>
                          </impuestos>
                        </detalle>
                          """;
                          double sinIm = 0;
                          double conIm = 0;
                          for (CartitaProducto i in productoInfo.productosDB) {
                            if (i.activo) {
                              // print(i.finalPrecio.text);
                              // print(i.totalPrecioConImpuesto.text);
                              sinIm += double.parse(i.finalPrecio.text);
                              conIm +=
                                  double.parse(i.totalPrecioConImpuesto.text);
                            }
                            //  print( "sin impuesto  " +finalPrice.text);
                            //  print( "con impuesto  " +finalPriceConIM.text);
                            // this.finalPrice.text = sinIm.toString();
                            // this.finalPriceConIM.text = conIm.toString();
                            sinIm = double.parse(sinIm.toStringAsFixed(2));
                            conIm = double.parse(conIm.toStringAsFixed(2));

                            productoInfo.xml_precionfinalSin = sinIm.toString();
                            productoInfo.xml_precionfinalCon = conIm.toString();
                          }
                        },
                        controller: this.input,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        // decoration: InputDecoration(
                        //     labelText:"whatever you want",
                        //     hintText: "whatever you want",
                        //     icon: Icon(Icons.phone_iphone)
                        // )
                      ),
                    ),
                    // Container(
                    //   width: 50,
                    //   child: TextField(
                    //     onChanged: (val) {
                    //     },
                    //     maxLines: 1,
                    //     controller: this.input,
                    //     keyboardType: TextInputType.number,
                    //     decoration: InputDecoration(
                    //         // border: InputBorder.,
                    //         hintText: 'Cantidad'),
                    //   ),
                    // ),
                    // Divider(),
                    Text("precio : "),
                    Container(
                      width: 50,
                      child: TextField(
                        readOnly: true,
                        maxLines: 1,
                        controller: this.actualPrecio,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            // border: InputBorder.,
                            ),
                      ),
                    ),
                    Text("total : "),
                    Container(
                      width: 50,
                      child: TextField(
                        readOnly: true,
                        maxLines: 1,
                        controller: this.finalPrecio,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            // border: InputBorder.,
                            hintText: 'Cantidad'),
                      ),
                    )
                  ],
                ),
              ),
            ),

            // Text(this.impuestoDescripcion.text),
            Wrap(
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Text("tipo de impuesto"),
                Container(
                  width: 100,
                  child: TextField(
                    textAlign: TextAlign.center,
                    readOnly: true,
                    maxLines: 1,
                    controller: this.impuestoDescripcion,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(),
                  ),
                ),
                // Container(
                //   width: 90,
                //   child: TextField(
                //     readOnly: true,
                //     maxLines: 1,
                //     controller: this.totalPrecioConImpuesto,
                //     keyboardType: TextInputType.number,
                //     decoration: InputDecoration(
                //         ),
                //   ),
                // )
              ],
            ),
            // Text(this.totalPrecioConImpuesto.text)
          ],
        )),
      ),
    );
  }
}

class CartaPrecioFinal extends StatelessWidget {
  TextEditingController sinImpuestos = TextEditingController(text: "");
  TextEditingController conImpuestos = TextEditingController(text: "");

  void updatePricing(List<CartitaProducto> tmr) {
    double sinIm;
    double conIm;
    for (CartitaProducto item in tmr) {
      if (item.activo) {
        sinIm += double.parse(item.finalPrecio.text);
        conIm += double.parse(item.totalPrecioConImpuesto.text);
      }
    }
    this.sinImpuestos.text = sinIm.toString();
    this.conImpuestos.text = conIm.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text("total sin impuestos"),
          Text(this.sinImpuestos.text),
          Text("total con impuestos"),
          Text(this.conImpuestos.text),
        ],
      ),
    );
  }
}

// class StackCartitaProductos extends StatelessWidget{
//   List<CartitaProducto> productos = [];

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return null;
//   }

// }

class ClienteElegido extends StatelessWidget {
  String nombre;
  String codigo;
  String ruc;
  String email;
  ClienteElegido({this.nombre, this.codigo, this.ruc, this.email});

  void updateData(String nom, String cod, String ruce, String ema) {
    this.nombre = nom;
    this.codigo = cod;
    this.ruc = ruce;
    this.email = ema;
    // this.telefono = ema;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            "" + this.nombre,
            style: TextStyle(fontSize: 16),
          ),
          Align(alignment: Alignment.centerLeft, child: Text("Codigo Cliente : " + this.codigo)),
          Align(alignment: Alignment.centerLeft , child: Text("R.U.C.  : " + this.ruc)),
          Align(alignment: Alignment.centerLeft ,child: Text("Telefono : " + this.email)),
          Align(alignment: Alignment.centerLeft ,child: Text("Email    : " + this.email)),
        ],
      ),
    );
  }
}

//para hacer fecth sincrono del secuencial
Future<String> fetchSecuencial(http.Client client) async {
  final response =
      await client.get('http://167.172.203.137/services/mssql/get_secuencial');
  client.close();
//      await client.get('https://jsonplaceholder.typicode.com/photos');

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseSecuencial, response.body);
}

// A function that converts a response body into a List<Photo>.
String parseSecuencial(String responseBody) {
  // final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return responseBody.toString();
  // return parsed.map<Secuencial>((json) => Secuencial.fromJson(json)).toList();
}

class Secuencial {
  final String secuencial;

  Secuencial({this.secuencial}); //this.cod_corregir, this.nombre_principal,

  factory Secuencial.fromJson(Map<String, dynamic> json) {
    return Secuencial(
      secuencial: json['secuencial'],
    );
  }
}

class ProductosArrayInfo extends ChangeNotifier {
  // List<String> _lista = ['ola'];
  String _lista = 'lol';

  String ambiente;
  String tipoEmision;
  String razonSocial;
  String ruc;
  String claveAcceso;
  String codDoc;
  String estab;
  String ptoEmi;
  String secuencial;
  String dirMatriz;

  //cliente
  String _cliente_razonSocial = '';
  String _cliente_direccion = '';
  String _cliente_email = '';
  String _cliente_contabilidad = '';
  String _cliente_tipoIdentificacion = '';
  String _cliente_identificacion = '';

  get cliente_razonSocial {
    return this._cliente_razonSocial;
  }

  get cliente_direccion {
    return this._cliente_direccion;
  }

  get cliente_email {
    return this._cliente_email;
  }

  get cliente_contabilidad {
    return this._cliente_contabilidad;
  }

  get cliente_tipoIdentificacion {
    return this._cliente_tipoIdentificacion;
  }

  get cliente_identificacion {
    return this._cliente_identificacion;
  }

  set cliente_razonSocial(String k) {
    this._cliente_razonSocial = k;
    notifyListeners();
  }

  set cliente_direccion(String k) {
    this._cliente_direccion = k;
    notifyListeners();
  }

  set cliente_email(String k) {
    this._cliente_email = k;
    notifyListeners();
  }

  set cliente_contabilidad(String k) {
    this._cliente_contabilidad = k;
    notifyListeners();
  }

  set cliente_tipoIdentificacion(String k) {
    this._cliente_tipoIdentificacion = k;
    notifyListeners();
  }

  set cliente_identificacion(String k) {
    this._cliente_identificacion = k;
    notifyListeners();
  }

  //para productos
  List<Widget> _productos = [];

  // List<Widget> productos;
  get productos {
    return this._productos;
  }

  set productos(List<Widget> cn) {
    this._productos = cn;
  }

  //PARA PRODUCTOS JSON
  List<Photo> _productosJson = [];
  get productosJson {
    return this._productosJson;
  }

  set productosJson(List<Photo> cn) {
    this._productosJson = cn;
  }

  StackProductos _stack = new StackProductos();
  get stack {
    return this._stack;
  }

  set stack(StackProductos cn) {
    this._stack = cn;
  }

  List<String> getDescrip() {
    List<Widget> y = this.productos;
    print('size > ' + y.length.toString());
    List<String> descrip = [];
    int count = 0;
    for (var item in y) {
      if (item is CardProduct) {
        count++;
        // int u = (item.globalKey.currentState.indice);
        // print (u);
        // descrip.add(item.globalKey.currentState.descripcion);
      }
    }
    print('productos > ' + count.toString());
    return descrip;
  }

  //PARA EL INVENTARIO
  List<String> _descripciones = List<String>.generate(50, (i) => "None");
  get descripciones {
    return this._descripciones;
  }

  set descripciones(List<String> cn) {
    this._descripciones = cn;
  }

  List<String> _costosUnitarios = List<String>.generate(50, (i) => "None");
  get costosUnitarios {
    return this._costosUnitarios;
  }

  set costosUnitarios(List<String> cn) {
    this._costosUnitarios = cn;
  }

  List<String> _cantidades = List<String>.generate(50, (i) => "None");
  get cantidades {
    return this._cantidades;
  }

  set cantidades(List<String> cn) {
    this._cantidades = cn;
  }

  List<String> _totales = List<String>.generate(50, (i) => "None");
  get totales {
    return this._totales;
  }

  set totales(List<String> cn) {
    this._totales = cn;
  }

  List<String> _impuestos = List<String>.generate(50, (i) => "None");
  get impuestos {
    return this._impuestos;
  }

  set impuestos(List<String> cn) {
    this._impuestos = cn;
  }

//DATOS PRINCIPALES DE INGRESO
  List<loginScreen.Empresas> _empresas =
      []; //List<S>.generate(50, (i) => "None");
  get empresas {
    return this._empresas;
  }

  set empresas(List<loginScreen.Empresas> cn) {
    this._empresas = cn;
  }

  List<String> getNombresEmpresas() {
    List<String> temp = [];
    for (loginScreen.Empresas item in _empresas) {
      temp.add(item.nombre);
    }
    return temp;
  }

  loginScreen.Empresas getEmpresaElegida(String codigo) {
    int temp = _empresas.indexWhere((empre) {
      if (empre.codigo == codigo) {
        return true;
      } else {
        return false;
      }
    });
    return _empresas[temp];
  }

  List<String> getCodigosEmpresas() {
    List<String> temp = [];
    for (loginScreen.Empresas item in _empresas) {
      temp.add(item.codigo);
    }
    return temp;
  }

//dato  final elegido primer list picker de login
  String _empresa = "";
  get empresa {
    return this._empresa;
  }

  set empresa(String cn) {
    this._empresa = cn;
  }

//para agencias
  List<loginScreen.Agencias> _agencias =
      []; //List<S>.generate(50, (i) => "None");
  get agencias {
    return this._agencias;
  }

  set agencias(List<loginScreen.Agencias> cn) {
    this._agencias = cn;
  }

  List<String> getNombresAgencias() {
    List<String> temp = [];
    for (loginScreen.Agencias item in _agencias) {
      temp.add(item.nombre);
    }
    return temp;
  }

  loginScreen.Agencias getAgenciaElegida(String codigo) {
    int temp = _agencias.indexWhere((empre) {
      if (empre.codigo == codigo) {
        return true;
      } else {
        return false;
      }
    });
    return _agencias[temp];
  }

  List<String> getCodigosAgencias() {
    List<String> temp = [];
    for (loginScreen.Agencias item in _agencias) {
      temp.add(item.codigo);
    }
    return temp;
  }

  double _precioFinalTotal = 0.0; //as double;
  get precioFinalTotal {
    return this._precioFinalTotal;
  }

  set precioFinalTotal(double cn) {
    this._precioFinalTotal = cn;
  }

  double getPrecioTotal() {
    // List<String> temp = [];
    double precioTotal = 0; //as double;
    for (int i = 0; i < 20; i++) {
      // print (i);
      if (!this.totales[i].contains("None")) {
        String te = this.totales[i];
        String te2 = this.impuestos[i];
        // precioTotal+=int.parse( (te.replaceAll("$/" , ''))  );
        precioTotal += double.parse(te);
        precioTotal += double.parse(te2);

        // temp.add(this.descripciones[i] + "/" + this.costosUnitarios[i] + "/" + this.cantidades[i]+ "/" +this.totales[i] );
      }
    }
    // print ('precio total > ' + precioTotal.toString());
    this.precioFinalTotal = precioTotal;
    return precioTotal;
  }
  // set precioTotal (int cn) {this._precioTotal = cn;}

  List<String> conceptos() {
    // print ('da');
    List<String> temp = [];
    double precioTotal = 0;
    for (int i = 0; i < 20; i++) {
      // print (i);

      if (!this.totales[i].contains("None")) {
        String te = this.totales[i];
        // precioTotal+=int.parse( (te.replaceAll("$/" , ''))  );
        precioTotal += double.parse(te);
        temp.add(this.descripciones[i] +
            "/" +
            this.costosUnitarios[i] +
            "/" +
            this.cantidades[i] +
            "/" +
            this.totales[i] +
            "/" +
            this.impuestos[i]);
      }
    }
    print('precio total > ' + precioTotal.toString());
    return temp;
  }

  //   List<String> getDescripciones(){
  //     return this._stack.globalKey.currentState.getProductos();
  // }

  // CardProduct producto = CardProduct();
  // List<CardProduct> productos = [];
  // void addProducto(){
  //   int index = this.productos.length-1;
  //   this.productos.add(new CardProduct(index));
  // }

  // void modifyProduct(int index, String descripcion){
  //   this.productos[index].setDescripcion(descripcion);
  // }

  void getSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.ambiente = prefs.getString("ambiente");
    this.tipoEmision = prefs.getString("razonSocial");
    this.razonSocial = prefs.getString("tipoEmision");
    this.ruc = prefs.getString("ruc");
    this.codDoc = prefs.getString("codDoc");
    this.estab = prefs.getString("estab");
    this.ptoEmi = prefs.getString("ptoEmi");
    this.secuencial = prefs.getString("secuencial");
    this.dirMatriz = prefs.getString("dirMatriz");
  }

  void setExternal(String l) {
    this._lista = l;
  }

  get lista {
    return this._lista;
  }

  set lista(String k) {
    this._lista = k;
    notifyListeners();
  }

  //para el archivo de firmado
  String _p12path = '';
  String _p12clave = '';

  get p12path {
    return this._p12path;
  }

  set p12path(String cn) {
    this._p12path = cn;
  }

  get p12clave {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // this._p12clave = prefs.getString("p12clave");
    return this._p12clave;
  }

  set p12clave(String cn) {
    this._p12clave = cn;
  }

  //sesion final para xml

  String _xml_agenciaElegida = "";
  get xml_agenciaElegida {
    return this._xml_agenciaElegida;
  }

  set xml_agenciaElegida(String cn) {
    this._xml_agenciaElegida = cn;
  }

  String _xml_empresaElegia = "";
  get xml_empresaElegida {
    return this._xml_empresaElegia;
  }

  set xml_empresaElegida(String cn) {
    this._xml_empresaElegia = cn;
  }

  String _xml_ambiente = "";
  get xml_ambiente {
    return this._xml_ambiente;
  }

  set xml_ambiente(String cn) {
    this._xml_ambiente = cn;
  }

  String _xml_tipoEmision = "";
  get xml_tipoEmision {
    return this._xml_tipoEmision;
  }

  set xml_tipoEmision(String cn) {
    this._xml_tipoEmision = cn;
  }

  String _xml_razonSocial = "";
  get xml_razonSocial {
    return this._xml_razonSocial;
  }

  set xml_razonSocial(String cn) {
    this._xml_razonSocial = cn;
  }

  String _xml_ruc = "";
  get xml_ruc {
    return this._xml_ruc;
  }

  set xml_ruc(String cn) {
    this._xml_ruc = cn;
  }

  String _xml_ruc_comprador = "";
  get xml_ruc_comprador {
    return this._xml_ruc_comprador;
  }

  set xml_ruc_comprador(String cn) {
    this._xml_ruc_comprador = cn;
  }

  String _xml_claveAcceso = "";
  get xml_claveAcceso {
    return this._xml_claveAcceso;
  }

  set xml_claveAcceso(String cn) {
    this._xml_claveAcceso = cn;
  }

  String _xml_codDoc = "001";
  get xml_codDoc {
    return this._xml_codDoc;
  }

  set xml_codDoc(String cn) {
    this._xml_codDoc = cn;
  }

  String _xml_estab = "";
  get xml_estab {
    return this._xml_estab;
  }

  set xml_estab(String cn) {
    this._xml_estab = cn;
  }

  String _xml_ptoEmi = "";
  get xml_ptoEmi {
    return this._xml_ptoEmi;
  }

  set xml_ptoEmi(String cn) {
    this._xml_ptoEmi = cn;
  }

  String _xml_secuencial = "";
  get xml_secuencial {
    return this._xml_secuencial;
  }

  set xml_secuencial(String cn) {
    this._xml_secuencial = cn;
  }

  String _xml_dirMatriz = "";
  get xml_dirMatriz {
    return this._xml_dirMatriz;
  }

  set xml_dirMatriz(String cn) {
    this._xml_dirMatriz = cn;
  }

  String _xml_fecha = "";
  get xml_fecha {
    return this._xml_fecha;
  }

  set xml_fecha(String cn) {
    this._xml_fecha = cn;
  }

  //xml_cod_comprador
  
  String _xml_cod_comprador = "";
  get xml_cod_comprador {
    return this._xml_cod_comprador;
  }

  set xml_cod_comprador(String cn) {
    this._xml_cod_comprador = cn;
  }

  String _xml_cod_vendedor = "";
  get xml_cod_vendedor {
    return this._xml_cod_vendedor;
  }

  set xml_cod_vendedor(String cn) {
    this._xml_cod_vendedor = cn;
  }

  String _xml_precio_final_sin_im = "";
  get xml_precio_final_sin_im {
    return this._xml_precio_final_sin_im;
  }

  set xml_precio_final_sin_im(String cn) {
    this._xml_precio_final_sin_im = cn;
  }

  String _xml_precio_final_con_im = "";
  get xml_precio_final_con_im {
    return this._xml_precio_final_con_im;
  }

  set xml_precio_final_con_im(String cn) {
    this._xml_precio_final_con_im = cn;
  }

  String _xml_dirEstablecimiento = "";
  get xml_dirEstablecimiento {
    return this._xml_dirEstablecimiento;
  }

  set xml_dirEstablecimiento(String cn) {
    this._xml_dirEstablecimiento = cn;
  }

  //sincrono

  //no usar
  Future<String> get_secuencial() async {
    String res = "";
    final p =
        await http.post('http://167.172.203.137/services/mssql/get_secuencial',
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'empresa_id': this.xml_empresaElegida,
              'agenci_id': this.xml_agenciaElegida,
              'codDoc': this.xml_codDoc,
            }));

    print("enviando para secuencial >>>> ");
    print("empresa > " + this.xml_empresaElegida);
    print("agencia > " + this.xml_agenciaElegida);
    print("codDoc > " + this.xml_codDoc);
    return p.body
        .toString()
        .substring(p.body.toString().length - 9, p.body.toString().length);
  }

  void update_secuencial() async {
    String res = "";
    final p = await http.post(
        'http://167.172.203.137/services/mssql/update_secuencial',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'empresa_id': this.xml_empresaElegida,
          'agenci_id': this.xml_agenciaElegida,
          'codDoc': this.xml_codDoc,
        }));

    // print("enviando para secuencial >>>> ");
    // print("empresa > " + this.xml_empresaElegida);
    // print("agencia > "+ this.xml_agenciaElegida);
    // print("codDoc > "+ this.xml_codDoc);
    // return p.body.toString().substring(p.body.toString().length-9,p.body.toString().length);
  }

  Future<String> generaTodo() async {
    final p = await http
        .post('http://167.172.203.137/services/mssql/get_secuencial',
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'empresa_id': this.xml_empresaElegida,
              'agenci_id': this.xml_agenciaElegida,
              'codDoc': this.xml_codDoc,
            }))
        .then((p) {
      String secuencial_recuperado = p.body
          .toString()
          .substring(p.body.toString().length - 9, p.body.toString().length);

        this.xml_ambiente = "1";
    this.xml_tipoEmision = "1";
    DateTime now = DateTime.now();
    this.xml_fecha = DateFormat('dd/MM/yyyy').format(now);
    this._xml_dirEstablecimiento = this._xml_dirMatriz;
    this.xml_secuencial = secuencial_recuperado;
    //procede a generar la clave de acceso
    String cadena48 = "";
    cadena48 += this.xml_fecha;
    cadena48 = cadena48.replaceAll("/", "");
    cadena48 += this.xml_codDoc;
    cadena48 += this.xml_ruc;
    cadena48 += this.xml_ambiente;
    cadena48 += "001001";
    cadena48 += xml_secuencial;
    cadena48 += "12345678"; // depende de uno
    cadena48 += this.xml_tipoEmision;
    cadena48 += digitoVerificador(cadena48);
    print("rclave de acceso >> " + cadena48);
    this.xml_claveAcceso = cadena48;
      return this.get_xml_FINAL();
    });
    // String secuencial_recuperado = p.body
    //     .toString()
    //     .substring(p.body.toString().length - 9, p.body.toString().length);
  }

  String digitoVerificador(cadena48) {
    int res = 0;
    List<int> cadena = [];
    // List<int> numeros = [];
    int acum = 0;
    String temporal = cadena48.toString();
    print(temporal);
    print(temporal.length);
    int multiplicador = 2;
    for (int i = temporal.length; i == 0; i--) {
      cadena.add(int.parse(temporal[i]) * multiplicador);
      print("multiplicador >> " + multiplicador.toString());
      print("numero  >> " + temporal[i]);
      print("resultado  >> " +
          (int.parse(temporal[i]) * multiplicador).toString());
      acum += int.parse(temporal[i]) * multiplicador;
      multiplicador++;
      if (multiplicador == 7) {
        multiplicador = 2;
      }
    }
    int result = acum % 11;
    result = 11 - result;

    res = result;
    //cadena = cadena.reversed();
    //final
    if (res == 11) {
      res = 0;
    }
    if (res == 10) {
      res = 1;
    }
    return res.toString();
  }

  String _xml_FINAL = "";
  // get xml_FINAL {
  String get_xml_FINAL() {
    print("fecha > " + this.xml_fecha);
    print("coddoc > " + this.xml_codDoc);
    print("ruc > " + this.xml_ruc);
    print("ambiente > " + this.xml_ambiente);
    print("sec > " + this.xml_secuencial);
    print("tipo emision > " + this.xml_tipoEmision);
    // print("verificador > " + digitoVerificador(cadena48));

    String primera = """
<?xml version="1.0" encoding="UTF-8"?>
<factura id="comprobante" version="1.0.0">
    <infoTributaria>
    <ambiente>${xml_ambiente}</ambiente>
    <tipoEmision>${xml_tipoEmision}</tipoEmision>
    <razonSocial>${xml_razonSocial}</razonSocial>
    <ruc>${xml_ruc}</ruc>
    <claveAcceso>${this.xml_claveAcceso}</claveAcceso>
    <codDoc>${xml_codDoc}</codDoc>
    <estab>${xml_estab}</estab>
    <ptoEmi>${xml_ptoEmi}</ptoEmi>
    <secuencial>${xml_secuencial}</secuencial>
    <dirMatriz>${xml_dirMatriz}</dirMatriz>
  </infoTributaria>
    """;
    double fixfloat =
        double.parse(xml_precionfinalCon) - double.parse(xml_precionfinalSin);
    fixfloat = double.parse(fixfloat.toStringAsFixed(2));
    String segunda = """
    <infoFactura>
    <fechaEmision>${xml_fecha}</fechaEmision>
    <dirEstablecimiento>${xml_dirEstablecimiento}</dirEstablecimiento>
    <obligadoContabilidad>SI</obligadoContabilidad>
    <tipoIdentificacionComprador>07</tipoIdentificacionComprador>
    <razonSocialComprador>${xml_razonSocial_comprador}</razonSocialComprador>
    <identificacionComprador>9999999999999</identificacionComprador>
    <totalSinImpuestos>${_xml_precionfinalSin}</totalSinImpuestos>
    <totalDescuento>0.00</totalDescuento>
    <totalConImpuestos>
      <totalImpuesto>
        <codigo>2</codigo>
        <codigoPorcentaje>2</codigoPorcentaje>
        <baseImponible>${xml_precionfinalSin}</baseImponible>
        <tarifa>12</tarifa>
        <valor>${fixfloat}</valor>
      </totalImpuesto>
    </totalConImpuestos>
    <propina>0</propina>
    <importeTotal>${xml_precionfinalCon}</importeTotal>
    <moneda>dolar</moneda>
    <pagos>
      <pago>
        <formaPago>01</formaPago>
        <total>${xml_precionfinalCon}</total>
      </pago>
    </pagos>
  </infoFactura>
    """;
    String tempi = "";
    for (CartitaProducto item in _productosDB) {
      if (item.activo) {
        tempi += item.xmlConcepto;
      }
    }
    return primera +
        segunda +
        "<detalles>" +
        tempi +
        "</detalles> \n </factura>";
  }

  set xml_FINAL(String cn) {
    this._xml_FINAL = cn;
  }

  List<Photo> _forSearch = [];
  get forSearch {
    return this._forSearch;
  }

  set forSearch(List<Photo> cn) {
    this._forSearch = cn;
  }

  List<CartitaProducto> _productosDB = [];
  void delete(int index) {
    this._productosDB.removeAt(index);
  }

  void clearProductosDB() {
    this._productosDB.clear();
  }

  set productosDB(List<String> cn) {
    this._productosDB.add(CartitaProducto(nombre: cn[0], codigo: cn[1]));
    // Container(
    //     // height: 70,
    //     width: double.infinity,
    //     // color: Colors.white,
    //     child: Card(
    //         child: Row(
    //       children: <Widget>[
    //         SizedBox(
    //           width: 60,
    //           child: MaterialButton(
    //               child: Icon(Icons.delete_outline),
    //               onPressed: () {
    //                 print("tmr");
    //               }),
    //         ),
    //         VerticalDivider(),
    //         SizedBox(
    //           width: 275,
    //           child: Column(
    //             children: <Widget>[
    //               Text(cn[0]),
    //               Text(cn[1]),
    //               Divider(),
    //               Center(
    //                 child: TextField(
    //                   keyboardType: TextInputType.number,
    //                   decoration: InputDecoration(
    //                       // border: InputBorder.,
    //                       hintText: 'Cantidad'),
    //                 ),
    //               )
    //             ],
    //           ),
    //         ),
    //       ],
    //     )),
    //   ));
  }

  get productosDB {
    return this._productosDB;
  }

  //datos de cliente elegido
  //complejo
  ClienteElegido _clienteActual = ClienteElegido(
    codigo: "",
    email: "",
    nombre: "",
    ruc: "",
  );
  set clienteActual(ClienteElegido cn) {
    this._clienteActual = cn;
  }

  get clienteActual {
    return this._clienteActual;
  }

  //simple
  Container _clienteElegido = Container();
  set clienteElegido(Container cn) {
    this._clienteElegido = cn;
  }

  get clienteElegido {
    return this._clienteElegido;
  }

  //precio total
  String _precioTotal = "";
  set precioTotal(String cn) {
    this._precioTotal = cn;
  }

  String getprecioTotal() {
    double precio = 0;
    for (CartitaProducto item in _productosDB) {
      if (item.tienePrecio && item.activo) {
        precio += double.parse(item.finalPrecio.text);
      }
    }
    String precioTot = precio.toString();
    return precioTot;
  }

  CartaPrecioFinal _preciosFinalesTotal = CartaPrecioFinal();
  get preciosFinalesTotal {
    return this._preciosFinalesTotal;
  }

  set preciosFinalesTotal(CartaPrecioFinal cn) {
    this._preciosFinalesTotal = cn;
  }

  void actualiza_total() {
    this._preciosFinalesTotal.updatePricing(productosDB);
  }

  String _xml_precionfinalSin = "";
  get xml_precionfinalSin {
    return this._xml_precionfinalSin;
  }

  set xml_precionfinalSin(String cn) {
    this._xml_precionfinalSin = cn;
  }

  String _xml_precionfinalCon = "";
  get xml_precionfinalCon {
    return this._xml_precionfinalCon;
  }

  set xml_precionfinalCon(String cn) {
    this._xml_precionfinalCon = cn;
  }

  bool _xml_enabler = false;
  get xml_enabler {
    return this._xml_enabler;
  }

  set xml_enabler(bool cn) {
    this._xml_enabler = cn;
  }

  String _xml_razonSocial_comprador = "9999999999999";
  get xml_razonSocial_comprador {
    return this._xml_razonSocial_comprador;
  }

  set xml_razonSocial_comprador(String cn) {
    this._xml_razonSocial_comprador = cn;
  }

  ExpandableController _xml_controller_expanded = ExpandableController();
  get xml_controller_expanded {
    return this._xml_controller_expanded;
  }

  set xml_controller_expanded(ExpandableController cn) {
    this._xml_controller_expanded = cn;
  }

  // Future<List<PhotoSRI>> fetchXML(
  Future<String> fetchXML(
      http.Client client, String empresa, String xml) async {
    // Map map = new Map<String, dynamic>();
    // map["empresa"] = empreCod;
    Map data = {'empresa_id': empresa, 'xml': xml};
    //encode Map to JSON
    var body = json.encode(data);
    print('asumiendo post > ' + body.toString());
    final response = await client.post(
        'http://167.172.203.137/services/mssql/send',
        headers: {"Content-Type": "application/json"},
        body: body);
    client.close();
    return response.body.toString();
    // return compute(parsePhotos, response.body);
  }

  Future<http.Response> sendXMLJSON(String empresa, String xml) {
    return http.post(
      'http://167.172.203.137/services/mssql/send',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'empresa_id': empresa,
      }),
    );
  }


  String _movCli ="";
  get movCli{
    return jsonEncode(<String, String>{
       "empresa_id": this.xml_empresaElegida,
		"agenci_id": this.xml_agenciaElegida,
		"numtrx_mcl": this.xml_secuencial,
		"linea_mcl" : "1",
    });
  } 

  Future<http.Response> saveMovcli() {
  return http.post(
          'http://167.172.203.137/services/mssql/save_factura',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "empresa_id": this.xml_empresaElegida,
		"agenci_id": this.xml_agenciaElegida,
		"numtrx_mcl": this.xml_secuencial,
		"linea_mcl" : "1",
		"fectrx_mcl" : this.xml_fecha,
		"fecemi_mcl"  : this.xml_fecha,
		"coddoc_mcl"  : "01",
		"numdoc_mcl"  : "numero factura",
		"numero_mcl"  : "numero factura",
		"nutrap_mcl"  : this.xml_secuencial,
		"codoap_mcl"  : "01",
		"numapl_mcl"  : "numero factura",
		"codcli_mcl"  : "codigo Cliente",
		"codven_mcl"  : "codigo vendedor",
		"refere_mcl"  : "numero factura",
		"subtot_mcl"  : "subtotal de factura",
		"descue_mcl"  : "descuecno de factura",
		"propin_mcl"  : "propina de factura",
		"otros_mcl"  : "0",
		"iva_mcl"  : "iva de factura",
		"ivacs_mcl"  : "0",
		"ice_mcl"  : "0",
		"flete_mcl"  : "0",
		"total_mcl" : "",
		"subiv1_mcl":	"Base 0% de IVA",
	"subiv2_mcl":	"Base 12% de IVA",
	"subsid_mcl":	"Subsidio de la factura",
	"sinsub_mcl":	"Valor sin Subsidio",
	"irbpnr_mcl":	"Impuesto redimible",
	"nuaudo_mcl"	: "Numero de Acturización de la factura Ejemplo: 0304202001179184241300120010020000047440000699310",
	"nusedo_mcl"	: "Punto de Venta + Emisión de la factura Ejemplo: 001-002",
	"feaudo_mcl"	: "Fecha de la autorización de la factura respuesta del SRI, Ejemplo: 2020-04-03 14:00:13.000",
	"claacc_mcl"	: "Clave de acceso de la factura: Ejemplo: 0304202001179184241300120010020000047440000699310",
	"forpag_mcl"	: "Forma de Pago de la factura, ejemplo: 20",
	"plazo_mcl"	: "Plazo de pago de la factura, ejemplo: 001 - Contado",
	"nutrre_mcl"	: "",
	"codore_mcl"	: "",
	"nudore_mcl"	: "",
	"observ_mcl"	: "Comentarios a la factura" ,
	"motdev_mcl"	: "",
	"estado_mcl":	"151=Emitida, 152=Autorizada y Enviada SRI",
	"codusu_mcl":	this.xml_cod_comprador,
	"fecusu_mcl":	this.xml_fecha,
	// "usumod_mcl":	"Enviar este campo vacio, a menos que anule la factura pone el usuario que anulo la factura",
	"usumod_mcl":	"",
	// "fecmod_mcl":	"Enviar este campo vacio, a menos que anule la factura pone la fecha y hora que anulo la factura",
	"fecmod_mcl":	"",
    }),
  );
}


Future<http.Response> saveMovart(String title) {
  return http.post(
    'https://jsonplaceholder.typicode.com/albums',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "empresa_id":	this.xml_empresaElegida ,
      "agenci_id"	: this.xml_agenciaElegida ,
      "numtrx_mar":	"numero interno/secuencial seis digitos" ,
      "fectrx_mar":	this.xml_fecha ,
      "linea_mar":	"Linea de registro de cada item, si tengo 4 detalles debe estar numerada del 1 al 4" ,
      "fecha_mar"	:"Fecha de la factura, deber ser el mismo de movcli",
      "coddoc_mar":	"Codigo de Documento, en este caso si es factura electrónica es 201, y si es preimpresa es 207, debe ser el mismo de movcli",
      "numero_mar":	"Numero de factura, el secuencial debe tomarlo de la tabla docume y debe ser el mismo de movcli",
      "codcp_mar":	this.xml_cod_comprador ,
      "codven_mar":	this.xml_cod_vendedor ,
      "coplpr_mar":	"Codigo del plan de precio del producto",
      "codart_mar":	"Codigo del articulo" ,
      "coboor_mar":	"Codigo de bodega, se puede setear una predeterminada",
      "cobode_mar":	"Este campo enviar vacio, es bodega de destino aplica para transferencias",
      "codund_mar":	"Codigo de unidade de medida",
      "fracci_mar":	"1",
      "cantid_mar":	"Cantidad del item" ,
      "preuni_mar":	"Precio unitario" ,
      "precio_mar":	"Cantidad * Precio unitario, es el importe por cada items",
      "costo_mar":	"La multiplicación de cosest_art * cantid_mar",
      "descue_mar":	"El descuento del item * la cantidad",
      "impiva_mar":	"Si aplica iva es 1, y si no aplica 0",
      "iva_mar":	"El valor del iva del producto",
      "ivacs_mar":	"0",
      "impice_mar":	"Si aplica ice es 1, y si no aplica 0",
      "ice_mar":	"El valor del ice del producto",
      "impsub_mar":	"Si aplica subsidio es 1, y si no aplica 0",
      "subsid_mar":	"El valor del subsisio",
      "sinsub_mar":	"El valor sin subsidio",
      "impire_mar":	"Si aplica Impuesto redimible es 1, y si no aplica 0",
      "irbpnr_mar":	"El valor del impuesto redimible del producto",
      "observa_mar":	"Alguna observación del item, si hay si no vacio",
      "codkit_mar":	"Este campo enviar vacio, en caso que el item es kit se debe grabar el mismo codigo",
      "ordpro_mar":	"Enviar este campo vacio, Orden de Producción",
      "numlot_mar":	"Enviar este campo vacio, Lote de Producción",
      "codser_mar":	"Enviar este campo vacio, Cuando el prodcuto se aplica por series",
      "observ_mar":	"Alguna observación del item, si hay si no vacio",
      "estado_mar":	"151=Emitida, 152=Autorizada y Enviada SRI",
      "codusu_mar":	this.xml_cod_comprador,
      "fecusu_mar":	"Fecha y hora del servidor, en la cual se registro la transación",
      "usumod_mar":	"Enviar este campo vacio, a menos que anule la factura pone el usuario que anulo la factura",
      "fecmod_mar":	"Enviar este campo vacio, a menos que anule la factura pone la fecha y hora que anulo la factura"
    }),
  );
}

Future<http.Response> createAlbum(String title) {
  return http.post(
    'http://167.172.203.137/services/mssql/testing',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, Map>{
      "bio": {
        "short": "tuuu",
        "long": "teee",
      },
    }),
  );
}

//post requests con FORM
  Future<http.Response> sendXML() async {
    final p = await http
        .post('http://167.172.203.137/services/mssql/get_secuencial',
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'empresa_id': this.xml_empresaElegida,
              'agenci_id': this.xml_agenciaElegida,
              'codDoc': this.xml_codDoc,
            }));
    String secuencial_recuperado = p.body
          .toString()
          .substring(p.body.toString().length - 9, p.body.toString().length);
        this.xml_ambiente = "1";
    this.xml_tipoEmision = "1";
    DateTime now = DateTime.now();
    this.xml_fecha = DateFormat('dd/MM/yyyy').format(now);
    this._xml_dirEstablecimiento = this._xml_dirMatriz;
    this.xml_secuencial = secuencial_recuperado;
    //procede a generar la clave de acceso
    String cadena48 = "";
    cadena48 += this.xml_fecha;
    cadena48 = cadena48.replaceAll("/", "");
    cadena48 += this.xml_codDoc;
    cadena48 += this.xml_ruc;
    cadena48 += this.xml_ambiente;
    cadena48 += "001001";
    cadena48 += xml_secuencial;
    cadena48 += "12345678"; // depende de uno
    cadena48 += this.xml_tipoEmision;
    cadena48 += digitoVerificador(cadena48);
    print("rclave de acceso >> " + cadena48);
    this.xml_claveAcceso = cadena48;
    String xmlfinal =  this.get_xml_FINAL();

    var map = new Map<String, dynamic>();
    map['empresa_id'] = this.xml_empresaElegida;
    map['xml'] = xmlfinal;
    map['ambiente'] = this.xml_ambiente;
    return http.post(
      'http://167.172.203.137/services/mssql/send',
      body: map,
    );
  }
  // A function that converts a response body into a List<Photo>.
  // List<PhotoSRI> parsePhotos(String responseBody) {
  //   // final productoInfo=Provider.of<ProductosArrayInfo>(context);
  //   final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  //   //return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
  //   temporal = parsed.map<PhotoSRI>((json) => PhotoSRI.fromJson(json)).toList();
  //   return temporal;
  // }

  // List<PhotoSRI> _temporal = [];
  // get temporal {
  //   return this._temporal;
  // }

  // set temporal(List<PhotoSRI> cn) {
  //   this._temporal = cn;
  // }
}

class PhotoSRI {
  final String empresa;

  final String xml;
//  Photo({this.albumId, this.id, this.title, this.url, this.thumbnailUrl});
  PhotoSRI({
    this.empresa,
    this.xml,
  }); //this.cod_corregir, this.nombre_principal,

  factory PhotoSRI.fromJson(Map<String, dynamic> json) {
    return PhotoSRI(
      empresa: json['empresa'],
      xml: json['xml'],
    );
  }
}
