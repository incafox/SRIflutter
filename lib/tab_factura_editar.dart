import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'factura.dart' as factura;
import 'form_emisor.dart' as formEmisor;
import 'form_cliente.dart' as formCliente;
import 'form_descripcion.dart' as formDescripcion;

//todo : cambiar a statefull
class TabFacturaEditar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TabFacturaEditarState();
  }
}

//class MyHomePage extends StatelessWidget {
class _TabFacturaEditarState extends State<TabFacturaEditar> {
  //final String title;
  @override
  void initState() {
    super.initState();
    getSharedPrefs();

  }

//class TabFacturaEditar extends StatelessWidget {
  /*
  const ScreenEditar({
    Key key,
    @required this.color,
    @required this.name,
  }) : super(key: key);
*/

  TextEditingController controller = TextEditingController();
  TextEditingController controller_ambiente = TextEditingController();
  TextEditingController controller_ruc = TextEditingController();
  TextEditingController controller_tipoEmision = TextEditingController();
  TextEditingController controller_estab = TextEditingController();
  TextEditingController controller_ptoEmi = TextEditingController();
  TextEditingController controller_secuencial = TextEditingController();
  TextEditingController controller_codDoc = TextEditingController();
  TextEditingController controller_claveAcceso = TextEditingController();

//  Future<Null> getSharedPrefs() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
////
////    this.razonSocial = prefs.getString("razonSocial");
////    this.razonSocial = prefs.getString("ruc");
////    this.razonSocial = prefs.getString("codDoc");
////    this.razonSocial = prefs.getString("estab");
////    this.razonSocial = prefs.getString("ptoEmi");
////    this.razonSocial = prefs.getString("secuencial");
////    //setState(() {
//      this.controller = new TextEditingController(text: prefs.getString("razonSocial"));
//      this.controller_ruc = new TextEditingController(text: prefs.getString("ruc"));
//      this.controller_codDoc = new TextEditingController(text:prefs.getString("codDoc"));
//      this.controller_estab = new TextEditingController(text: prefs.getString("estab"));
//      this.controller_ptoEmi = new TextEditingController(text: prefs.getString("ptoEmi"));
//      this.controller_secuencial = new TextEditingController(text: prefs.getString("secuencial"));
//    //});
//  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      this.controller =
          new TextEditingController(text: prefs.getString("razonSocial"));
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
    });
  }

  //SharedPreferences pref = new SharedPreferences.getInstance();
  @override
  Widget build(BuildContext context) {
    //this.getSharedPrefs();
    return Container(
      color: Colors.black12,
      child: ListView(
        children: <Widget>[
          Padding(
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
                        color: Colors.black54,
                        width: double.infinity,
                        height: 35.0,
                        child: Center(
                          child: Text(
                            'Datos Emisor',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 18),
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
                              height: 35,
                            ),

                            Container(
                              width: double.infinity,
                              child: SafeArea(
                                child: Text(
                                  '\nRazon Social:' + this.controller.text+ "\n"+'Ruc\t\t\t\t\t\t\t:' +
                                      this.controller_ruc.text + '\ncod Doc               :' +
                                      this.controller_codDoc.text,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ), // = new TextEditingController(text:prefs.getString("codDoc"));
                            Container(
                              child: Text('establecimiento :' +
                                  this.controller_estab.text),
                              width: double.infinity,
                            ), //= new TextEditingController(text: prefs.getString("estab"));
                            Container(
                              child: Text('pto Emision         :' +
                                  this.controller_ptoEmi.text),
                              width: double.infinity,
                            ), //= new TextEditingController(text: prefs.getString("ptoEmi"));
//                          Container(
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
          Padding(
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
                            builder: (context) => formCliente.FormCliente()));
                  },
                  child: Stack(
                    children: <Widget>[
                      //TITULO
                      Container(
                        color: Colors.black54,
                        width: double.infinity,
                        height: 35.0,
                        child: Center(
                          child: Text(
                            'Datos Cliente',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 18),
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
                            Container(
                              width: double.infinity,
                              child:
                                  Text('Razon Social :' + this.controller.text),
                            ),
                            Container(
                                width: double.infinity,
                                child: Text('Ruc                  :' +
                                    this.controller_ruc.text)),
                            //= new TextEditingController(text: prefs.getString("ruc"));
                            //Text('cod Doc : '+this.controller_codDoc.text), // = new TextEditingController(text:prefs.getString("codDoc"));
                            //Text('establecimiento: '+this.controller_estab.text), //= new TextEditingController(text: prefs.getString("estab"));
                            //Text('pto Emision:  '+this.controller_ptoEmi.text), //= new TextEditingController(text: prefs.getString("ptoEmi"));
                            //Text('secuencial : '+this.controller_secuencial.text), //= new TextEditingController(text: prefs.getString("secuencial"));
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
          Padding(
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
                            builder: (context) =>
                                formDescripcion.FormDescripcion()));
                  },
                  child: Stack(
                    children: <Widget>[
                      //TITULO
                      Container(
                        color: Colors.black54,
                        width: double.infinity,
                        height: 35.0,
                        child: Center(
                          child: Text(
                            'Descripcion y Conceptos',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 18),
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

//                          Text('Razon Social : ' + this.controller.text),
////                          Text('Ruc: ' +
//                              this
//                                  .controller_ruc
//                                  .text), //= new TextEditingController(text: prefs.getString("ruc"));
//                          Text('cod Doc : ' +
//                              this
//                                  .controller_codDoc
//                                  .text), // = new TextEditingController(text:prefs.getString("codDoc"));
//                          Text('establecimiento: ' +
//                              this
//                                  .controller_estab
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
          Padding(
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
                            builder: (context) =>
                                formDescripcion.FormDescripcion()));
                  },
                  child: Stack(
                    children: <Widget>[
                      //TITULO
                      Container(
                        //color: Colors.black26,
                        width: double.infinity,
                        height: 35.0,
                        child: Center(
                          child: Text(
                            'Agregar producto',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 18),
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

//                        Text('Razon Social : '+this.controller.text),
//                        Text('Ruc: '+this.controller_ruc.text), //= new TextEditingController(text: prefs.getString("ruc"));
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
              color: Colors.redAccent,
            ),
          ),
          Padding(
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
                        color: Colors.black54,
                        width: double.infinity,
                        height: 35.0,
                        child: Center(
                          child: Text(
                            'Descuentos',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 18),
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
                            Container(
                              width: double.infinity,
                              child: Text(
                                  'Razon Social : ' + this.controller.text),
                            ),
                            Container(
                              child: Text('Ruc: ' + this.controller_ruc.text),
                              width: double.infinity,
                            ),
                            //= new TextEditingController(text: prefs.getString("ruc"));
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
          Padding(
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
                            builder: (context) =>
                                formDescripcion.FormDescripcion()));
                  },
                  child: Stack(
                    children: <Widget>[
                      //TITULO
                      Container(
                        //color: Colors.black26,
                        width: double.infinity,
                        height: 35.0,
                        child: Center(
                          child: Text(
                            'Agregar descuento unitario',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 18),
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

//                        Text('Razon Social : '+this.controller.text),
//                        Text('Ruc: '+this.controller_ruc.text), //= new TextEditingController(text: prefs.getString("ruc"));
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
              color: Colors.redAccent,
            ),
          ),
          Padding(
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
                        color: Colors.black54,
                        width: double.infinity,
                        height: 35.0,
                        child: Center(
                          child: Text(
                            'Total',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 18),
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

                            Text(' Total '),
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
}
