import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final_sri/provider_productos.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'clientesJson.dart';
import 'factura.dart' as factura;
import 'form_emisor.dart' as formEmisor;
import 'form_cliente.dart' as formCliente;
import 'form_descripcion.dart';
import 'singleton_formulario_actual.dart' as singleton;

// class StackProductos extends StatefulWidget {
//   @override
//   _StackProductosState createState() => _StackProductosState();
// }

// class _StackProductosState extends State<StackProductos> {
//   List<CardProduct> productos;
//   @override
//   void initState() {
//     // TODO: implement initState
//     // productos = [CardProduct(),CardProduct()];
//     super.initState();
//   }

//   void addProduct(){
//     this.productos.add(new CardProduct());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(children: this.productos.toList(),);
//   }
// }

class StackProductos extends StatefulWidget {
  @override
  _StackProductosState createState() => _StackProductosState();
}

class _StackProductosState extends State<StackProductos> {
  List<Widget> productos;
  // CardProduct t = CardProduct();

  @override
  void initState() {
    this.productos = [];
    super.initState();
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
                      Text('\t    Agrega concepto')
                    ],
                  ),
                  color: Colors.blue,
                  onPressed: () {
                    setState(() {
                      this.productos.add(CardProduct(
                            func: function,
                            indice: this.productos.length,
                          ));
                      productoInfo.productos = this.productos;

                      // print ('eee');
                      // List<Widget> todos = productoInfo.productos;
                      // print (todos.length);
                    });
                  }),
            ),
            Column(
              children: this.productos.toList(),
            ),
          ],
        ));
  }
}

class TabFacturaEditar extends StatefulWidget {
  @override
  _TabFacturaEditarState createState() => _TabFacturaEditarState();
}

