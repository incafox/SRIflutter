import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_final_sri/docume.dart';
import 'package:flutter_final_sri/productosJson.dart';
import 'package:flutter_final_sri/provider_productos.dart';
import 'package:flutter_final_sri/reenviarFactura.dart';
import 'package:flutter_final_sri/screens/login_screen.dart';
// import 'package:flutter_final_sri/transition_route_observer.dart';
import 'package:flutter_final_sri/vpn.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:provider/provider.dart';
import 'factura.dart';
import 'file_picker_helper.dart' as filepick;
import 'pdfgenerator.dart';
import 'facturas_pasadas.dart' as pasadas;
import 'package:card_settings/card_settings.dart';
import 'singleton_formulario_actual.dart' as singleton;
import 'package:shared_preferences/shared_preferences.dart';
import 'full_pdf_view.dart' as fullpdfview;
// import 'package:flutter_login/flutter_login.dart';
// import 'dashboard_screen.dart';
import 'form_emisor.dart' as formEmisor;
// import 'login_screen.dart';


//formularios

// void main() => runApp(MyApp());
// void main() => runApp(MyAppxxx());
void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor:
          SystemUiOverlayStyle.dark.systemNavigationBarColor,
    ),
  );
  runApp(MyAppx());

}

class MyAppx extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductosArrayInfo(),
          child: MaterialApp(
        title: 'Flutter Login UI',
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      ),
    );
  }
}
class MyApp extends StatelessWidget {
//class _MyApp extends State<MyApp> {

  final appTitle = 'FACTURA ELECTRONICA';
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductosArrayInfo(),
      child: MaterialApp(
        title: appTitle,
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createStatek
    return _MyHomePageState();
  }
}

//class MyHomePage extends StatelessWidget {
class _MyHomePageState extends State<MyHomePage> {
  //final String title;
  @override
  void initState() {
    super.initState();

    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.razonSocial = prefs.getString("razonSocial");
    this.razonSocial = prefs.getString("ruc");
    this.razonSocial = prefs.getString("codDoc");
    this.razonSocial = prefs.getString("estab");
    this.razonSocial = prefs.getString("ptoEmi");
    this.razonSocial = prefs.getString("secuencial");
    setState(() {
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

/*
  Future<void> updateStartup() async{
    //final pref = await SharedPreferences.getInstance();
    String lastString = await getRazonSocial();
    setState(() {
      this.razonSocial = lastString;
    });
  }
*/
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  //MyHomePage({Key key, this.title}) : super(key: key);
  String dropdownValue = 'One';
  String title = "Spheria";
  String author = "Cody Leet";
  String url = "http://www.codyleet.com/spheria";

  //todo:ESTOS VAN PARA SHARED
  String ambiente = '';
  String tipoEmision = '';
  String razonSocial = '';
  String ruc = '';
  String claveAcceso = '';
  String codDoc = '';
  String estab = '';
  String ptoEmi = '';
  String secuencial = '';
  String dirMatriz = '';

  TextEditingController controller = TextEditingController();
  TextEditingController controller_ambiente = TextEditingController();
  TextEditingController controller_ruc = TextEditingController();
  TextEditingController controller_tipoEmision = TextEditingController();
  TextEditingController controller_estab = TextEditingController();
  TextEditingController controller_ptoEmi = TextEditingController();
  TextEditingController controller_secuencial = TextEditingController();
  TextEditingController controller_codDoc = TextEditingController();
  TextEditingController controller_claveAcceso = TextEditingController();
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
  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(),
    );
  }

  _inicializaVariables() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.ambiente = (prefs.getString('ambiente')); //+ 1;
    this.tipoEmision = (prefs.getString('tipoEmision')); //+ 1;
    this.razonSocial = (prefs.getString('razonSocial')); //+ 1;
    this.ruc = (prefs.getString('ruc')); //+ 1;
    this.claveAcceso = (prefs.getString('claveAcceso')); //+ 1;
    this.codDoc = (prefs.getString('codDoc')); //+ 1;
    this.estab = (prefs.getString('estab')); //+ 1;
    this.ptoEmi = (prefs.getString('ptoEmi')); //+ 1;
    this.secuencial = (prefs.getString('secuencial')); //+ 1;
    this.dirMatriz = (prefs.getString('dirMatriz')); //+ 1;
    //print('Pressed $counter times.');
    //await prefs.setString(identificador, counter);
  }

  /*
  Future<String> getRazonSocial() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String temp = (prefs.getString('razonSocial')); //+ 1;
    print ('futuro : ' + temp)
    return temp;
  }*/
  //PDFDocument doc = await PDFDocument.fromURL('http://www.africau.edu/images/default/sample.pdf');

