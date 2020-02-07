import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'form_descripcion.dart';




class StackProductos extends StatefulWidget {

@override
  final globalKey = GlobalKey<_StackProductosState>();

  @override
  _StackProductosState createState() => _StackProductosState();
}

class _StackProductosState extends State<StackProductos> {
  List<Widget> productos;
  // CardProduct t = CardProduct();
  
  List<String> getProductos(){
    List<String> descrip=[];
    for (var item in productos) {
      if (item is CardProduct){
        descrip.add(item.globalKey.currentState.descripcion);
      }
    }
    return descrip;
  }

  @override
  void initState() {
    this.productos = [];
    super.initState();
    final productoInfo=Provider.of<ProductosArrayInfo>(context,listen: false);
    List<String> temp = productoInfo.descripciones;
    temp.add("");
    productoInfo.descripciones = temp;
  }
  function(value) => setState(() {
    productos[value] = Container(color: Colors.cyan,height: 0.1,);
    // this.productos.removeAt(value);
  });

  @override
  Widget build(BuildContext context) {
    final productoInfo=Provider.of<ProductosArrayInfo>(context);
    return Container(width: double.infinity,child: 
    Column(children: <Widget>[

      SizedBox(width: 200,
              child: MaterialButton(
            textColor: Colors.white,child: Row(children: <Widget>[
              Icon(Icons.add_box),
          Text('\t    Agrega producto')
        ],) ,
            color: Colors.red,
            onPressed: (){
              setState(() {
                this.productos.add(CardProduct(func: function,indice: this.productos.length, ));
                productoInfo.productos = this.productos;
                
                // print ('eee');
                // List<Widget> todos = productoInfo.productos;
                // print (todos.length);
              });
            }),
      ),
      Column(children: this.productos.toList(),),
    ],)
    );
  }
}

class ProductosArrayInfo extends ChangeNotifier {
  // List<String> _lista = ['ola'];
  String _lista = 'lol';
  
  String ambiente ;
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
  String _cliente_razonSocial= '';
  String _cliente_direccion= '';
  String _cliente_email= '';
  String _cliente_contabilidad= '';
  String _cliente_tipoIdentificacion= '';
  String _cliente_identificacion= '';


get cliente_razonSocial {return this._cliente_razonSocial;}
get cliente_direccion {return this._cliente_direccion;}
get cliente_email {return this._cliente_email;}
get cliente_contabilidad {return this._cliente_contabilidad;}
get cliente_tipoIdentificacion {return this._cliente_tipoIdentificacion;}
get cliente_identificacion {return this._cliente_identificacion;}

set cliente_razonSocial(String k) {this._cliente_razonSocial = k;
    notifyListeners();}
set cliente_direccion(String k) {this._cliente_direccion = k;
    notifyListeners();}
set cliente_email(String k) {this._cliente_email = k;
    notifyListeners();}
set cliente_contabilidad(String k) {this._cliente_contabilidad = k;
    notifyListeners();}
set cliente_tipoIdentificacion(String k) {this._cliente_tipoIdentificacion = k;
    notifyListeners();}
set cliente_identificacion(String k) {this._cliente_identificacion = k;
    notifyListeners();}

  //para productos
  List<Widget> _productos = [];

  // List<Widget> productos;
  get productos {return this._productos;}
  set productos (List<Widget> cn) {this._productos = cn;}
  
  StackProductos _stack = new StackProductos();
  get stack {return this._stack;}
  set stack (StackProductos cn) {this._stack = cn;}


  List<String> getDescrip(){
    List<Widget> y = this.productos;
    print('size > ' + y.length.toString());
    List<String> descrip=[];
    int count=0;
    for (var item in y) {
      if (item is CardProduct){
        count++;
        // int u = (item.globalKey.currentState.indice);
        // print (u);
        // descrip.add(item.globalKey.currentState.descripcion);
      }
    }
    print('productos > '+count.toString());
    return descrip;
  }

  //PARA EL INVENTARIO
  List<String> _descripciones = List<String>.generate(70, (i) => "None");
  get descripciones {return this._descripciones;}
  set descripciones (List<String> cn) {this._descripciones= cn;}
  
  List<String> _costosUnitarios = List<String>.generate(70, (i) => "None");
  get costosUnitarios {return this._costosUnitarios;}
  set costosUnitarios (List<String> cn) {this._costosUnitarios = cn;}
  
  List<String> _cantidades = List<String>.generate(70, (i) => "None");
  get cantidades {return this._cantidades;}
  set cantidades (List<String> cn) {this._cantidades = cn;}
  
  List<String> _totales = List<String>.generate(70, (i) => "None");
  get totales {return this._totales;}
  set totales (List<String> cn) {this._totales = cn;}
  
  double _precioFinalTotal = 0.0 ;//as double;
  get precioFinalTotal {return this._precioFinalTotal;}
  set precioFinalTotal (double cn) {this._precioFinalTotal = cn;}
  
  double getPrecioTotal() {
    
    // List<String> temp = [];
    double precioTotal = 0 ;//as double;
    for (int i=0; i<20; i++){
    // print (i);
      if(!this.totales[i].contains("None"))
      {
        String te = this.totales[i];
        // precioTotal+=int.parse( (te.replaceAll("$/" , ''))  );
        precioTotal+=double.parse(te);
        // temp.add(this.descripciones[i] + "/" + this.costosUnitarios[i] + "/" + this.cantidades[i]+ "/" +this.totales[i] ); 
      }
    }
    // print ('precio total > ' + precioTotal.toString());
    return precioTotal;
    }
  // set precioTotal (int cn) {this._precioTotal = cn;}
  
  List<String> conceptos(){
    // print ('da');
    List<String> temp = [];
    double precioTotal = 0;
    for (int i=0; i<20; i++){
    // print (i);

      if(!this.totales[i].contains("None"))
      {
        String te = this.totales[i];
        // precioTotal+=int.parse( (te.replaceAll("$/" , ''))  );
        precioTotal+=double.parse(te);
        temp.add(this.descripciones[i] + "/" + this.costosUnitarios[i] + "/" + this.cantidades[i]+ "/" +this.totales[i] ); 
      }
    }
    print ('precio total > ' + precioTotal.toString());
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
      this.tipoEmision=  prefs.getString("razonSocial");
      this.razonSocial = prefs.getString("tipoEmision");
      this.ruc =  prefs.getString("ruc");
      this.codDoc = prefs.getString("codDoc");
      this.estab =  prefs.getString("estab");
      this.ptoEmi =  prefs.getString("ptoEmi");
      this.secuencial = prefs.getString("secuencial");
      this.dirMatriz = prefs.getString("dirMatriz");
  }

  void setExternal(String l ){
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
  String _p12path='';
  String _p12clave = '';

  get p12path {return this._p12path;}
  set p12path (String cn) {this._p12path = cn;}

  get p12clave {return this._p12clave;}
  set p12clave (String cn) {this._p12clave = cn;}



}
