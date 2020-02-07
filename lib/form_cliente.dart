import 'package:card_settings/card_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'provider_productos.dart';
import 'singleton_formulario_actual.dart' as singleton;

class FormCliente extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FormClienteState();
  }
}

//class MyHomePage extends StatelessWidget {
class _FormClienteState extends State<FormCliente> with AutomaticKeepAliveClientMixin<FormCliente>{
  //final String title;
  @override
  void initState() {
    super.initState();
    // final productoInfo = Provider.of<ProductosArrayInfo>(context);
    // this.controller_razonSocial.text = productoInfo.cliente_razonSocial;
    // this.controller_email.text = productoInfo.cliente_email;
    // this.controller_direccion.text = productoInfo.cliente_direccion;
    // this.controller_contabilidad.text = productoInfo.cliente_contabilidad;
    // this.controller_tipoIdentificacion.text =
    //     productoInfo.cliente_tipoIdentificacion;
    // this.controller_ruc.text = productoInfo.cliente_identificacion;

    // getSharedPrefs();
  }

  // Future<Null> getSharedPrefs() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   this.razonSocial = prefs.getString("razonSocial");
  //   this.razonSocial = prefs.getString("ruc");
  //   this.razonSocial = prefs.getString("codDoc");
  //   this.razonSocial = prefs.getString("estab");
  //   this.razonSocial = prefs.getString("ptoEmi");
  //   this.razonSocial = prefs.getString("secuencial");
  //   setState(() {
  //     this.controller = new TextEditingController(text: prefs.getString("razonSocial"));
  //     this.controller_ruc = new TextEditingController(text: prefs.getString("ruc"));
  //     this.controller_codDoc = new TextEditingController(text:prefs.getString("codDoc"));
  //     this.controller_estab = new TextEditingController(text: prefs.getString("estab"));
  //     this.controller_ptoEmi = new TextEditingController(text: prefs.getString("ptoEmi"));
  //     this.controller_secuencial = new TextEditingController(text: prefs.getString("secuencial"));
  //   });
  // }

/*
  Future<void> updateStartup() async{
    //final pref = await SharedPreferences.getInstance();
    String lastString = await getRazonSocial();
    setState(() {
      this.razonSocial = lastString;
    });
  }
*/
  // final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  //MyHomePage({Key key, this.title}) : super(key: key);
  String dropdownValue = 'One';
  // String title = "Spheria";
  // String author = "Cody Leet";
  // String url = "http://www.codyleet.com/spheria";

 
  String razonSocial = '';
  String email = '';
  String direccion = '';
  String contabilidad = '';
  String tipoIdentificacion = '';
  String identificacion = '';