class _TabFacturaEditarState extends State<TabFacturaEditar>
    with AutomaticKeepAliveClientMixin<TabFacturaEditar> {
//class MyHomePage extends StatelessWidget {
//class TabFacturaEditar extends StatelessWidget {
  //TabFacturaEditar()
  //final String title;
  // GlobalKey<CardProductState> llavesita;
  // StackProductos test = new StackProductos();

  List<CardProduct> productos = [];

  TextEditingController controller_razonSocial = TextEditingController();
  TextEditingController controller_ambiente = TextEditingController();
  TextEditingController controller_ruc = TextEditingController();
  TextEditingController controller_tipoEmision = TextEditingController();
  TextEditingController controller_estab = TextEditingController();
  TextEditingController controller_ptoEmi = TextEditingController();
  TextEditingController controller_secuencial = TextEditingController();
  TextEditingController controller_codDoc = TextEditingController();
  TextEditingController controller_claveAcceso = TextEditingController();
//  TextEditingController controller_ = TextEditingController();
  TextEditingController controller_dirMatriz = TextEditingController();

  TextEditingController finalPrice = TextEditingController();
  TextEditingController finalPriceConIM = TextEditingController();

  TextEditingController finalPriceSIN = TextEditingController();
  TextEditingController finalPriceCON = TextEditingController();

  ExpandableController finalController = ExpandableController();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      this.controller_ambiente =
          new TextEditingController(text: prefs.getString("ambiente"));
      this.controller_razonSocial =
          new TextEditingController(text: prefs.getString("razonSocial"));
      this.controller_tipoEmision =
          new TextEditingController(text: prefs.getString("tipoEmision"));
      this.controller_ruc =
          new TextEditingController(text: prefs.getString("ruc"));
      this.controller_codDoc =
          new TextEditingController(text: prefs.getString("codDoc"));
      this.controller_estab =
          new TextEditingController(text: prefs.getString("estab"));
      this.controller_ptoEmi =
          new TextEditingController(text: prefs.getString("ptoEmi"));
      this.controller_secuencial =
          new TextEditingController(text: prefs.getString("secuencial"));
      this.controller_dirMatriz =
          new TextEditingController(text: prefs.getString("dirMatriz"));
    });
  }

  //SharedPreferences pref = new SharedPreferences.getInstance();
  @override
  Widget build(BuildContext context) {
    //this.getSharedPrefs();

    final productoInfo = Provider.of<ProductosArrayInfo>(context);
    this.controller_ambiente.text = productoInfo.ambiente;
    this.controller_tipoEmision.text = productoInfo.tipoEmision;
    this.controller_razonSocial.text = productoInfo.razonSocial;
    this.controller_ruc.text = productoInfo.ruc;
    this.controller_claveAcceso.text = productoInfo.claveAcceso;
    this.controller_codDoc.text = productoInfo.codDoc;
    this.controller_estab.text = productoInfo.estab;
    this.controller_ptoEmi.text = productoInfo.ptoEmi;
    this.controller_secuencial.text = productoInfo.secuencial;
    this.controller_dirMatriz.text = productoInfo.dirMatriz;

    this.finalPriceCON.text = productoInfo.xml_precionfinalCon;
    this.finalPriceSIN.text = productoInfo.xml_precionfinalSin;
    // this.finalPrice.text = productoInfo.precioTotal;
    // productoInfo.addProducto();
    // productoInfo.addProducto();
    // productoInfo.addProducto();

    Table tab = new Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(30.0),
        1: FlexColumnWidth(50.0),
      },
      border: TableBorder.all(color: Colors.black45),
      children: [
        TableRow(children: [
          Text('\tAmbiente'),
          Text(this.controller_ambiente.text),
          // Text(productoInfo.ambiente),
        ]),
        TableRow(children: [
          Text('\tTipo emision'),
          Text(this.controller_tipoEmision.text),
        ]),
        TableRow(children: [
          Text('\tRazon social'),
          Text(this.controller_razonSocial.text),
        ]),
        TableRow(children: [
          Text('\tRuc'),
          Text(this.controller_ruc.text),
        ]),
        // TableRow(children: [
        //   Text('\tClave acceso'),
        //   Text(this.controller_claveAcceso.text),
        // ]),
        TableRow(children: [
          Text('\tCodigo documentario'),
          Text(this.controller_codDoc.text),
        ]),
        TableRow(children: [
          Text('\tEstablecimiento'),
          Text(this.controller_estab.text),
        ]),
        TableRow(children: [
          Text('\tPunto de emision'),
          Text(this.controller_ptoEmi.text),
        ]),
        TableRow(children: [
          Text('\tSecuencial'),
          Text(this.controller_secuencial.text),
        ]),
        TableRow(children: [
          Text('\tDir matriz'),
          Text(this.controller_dirMatriz.text),
        ])
      ],
    );

    Table tabDatosCliente = new Table(
        columnWidths: const <int, TableColumnWidth>{
          0: FlexColumnWidth(30.0),
          1: FlexColumnWidth(50.0),
        },
        border: TableBorder.all(color: Colors.black45),
        children: [
          TableRow(children: [
            Text('\tRazon Social'),
            Text(productoInfo.cliente_razonSocial),
          ]),
          TableRow(children: [
            Text('\tEmail'),
            Text(productoInfo.cliente_email),
          ]),
          TableRow(children: [
            Text('\tDireccion'),
            Text(productoInfo.cliente_direccion),
          ]),
          TableRow(children: [
            Text('\tContabilidad'),
            Text(productoInfo.cliente_contabilidad),
          ]),
          TableRow(children: [
            Text('\ttipo identificacion'),
            Text(productoInfo.cliente_tipoIdentificacion),
          ]),
          TableRow(children: [
            Text('\tIdentificacion'),
            Text(productoInfo.cliente_identificacion),
          ]),
        ]);

    return Container(
      color: Colors.black12,
      child: ListView(
        children: <Widget>[
          Visibility(
            visible: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
              child: Container(
                //padding: EdgeInsets.all(10),
                child: new Material(
                  child: new InkWell(
                    onTap: () {
                      print("tapped");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => formEmisor.FormEmisor()));
                    },
                    child: Stack(
                      children: <Widget>[
                        //TITULO
                        Container(
                          color: Colors.black45,
                          width: double.infinity,
                          height: 35.0,
                          child: Center(
                            child: Text(
                              'Datos Emisor',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                        //PARA CONTENIDO
                        Container(
                          //width: double.infinity,
                          //height: 200.0,
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 45,
                              ),

                              Container(
                                padding: EdgeInsets.all(5),
                                width: double.infinity,
                                child: Table(
                                  columnWidths: const <int, TableColumnWidth>{
                                    0: FlexColumnWidth(30.0),
                                    1: FlexColumnWidth(50.0),
                                  },
                                  border:
                                      TableBorder.all(color: Colors.black45),
                                  children: [
                                    TableRow(children: [
                                      Text('\tAmbiente'),
                                      Text(this.controller_ambiente.text),
                                      //Text(productoInfo.ambiente),
                                    ]),
                                    TableRow(children: [
                                      Text('\tTipo emision'),
                                      Text(this.controller_tipoEmision.text),
                                    ]),
                                    TableRow(children: [
                                      Text('\tRazon social'),
                                      Text(this.controller_razonSocial.text),
                                    ]),
                                    TableRow(children: [
                                      Text('\tRuc'),
                                      Text(this.controller_ruc.text),
                                    ]),
                                    // TableRow(children: [
                                    //   Text('\tClave acceso'),
                                    //   Text(this.controller_claveAcceso.text),
                                    // ]),
                                    TableRow(children: [
                                      Text('\tCodigo documentario'),
                                      Text(this.controller_codDoc.text),
                                    ]),
                                    TableRow(children: [
                                      Text('\tEstablecimiento'),
                                      Text(this.controller_estab.text),
                                    ]),
                                    TableRow(children: [
                                      Text('\tPunto de emision'),
                                      Text(this.controller_ptoEmi.text),
                                    ]),
                                    TableRow(children: [
                                      Text('\tSecuencial'),
                                      Text(this.controller_secuencial.text),
                                    ]),
                                    TableRow(children: [
                                      Text('\tDir matriz'),
                                      Text(this.controller_dirMatriz.text),
                                    ])
                                  ],
                                ),
                              ), // = new TextEditingController(text:prefs.getString("codDoc"));
                              //Container(
//                            child: Text('secuencial : ' +
//                                this.controller_secuencial.text),
//                            width: double.infinity,
//                          ) //= new TextEditingController(text: prefs.getString("secuencial"));
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  color: Colors.transparent,
                ),
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
            child: Container(
              //padding: EdgeInsets.all(10),
              child: new Material(
                child: new InkWell(
                  onTap: () {
                    // print("tapped");
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => formCliente.FormCliente()));
                  },
                  child: Stack(
                    children: <Widget>[
                      //TITULO
                      Container(
                        color: Colors.black38,
                        width: double.infinity,
                        height: 35.0,
                        child: Center(
                          child: Text(
                            'Datos Cliente',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            height: 45,
                          ),
                          //PARA CONTENIDO
                          // Container(
                          //   padding: EdgeInsets.all(5),
                          //   width: double.infinity,
                          //   child: tabDatosCliente,
                          // ),

                          SizedBox(
                            width: 370,
                            child: Column(
                              children: <Widget>[
                                productoInfo.clienteActual,
                                // productoInfo.clienteElegido,
                                MaterialButton(
                                    textColor: Colors.white,
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.add_box),
                                        Text('\t      Elegir Cliente')
                                      ],
                                    ),
                                    color: Color(0xFF478DE0),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ClientesJsonSearchPage()));
                                    }),
                                // MaterialButton(
                                // textColor: Colors.white,
                                // child: Row(
                                //   children: <Widget>[
                                //     Icon(Icons.add_box),
                                //     Text('\t    Cliente Nuevo')
                                //   ],
                                // ),
                                // color: Colors.blue,
                                // onPressed: () {
                                //   // Navigator.push(
                                //   //     context,
                                //   //     MaterialPageRoute(
                                //   //         builder: (context) => ClientesJsonSearchPage()));

                                // })
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                color: Colors.transparent,
              ),
              color: Colors.white,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
            child: Container(
              //padding: EdgeInsets.all(10),
              child: new Material(
                child: new InkWell(
                  onTap: () {
//                    print("tapped");
//                    Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                            builder: (context) =>
//                                formDescripcion.FormDescripcion()));
                  },
                  child: Stack(
                    children: <Widget>[
                      //TITULO
                      Container(
                        color: Colors.black38,
                        width: double.infinity,
                        height: 35.0,
                        child: Center(
                          child: Text(
                            'Descripcion y Conceptos',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      //PARA CONTENIDO
                      Container(
                        //height: 200.0,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 35,
                            ),

//                                  .text), //= new TextEditingController(text: prefs.getString("secuencial"));
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                color: Colors.transparent,
              ),
              color: Colors.white,
            ),
          ),

          productoInfo.stack,
          //StackProductos(),
          Column(
            children: productoInfo.productosDB,
          ),

          //this.test,
          // CardProduct(),
          // CardProduct(),
          // CardProduct(),
          // CardProduct(),
          // Column(children:
          //   this.productos.toList()
          // ,),
          //todo mrd

//           Padding(
//             padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
//             child: Container(
//               //padding: EdgeInsets.all(10),
//               child: new Material(
//                 child: new InkWell(
//                   onTap: () {
//                     print("tapped");
// //                    Navigator.push(
// //                        context,
// //                        MaterialPageRoute(
// //                            builder: (context) => formEmisor.FormEmisor()));
//                   },
//                   child: Stack(
//                     children: <Widget>[
//                       //TITULO
//                       Container(
//                         color: Colors.black54,
//                         width: double.infinity,
//                         height: 35.0,
//                         child: Center(
//                           child: Text(
//                             'Descuentos',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(color: Colors.white, fontSize: 18),
//                           ),
//                         ),
//                       ),
//                       //PARA CONTENIDO
//                       Container(
//                         //height: 200.0,
//                         child: Column(
//                           children: <Widget>[
//                             Container(
//                               height: 35,
//                             ),
//                             Container(
//                               width: double.infinity,
//                               child: Text(
//                                   'Razon Social : ' + this.controller_razonSocial.text),
//                             ),
//                             Container(
//                               child: Text('Ruc: ' + this.controller_ruc.text),
//                               width: double.infinity,
//                             ),
//                             //= new TextEditingController(text: prefs.getString("ruc"));
// //                        Text('cod Doc : '+this.controller_codDoc.text), // = new TextEditingController(text:prefs.getString("codDoc"));
// //                        Text('establecimiento: '+this.controller_estab.text), //= new TextEditingController(text: prefs.getString("estab"));
// //                        Text('pto Emision:  '+this.controller_ptoEmi.text), //= new TextEditingController(text: prefs.getString("ptoEmi"));
// //                        Text('secuencial : '+this.controller_secuencial.text), //= new TextEditingController(text: prefs.getString("secuencial"));
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 color: Colors.transparent,
//               ),
//               color: Colors.white,
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
//             child: Container(
//               //padding: EdgeInsets.all(10),
//               child: new Material(
//                 child: new InkWell(
//                   onTap: () {
//                     print("tapped");
// //                    Navigator.push(
// //                        context,
// //                        MaterialPageRoute(
// //                            builder: (context) =>
// //                                formDescripcion.FormDescripcion()));
//                   },
//                   child: Stack(
//                     children: <Widget>[
//                       //TITULO
//                       Container(
//                         //color: Colors.black26,
//                         width: double.infinity,
//                         height: 35.0,
//                         child: Center(
//                           child: Text(
//                             'Agregar descuento unitario',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(color: Colors.white, fontSize: 18),
//                           ),
//                         ),
//                       ),
//                       //PARA CONTENIDO
//                       Container(
//                         //height: 200.0,
//                         child: Column(
//                           children: <Widget>[
//                             Container(
//                               height: 35,
//                             ),

// //                        Text('Razon Social : '+this.controller.text),
// //                        Text('Ruc: '+this.controller_ruc.text), //= new TextEditingController(text: prefs.getString("ruc"));
// //                        Text('cod Doc : '+this.controller_codDoc.text), // = new TextEditingController(text:prefs.getString("codDoc"));
// //                        Text('establecimiento: '+this.controller_estab.text), //= new TextEditingController(text: prefs.getString("estab"));
// //                        Text('pto Emision:  '+this.controller_ptoEmi.text), //= new TextEditingController(text: prefs.getString("ptoEmi"));
// //                        Text('secuencial : '+this.controller_secuencial.text), //= new TextEditingController(text: prefs.getString("secuencial"));
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 color: Colors.transparent,
//               ),
//               color: Colors.redAccent,
//             ),
//           ),
// Padding(
//             padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
//             child: Container(
//               //padding: EdgeInsets.all(10),
//               child: new Material(
//                 child: new InkWell(
//                   onTap: () {
//                     // print("tapped");
//                     // Navigator.push(
//                     //     context,
//                     //     MaterialPageRoute(
//                     //         builder: (context) => formEmisor.FormEmisor()));
//                   },
//                   child: Stack(
//                     children: <Widget>[
//                       //TITULO
//                       Container(
//                         color: Colors.black54,
//                         width: double.infinity,
//                         height: 35.0,
//                         child: Center(
//                           child: Text(
//                             'Impuestos totales',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(color: Colors.white, fontSize: 18),
//                           ),
//                         ),
//                       ),
//                       //PARA CONTENIDO
//                       Container(
//                         //height: 200.0,
//                         child: Column(total
//                           children: <Widget>[
//                             Container(
//                               height: 35,
//                             ),
//                             Text(
//                               productoInfo.precioFinalTotal.toString()
//                               ,style: TextStyle(fontSize: 25),
//                               ),
// //                          Text('Ruc: ' +
// //                              this
// //                                  .controller_ruc
// //                                  .text), //= new TextEditingController(text: prefs.getString("ruc"));
// //                        Text('cod Doc : '+this.controller_codDoc.text), // = new TextEditingController(text:prefs.getString("codDoc"));
// //                        Text('establecimiento: '+this.controller_estab.text), //= new TextEditingController(text: prefs.getString("estab"));
// //                        Text('pto Emision:  '+this.controller_ptoEmi.text), //= new TextEditingController(text: prefs.getString("ptoEmi"));
// //                        Text('secuencial : '+this.controller_secuencial.text), //= new TextEditingController(text: prefs.getString("secuencial"));
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 color: Colors.transparent,
//               ),
//               color: Colors.white,
//             ),
//           ),
          Padding(
            padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
            child: Container(
              //padding: EdgeInsets.all(10),
              child: new Material(
                child: new InkWell(
                  onTap: () {
                    // print("tapped");
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => formEmisor.FormEmisor()));
                  },
                  child: Stack(
                    children: <Widget>[
                      //TITULO
                      Container(
                        color: Colors.black38,
                        width: double.infinity,
                        height: 35.0,
                        child: Center(
                          child: Text(
                            'Total',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      //PARA CONTENIDO
                      Container(
                        //height: 200.0,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 35,
                            ),
                            RaisedButton(
                                child: Text("Calcular Precio Total"),
                                onPressed: () {
                                  productoInfo
                                      .xml_controller_expanded.expanded = false;
                                  productoInfo.xml_enabler = true;
                                  double sinIm = 0;
                                  double conIm = 0;
                                  for (CartitaProducto i
                                      in productoInfo.productosDB) {
                                    if (i.activo) {
                                      sinIm += double.parse(i.finalPrecio.text);
                                      conIm += double.parse(
                                          i.totalPrecioConImpuesto.text);
                                    }
                                    print("sin impuesto  " + finalPrice.text);
                                    print("con impuesto  " +
                                        finalPriceConIM.text);
                                    this.finalPrice.text = sinIm.toString();
                                    this.finalPriceConIM.text = conIm.toString();
                                    productoInfo.xml_precio_final_sin_im = sinIm.toString();
                                    productoInfo.xml_precionfinalSin = sinIm.toString();
                                    productoInfo.xml_precionfinalCon = conIm.toString();
                                    productoInfo.xml_precio_final_con_im = conIm.toString();
                                  }
                                }),

                            // if (productoInfo.xml_enabler == true)
                            //   new Container(
                            //     height: 10,
                            //     color: Colors.blue,
                            //   )
                            // else
                            //   new Container(height: 10, color: Colors.red),
                            // Container(
                            //   width: 150,
                            //   child: TextField(
                            //     readOnly: true,
                            //     maxLines: 1,
                            //     controller: this.finalPrice,
                            //     keyboardType: TextInputType.number,
                            //     decoration: InputDecoration(
                            //         // border: InputBorder.,
                            //         hintText: 'Cantidad'),
                            //   ),
                            // ),
                            // Container(
                            //   width: 150,
                            //   child: TextField(
                            //     readOnly: true,
                            //     maxLines: 1,
                            //     controller: this.finalPriceConIM,
                            //     keyboardType: TextInputType.number,
                            //     decoration: InputDecoration(
                            //         // border: InputBorder.,
                            //         hintText: 'Cantidad'),
                            //   ),
                            // ),

                            // Text(
                            //   productoInfo.getprecioTotal()
                            //   ,style: TextStyle(fontSize: 25),
                            //   ),
//                          Text('Ruc: ' +
//                              this
//                                  .controller_ruc
//                                  .text), //= new TextEditingController(text: prefs.getString("ruc"));
//                        Text('cod Doc : '+this.controller_codDoc.text), // = new TextEditingController(text:prefs.getString("codDoc"));
//                        Text('establecimiento: '+this.controller_estab.text), //= new TextEditingController(text: prefs.getString("estab"));
//                        Text('pto Emision:  '+this.controller_ptoEmi.text), //= new TextEditingController(text: prefs.getString("ptoEmi"));
//                        Text('secuencial : '+this.controller_secuencial.text), //= new TextEditingController(text: prefs.getString("secuencial"));
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                color: Colors.transparent,
              ),
              color: Colors.white,
            ),
          ),
          // Text(productoInfo.xml_precionfinalSin),
          // Text(productoInfo.xml_precionfinalCon),
          ExpandablePanel(
            controller: productoInfo.xml_controller_expanded,
            header: null,
            collapsed: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Container(
                // height: 55,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("       Total sin impuesto :   "),
                        Container(
                          width: 150,
                          child: TextField(
                            readOnly: true,
                            maxLines: 1,
                            controller: this.finalPrice,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                // border: InputBorder.,
                                hintText: 'Cantidad'),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text("       Total con impuesto :   "),
                        Container(
                          width: 150,
                          child: TextField(
                            readOnly: true,
                            maxLines: 1,
                            controller: this.finalPriceConIM,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                // border: InputBorder.,
                                hintText: 'Cantidad'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            expanded: Container(
              child: Card(),
              height: 15,
              color: Colors.white,
            ),
            tapHeaderToExpand: false,
            hasIcon: false,
          )

          // TextField(controller: this.finalPriceSIN ,),
          // TextField(controller: this.finalPriceCON ,),
//        Padding(
//          padding: EdgeInsets.all(10),
//          child: Container(
//            //padding: EdgeInsets.all(10),
//            child: new Material(
//              child: new InkWell(
//                onTap: () {
//                  print("tapped");
//                },
//                child: new Container(
//                  //width: 400.0,
//                  height: 20.0,
//                ),
//              ),
//              color: Colors.transparent,
//            ),
//            color: Colors.orange,
//          ),
//        )
        ],
      ),
      //color: Colors.black,
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
