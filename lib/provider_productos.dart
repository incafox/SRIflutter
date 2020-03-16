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
  temporals =
      parsed.map<PhotoImpuesto>((json) => PhotoImpuesto.fromJson(json)).toList();
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
  int cantidad;
  String xmlConcepto = "";

  TextEditingController input = TextEditingController(text: "1");
  TextEditingController finalPrecio = TextEditingController(text: "");
  TextEditingController actualPrecio = TextEditingController(text: "");
  ExpandableController control = ExpandableController();
  TextEditingController impuestoDescripcion = TextEditingController(text: "");
  TextEditingController impuestoPorcentaje = TextEditingController(text: "");
  TextEditingController totalPrecioConImpuesto= TextEditingController(text: "");
  TextEditingController cantidadImpuesto= TextEditingController(text: "");


  void _getALlPosts(String codigo) async {
    List<PhotoPrice> t = await fetchClientes(http.Client(), codigo);
    List<PhotoImpuesto> r = await fetchImpuesto(http.Client(), codigo);

    this.actualPrecio.text = t[0].precio;
    this.finalPrecio.text = t[0].precio;
    this.impuestoDescripcion.text = r[0].descripcion;
    this.impuestoPorcentaje.text = r[0].porcentaje;
    // this.impuestoCantidad
    this.tienePrecio = true;
    if(this.impuestoPorcentaje.text != "0"){
      
      double temp = double.parse(this.finalPrecio.text)*(double.parse(this.impuestoPorcentaje.text)/100);
      double resto =  temp;
      temp = double.parse(this.actualPrecio.text) + temp;
      this.cantidadImpuesto.text = resto.toString();
      this.totalPrecioConImpuesto.text =  temp.toString();
    }
    else{
      this.cantidadImpuesto.text = "0";
      this.totalPrecioConImpuesto.text = this.finalPrecio.text;
    }
    // return t;
  }


  @override
  Widget build(BuildContext context) {
    final productoInfo=Provider.of<ProductosArrayInfo>(context);
    
    // TODO: implement build
    this._getALlPosts(this.codigo);
    this.finalPrecio.text = this.actualPrecio.text;
    this.totalPrecioConImpuesto.text = this.actualPrecio.text;
    // double t;
    // t = double.parse(this.actualPrecio.text);
    // this.finalPrecio.text = t.toString();
  productoInfo.xml_enabler = false;
    this.xmlConcepto = """
                          <detalle>
                          <codigoPrincipal>${this.codigo}</codigoPrincipal>
                          <descripcion>${this.nombre}</descripcion>
                          <cantidad>1</cantidad>
                          <precioUnitario>${this.actualPrecio.text}</precioUnitario>
                          <descuento>none</descuento>
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
                        onChanged: (val){
                          productoInfo.xml_controller_expanded.expanded = true;
                          productoInfo.xml_enabler = false;
                          double t;
                          t = double.parse(val) *
                              double.parse(this.actualPrecio.text);
                          this.finalPrecio.text = t.toString();
                          if(this.impuestoPorcentaje.text != "0"){
                            
                            double temp = double.parse(this.finalPrecio.text)*(double.parse(this.impuestoPorcentaje.text)/100);
                            double resto =  temp;
                            temp += double.parse(this.finalPrecio.text) ;
                            this.cantidadImpuesto.text = resto.toString();
                            this.totalPrecioConImpuesto.text = temp.toString();
                          }
                          else{
                            this.cantidadImpuesto.text = "0";
                            this.totalPrecioConImpuesto.text = this.finalPrecio.text;
                          }
                          this.xmlConcepto = """
                          <detalle>
                          <codigoPrincipal>${this.codigo}</codigoPrincipal>
                          <descripcion>${this.nombre}</descripcion>
                          <cantidad>${val.toString()}</cantidad>
                          <precioUnitario>${this.actualPrecio.text}</precioUnitario>
                          <descuento>none</descuento>
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
                                if (i.activo){
                                  // print(i.finalPrecio.text);
                                  // print(i.totalPrecioConImpuesto.text);
                                  
                                  sinIm += double.parse(i.finalPrecio.text);
                                  conIm += double.parse(i.totalPrecioConImpuesto.text);
                                }
                              //  print( "sin impuesto  " +finalPrice.text);
                              //  print( "con impuesto  " +finalPriceConIM.text);
                                // this.finalPrice.text = sinIm.toString();
                                // this.finalPriceConIM.text = conIm.toString();
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
                    )
                    ,
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
            Text("precio total con impuesto"),
            Container(
                      width: 100,
                      child: TextField(
                        textAlign: TextAlign.center,
                        readOnly: true,
                        maxLines: 1,
                        controller: this.impuestoDescripcion,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            // border: InputBorder.,
                            ),
                      ),
                    ),
              Container(
                      width: 90,
                      child: TextField(
                        readOnly: true,
                        maxLines: 1,
                        controller: this.totalPrecioConImpuesto,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            // border: InputBorder.,
                            ),
                      ),
                    )
            ],),
            
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
  
  void updatePricing(List<CartitaProducto> tmr){
    double sinIm;
    double conIm;
    for (CartitaProducto item in tmr) {
      if (item.activo)
      {
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
      child: Column(children: <Widget>[
        Text("total sin impuestos"),
        Text(this.sinImpuestos.text),
        Text("total con impuestos"),
        Text(this.conImpuestos.text),

      ],),

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

  String _xml_claveAcceso = "";
  get xml_claveAcceso {
    return this._xml_claveAcceso;
  }

  set xml_claveAcceso(String cn) {
    this._xml_claveAcceso = cn;
  }

  String _xml_codDoc = "";
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

  String _xml_dirEstablecimiento = "";
  get xml_dirEstablecimiento {
    return this._xml_dirEstablecimiento;
  }

  set xml_dirEstablecimiento(String cn) {
    this._xml_dirEstablecimiento = cn;
  }

  String _xml_FINAL = "";
  get xml_FINAL {
    String primera = """
<?xml version="1.0" encoding="UTF-8"?>
<factura id="comprobante" version="1.0.0">
    <infoTributaria>
    <ambiente>${xml_ambiente}</ambiente>
    <tipoEmision>${xml_tipoEmision}</tipoEmision>
    <razonSocial>${xml_razonSocial}</razonSocial>
    <ruc>${xml_ruc}</ruc>
    <claveAcceso>vacio</claveAcceso>
    <codDoc>${xml_codDoc}</codDoc>
    <estab>${xml_estab}</estab>
    <ptoEmi>${xml_ptoEmi}</ptoEmi>
    <secuencial>${xml_secuencial}</secuencial>
    <dirMatriz>${xml_dirMatriz}</dirMatriz>
  </infoTributaria>
    """;

    String segunda = """
    <infoFactura>
    <fechaEmision>21/11/2019</fechaEmision>
    <dirEstablecimiento>Customer Address, Petaling Jaya, Selangor, Malaysia</dirEstablecimiento>
    <obligadoContabilidad>SI</obligadoContabilidad>
    <tipoIdentificacionComprador>07</tipoIdentificacionComprador>
    <razonSocialComprador>CONSUMIDOR FINAL</razonSocialComprador>
    <identificacionComprador>1</identificacionComprador>
    <totalSinImpuestos>1500.00</totalSinImpuestos>
    <totalDescuento>0.00</totalDescuento>
    <totalConImpuestos>
      <totalImpuesto>
        <codigo>2</codigo>
        <codigoPorcentaje>2</codigoPorcentaje>
        <baseImponible>1500.00</baseImponible>
        <tarifa>12</tarifa>
        <valor>180</valor>
      </totalImpuesto>
    </totalConImpuestos>
    <propina>0</propina>
    <importeTotal>1680</importeTotal>
    <moneda>dolar</moneda>
    <pagos>
      <pago>
        <formaPago>01</formaPago>
        <total>1680</total>
      </pago>
    </pagos>
  </infoFactura>
    """;
    String tempi="";
    for (CartitaProducto item in _productosDB) {
      if (item.activo){
        tempi+=item.xmlConcepto;
      }
    }
    return primera+segunda+tempi;
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
  get preciosFinalesTotal{
    return this._preciosFinalesTotal;
  }
  set preciosFinalesTotal(CartaPrecioFinal cn){
    this._preciosFinalesTotal = cn;
  }

  void actualiza_total(){
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
  get xml_enabler{
    return this._xml_enabler;
  }
  set xml_enabler(bool cn) {
    this._xml_enabler = cn;
  }

  ExpandableController _xml_controller_expanded = ExpandableController();
  get xml_controller_expanded{
    return this._xml_controller_expanded;
  }
  set xml_controller_expanded(ExpandableController cn) {
    this._xml_controller_expanded = cn;
  }
}