  TextEditingController controller_razonSocial = TextEditingController();
  TextEditingController controller_direccion = TextEditingController();
  TextEditingController controller_ruc = TextEditingController();
  TextEditingController controller_contabilidad = TextEditingController();
  TextEditingController controller_tipoIdentificacion = TextEditingController();
  TextEditingController controller_email = TextEditingController();
/*
  Future<bool> saveData() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await  preferences.setString('razonSocial', controller.text);

  }

  Future<String>  loadData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('razonSocial');
  }
*/
// String razonSocial ='';
  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(),
    );
  }
  // _inicializaVariables() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   this.ambiente = (prefs.getString('ambiente')); //+ 1;
  //   this.tipoEmision = (prefs.getString('tipoEmision')); //+ 1;
  //   this.razonSocial = (prefs.getString('razonSocial')); //+ 1;
  //   this.ruc = (prefs.getString('ruc')); //+ 1;
  //   this.claveAcceso = (prefs.getString('claveAcceso')); //+ 1;
  //   this.codDoc = (prefs.getString('codDoc')); //+ 1;
  //   this.estab = (prefs.getString('estab')); //+ 1;
  //   this.ptoEmi = (prefs.getString('ptoEmi')); //+ 1;
  //   this.secuencial = (prefs.getString('secuencial')); //+ 1;
  //   this.dirMatriz = (prefs.getString('dirMatriz')); //+ 1;
  //   //print('Pressed $counter times.');
  //   //await prefs.setString(identificador, counter);
  // }

  /*
  Future<String> getRazonSocial() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String temp = (prefs.getString('razonSocial')); //+ 1;
    print ('futuro : ' + temp);
    return temp;
  }*/
  //PDFDocument doc = await PDFDocument.fromURL('http://www.africau.edu/images/default/sample.pdf');

  @override
  Widget build(BuildContext context) {
    final productoInfo = Provider.of<ProductosArrayInfo>(context);

    // this.controller_razonSocial.text = productoInfo.cliente_razonSocial;
    // this.controller_email.text = productoInfo.cliente_email;
    // this.controller_direccion.text = productoInfo.cliente_direccion;
    // this.controller_contabilidad.text = productoInfo.cliente_contabilidad;
    // this.controller_tipoIdentificacion.text =
    //     productoInfo.cliente_tipoIdentificacion;
    // this.controller_ruc.text = productoInfo.cliente_identificacion;

    // var _ponyModel= 22;
    //obtiene
    // _inicializaVariables();
    // setState(() {
    //   // this._inicializaVariables();
    // });
    // singleton.MyXmlSingleton().inicializaVariables();
    return Scaffold(
      body: Form(autovalidate: true,
     
        onChanged: (() {
      
        }),
        //key: _formKey,
        child: CardSettings(
          //cardElevation: 67,
          children: <Widget>[
            CardSettingsHeader(
              labelAlign: TextAlign.center,
              label: 'Datos del Cliente',
              color: Colors.blueAccent,
            ),
//            CardSettingsListPicker(contentAlign: TextAlign.center,
//              values: ['dad','dad'],
//              //hintText: 'ada',
//              initialValue: 'None',
//              label: 'Ambiente',
//
//              options: ['Prueba','Produccion'],
//              onChanged: ((value){
//                print (value);
//              }),
//            ),
//            CardSettingsListPicker(contentAlign: TextAlign.center,
//              values: ['01','02','03'],
//              validator: (String value) {
//                if (value == null || value.isEmpty) return 'You must pick a type.';
//                return null;
//              },
//              key: this._fbKey,
//              hintText: 'Select One',
//              autovalidate: true,
//              initialValue: 'daa',
//              label: 'Tipo Emision',
//              showMaterialonIOS: true,
//              options: ['nota de credito','factura','sin cargo'],
//              onChanged: ((value){
//                print (value);
//              }),
//            ),
            CardSettingsText(
              hintText: 'test',
              //hintText: 'ayua',
              // controller: this.controller_razonSocial,
              labelWidth: 150,
              label: 'Razon Social',
              initialValue: productoInfo.cliente_razonSocial,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Title is required.';
              },
              // onSaved: (value) => print('dadsadddddd'),
              onChanged: ((value) {
                this.razonSocial= value;
                productoInfo.cliente_razonSocial=this.razonSocial;

                print('dasdadsddddd');
              }),
            ),
            CardSettingsText(
              hintText: 'editar email',
              // controller: controller_razonSocial,
              labelWidth: 150,
              label: 'Razon Social',
              initialValue: productoInfo.cliente_email,
              // validator: (value) {
              //   // if (value == null || value.isEmpty) return 'Title is required.';
              // },
              //onSaved: (value) => print ('dadsadddddd'),
              onChanged: ((value) {
                this.email = value;
                productoInfo.cliente_email=this.email;
              }),
            ),
            CardSettingsText(
              hintText: "editar direccion",
              // controller: controller_direccion,
              labelWidth: 150,
              label: 'Direccion',
              initialValue: productoInfo.cliente_direccion,
              validator: (value) {
                // if (!value.startsWith('http:')) return 'Must be a valid website.';
              },
              // onSaved: (value) => url = value,
              onChanged: ((value) {
                // setState(() {
                  this.direccion = value;
                  productoInfo.cliente_direccion=this.direccion;
                // });
              }),
            ),
            // CardSettingsText(
             
            CardSettingsText(
              // controller: controller_ruc,
              labelWidth: 150,
              label: 'identificacion',
              initialValue: productoInfo.cliente_identificacion,
              validator: (value) {
                // if (!value.startsWith('http:')) return 'Must be a valid website.';
              },
              // onSaved: (value) => url = value,
              onChanged: ((value) {
                this.identificacion= value;
                productoInfo.cliente_identificacion = this.identificacion;
              }),
            ),
            CardSettingsText(
              // controller: controller_tipoIdentificacion,
              labelWidth: 150,
              label: 'tipo identificacion',
              initialValue: productoInfo.cliente_tipoIdentificacion,

              // validator: (value) {
              //   // if (!value.startsWith('http:')) return 'Must be a valid website.';
              // },
              // onSaved: (value) => url = value,
              onChanged: ((value) {
                // setState(() {
                this.tipoIdentificacion = value;
                productoInfo.cliente_tipoIdentificacion = this.tipoIdentificacion;
                // });
              }),
            ),

//            CardSettingsText(controller: controller_codDoc,
//              labelWidth: 150,
//              label: 'Cod Documentario',
//              initialValue: 'Editar estado',
//              validator: (value) {
//                if (!value.startsWith('http:')) return 'Must be a valid website.';
//              },
//              onSaved: (value) => url = value,
//            ),
//            CardSettingsText(controller: controller_estab,
//              hintText: 'ndjka',labelWidth: 150,
//              label: 'Establecimiento',
//              //initialValue: 'Editar tipo identificacion',
//              validator: (value) {
//                if (!value.startsWith('http:')) return 'Must be a valid website.';
//              },
//              onSaved: (value) => url = value,
//            ),
//            CardSettingsText(controller: controller_ptoEmi,
//              labelWidth: 150,
//              label: 'Pto Emision',
//              //initialValue: 'Editar razon social',
//              validator: (value) {
//                if (!value.startsWith('http:')) return 'Must be a valid website.';
//              },
//              onSaved: (value) => url = value,
//            ),
//            CardSettingsText(controller: controller_secuencial,
//              labelWidth: 150,
//              label: 'Secuencial',
//              //initialValue: 'Editar identificacion',
//              validator: (value) {
//                if (!value.startsWith('http:')) return 'Must be a valid website.';
//              },
//              onSaved: (value) => url = value,
//            ),

            //fullpdfview.MyApp(),
/*
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
*/
          ],
        ),
      ),

      /*
      floatingActionButton: FloatingActionButton(
        // When the user presses the button, show an alert dialog containing the
        // text that the user has entered into the text field.
        onPressed: () {


        },
        tooltip: 'Show me the value!',
        child: Icon(Icons.add),
      ),


      */
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.45, //20.0,,
        child: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            //physics: const NeverScrollableScrollPhysics(),
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Stack(
                  children: <Widget>[
                    Center(
                        child:
                            Container(height: 120, color: Colors.blueAccent)),
                    Center(
                      child: Text(
                        'Menu',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(Icons.monetization_on),
                    Text(
                      'Nueva Factura',
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  //Navigator.pop(context);
                  //Navigator.push(
                  //  context,
                  //   MaterialPageRoute(builder: (context) =>
                  //       FacturaPage()
                  //   ) );
                },
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Container(
                      //

                      height: 40,
                      width: 150,
                      color: Colors.white60,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.send),
                          Text(
                            'Reenviar factura',
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  //Navigator.pop(context);
                  /*
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          FacturaPage()
                      ) );*/
                },
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(Icons.storage),
                    Text(
                      'Facturas emitidas',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  //Navigator.pop(context);
                  /*Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          pasadas.FacturasPasadas()
                      ) );*/
                },
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(Icons.person),
                    Text(
                      'Clientes',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  //Navigator.pop(context);
                  /*
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          FacturaPage()
                      ) );*/
                },
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(Icons.book),
                    Text(
                      'Productos',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  //Navigator.pop(context);
                },
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(Icons.share),
                    Text(
                      'VPN',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  //Navigator.pop(context);
                },
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(Icons.settings),
                    Text(
                      'Ajustes',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  //Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