  @override
  Widget build(BuildContext context) {
    var _ponyModel = 22;
    //obtiene
    _inicializaVariables();
    setState(() {
      this._inicializaVariables();
    });
    singleton.MyXmlSingleton().inicializaVariables();
    return Scaffold(
      appBar: AppBar(
          //backgroundColor: Colors.blueAccent,
          title: Text(
        'Innova SG.',
        textAlign: TextAlign.right,
      )),
      body: formEmisor.FormEmisor(),
//      Form(onChanged: (()async{
//        SharedPreferences pref  = await SharedPreferences.getInstance();
//        pref.setString('razonSocial',this.controller.text);
//        pref.setString('ruc',this.controller_ruc.text);
//        pref.setString('codDoc',this.controller_codDoc.text);
//        pref.setString('estab',this.controller_estab.text);
//        pref.setString('ptoEmi',this.controller_ptoEmi.text);
//        pref.setString('secuencial',this.controller_secuencial.text);
//        //print ('sadsa');
//
//      }),
//        //key: _formKey,
//        child: CardSettings( //cardElevation: 67,
//          children: <Widget>[
//            CardSettingsHeader(
//              labelAlign: TextAlign.center,
//              label: 'Datos de Emisor',
//              color: Colors.blueAccent,
//
//            ),
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
//            CardSettingsText(hintText: 'sadad',
//              //hintText: 'ayua',
//              controller: controller,
//              labelWidth: 150,
//              label: 'Razon Social',
//              initialValue: title,
//              validator: (value) {
//                if (value == null || value.isEmpty) return 'Title is required.';
//              },
//              onSaved: (value) => print ('dadsadddddd'),
//              onChanged: ((value) {
//                print ('dasdadsddddd');
//
//              }),
//            ),
//            CardSettingsText(
//            controller: controller_ruc,
//              labelWidth: 150,
//              label: 'Ruc',
//              initialValue: 'Editar direccion',
//              validator: (value) {
//                if (!value.startsWith('http:')) return 'Must be a valid website.';
//              },
//              onSaved: (value) => url = value,
//              onChanged: ((value){
//                setState(() {
//
//                });
//              }),
//            ),
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
//
//            //fullpdfview.MyApp(),
      ///*
//            Padding(
//              padding: EdgeInsets.all(20.0),
//              child: RaisedButton(
//                shape: new RoundedRectangleBorder(
//                    borderRadius: new BorderRadius.circular(18.0),
//                    side: BorderSide(color: Colors.red)),
//                onPressed: () {
//
//                  //mediante funcion de otro .dart con parametros todos los datos de
//                  //del form, generar el xml, codificar y enviar
//                },
//                color: Colors.red,
//                textColor: Colors.white,
//                child: Text("Debug".toUpperCase(),
//                    style: TextStyle(fontSize: 17)),
//              ),
//            ),
//*/
//
//          ],
//        ),
//      ),

      floatingActionButton: FloatingActionButton(
        // When the user presses the button, show an alert dialog containing the
        // text that the user has entered into the text field.
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => FacturaPage()));
          /*return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // Retrieve the text the user has entered by using the
            // TextEditingController.
            content: Text(singleton.MyXmlSingleton().forDebug.text),
          );
        },
      );*/
        },
        tooltip: 'Show me the value!',
        child: Icon(Icons.add),
      ),
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
                child:
                SizedBox(height: 310,child: Image.asset("assets/log.jpg")),
                // Image.network(
                //                 "https://library.kissclipart.com/20181105/vq/kissclipart-invoice-logo-clipart-invoice-logo-586f857303eb3ebc.png"),
                               
                // Stack(
                //   children: <Widget>[
                //     Center(
                //         child: Container(
                //             child: Image.network(
                //                 "https://library.kissclipart.com/20181105/vq/kissclipart-invoice-logo-clipart-invoice-logo-586f857303eb3ebc.png"),
                //             width: 190,
                //             height: 190,
                //             color: Colors.white)),
                //   ],
                // ),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FacturaPage()));
                },
              ),
              Divider(
                height: 3,
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          ReenviarPage()
                      ) );
                },
              ),
              Divider(
                height: 3,
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
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => pasadas.FacturasPasadas()));
                },
              ),
              Divider(
                height: 3,
              ),
              // ListTile(
              //   title: Row(
              //     children: <Widget>[
              //       Icon(Icons.person_add),
              //       Text(
              //         'Registrar Cliente',
              //         textAlign: TextAlign.center,
              //       ),
              //     ],
              //   ),
              //   onTap: () {
              //     // Update the state of the app
              //     // ...
              //     // Then close the drawer
              //     Navigator.pop(context);
              //      Navigator.push(context,
              //          MaterialPageRoute(builder: (context) => documeJson()));
              //   },
              // ),
              Divider(
                height: 3,
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
                  Navigator.pop(context);
                   Navigator.push(context,
                       MaterialPageRoute(builder: (context) => ProductosJsonSearchPage()));
                },
              ),
//              Divider(
//                height: 3,
//              ),
//              ListTile(
//                title: Row(
//                  children: <Widget>[
//                    Icon(Icons.share),
//                    Text(
//                      'VPN',
//                      textAlign: TextAlign.center,
//                    ),
//                  ],
//                ),
//                onTap: () {
//                  // Update the state of the app
//                  // ...
//                  // Then close the drawer
//                  // Navigator.pop(context);
//                  Navigator.push(context,
//                      MaterialPageRoute(builder: (context) => VPNPage()));
//                },
//              ),
              Divider(
                height: 3,
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(Icons.settings),
                    Text(
                      'SRI ',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  //Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              filepick.FilePickerDemo() ));
                              //FacturaPage()
                              //fullpdfview.MyAppx()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NewScreen();
  }
}

class _NewScreen extends State<NewScreen> {
  /*
  const NewScreen({
    Key key,
    //@required this.color,
    //@required this.name,
  }) : super(key: key);
*/
  //final Color color;
  //final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: RaisedButton.icon(
          icon: Icon(Icons.arrow_right),
          label: Text("Push to Screen"),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => Scaffold(
                appBar: AppBar(),
                body: NewScreen(),
              ),
            ));
          },
        ),
      ),
    );
  }
}
