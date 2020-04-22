
//import 'dart:html';

import 'package:card_settings/card_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final_sri/file_picker_helper.dart';
import 'package:flutter_final_sri/provider_productos.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'singleton_formulario_actual.dart' as singleton;
class FormEmisor extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _FormEmisorState();
  }
}

//class MyHomePage extends StatelessWidget {
class _FormEmisorState extends State<FormEmisor> {
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
      this.controller = new TextEditingController(text: prefs.getString("razonSocial"));
      this.controller_ruc = new TextEditingController(text: prefs.getString("ruc"));
      this.controller_codDoc = new TextEditingController(text:prefs.getString("codDoc"));
      this.controller_estab = new TextEditingController(text: prefs.getString("estab"));
      this.controller_ptoEmi = new TextEditingController(text: prefs.getString("ptoEmi"));
      this.controller_dirMatriz = new TextEditingController(text: prefs.getString("dirMatriz"));
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
  // final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  //MyHomePage({Key key, this.title}) : super(key: key);
  String dropdownValue = 'One';
  String title = "Spheria";
  String author = "Cody Leet";
  String url = "http://www.codyleet.com/spheria";

  //todo:ESTOS VAN PARA SHARED
  String ambiente = '';
  String tipoEmision = '';
  String razonSocial= '';
  String ruc= '';
  String claveAcceso= '';
  String codDoc= '';
  String estab= '';
  String ptoEmi= '';
  String secuencial= '';
  String dirMatriz= '';

  TextEditingController controller = TextEditingController();
  TextEditingController controller_ambiente = TextEditingController();
  TextEditingController controller_ruc = TextEditingController();
  TextEditingController controller_tipoEmision = TextEditingController();
  TextEditingController controller_estab = TextEditingController();
  TextEditingController controller_ptoEmi = TextEditingController();
  TextEditingController controller_claveAcceso = TextEditingController();
  TextEditingController controller_codDoc = TextEditingController();
  TextEditingController controller_dirMatriz = TextEditingController();

  
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

  @override
  Widget build(BuildContext context){
    final productoInfo=Provider.of<ProductosArrayInfo>(context);
    this.controller.text = productoInfo.xml_razonSocial;
    this.controller_ambiente.text = productoInfo.xml_ambiente;
    this.controller_ruc.text = productoInfo.xml_ruc;
    this.controller_codDoc.text= productoInfo.xml_codDoc;
    this.controller_dirMatriz.text=productoInfo.xml_dirMatriz;
    this.controller_tipoEmision.text=productoInfo.xml_tipoEmision;
    this.controller_estab.text=productoInfo.xml_estab;
    this.controller_ptoEmi.text=productoInfo.xml_ptoEmi;
    print('desde emisor form');
    print(productoInfo.xml_ruc);
    var _ponyModel= 22;
    // final productoInfo=Provider.of<ProductosArrayInfo>(context);
    //obtiene
    // _inicializaVariables();
    // setState(() {
    //   this._inicializaVariables();
    // });
    singleton.MyXmlSingleton().inicializaVariables();
    return Scaffold(
      body:

      Form(onChanged: (()async{




        // SharedPreferences pref  = await SharedPreferences.getInstance();
        // pref.setString('razonSocial',this.controller.text);
        // pref.setString('tipoEmision',this.controller_ambiente.text); // unico
        // pref.setString('ruc',this.controller_ruc.text);
        // pref.setString('codDoc',this.controller_codDoc.text);
        // pref.setString('estab',this.controller_estab.text);
        // pref.setString('ptoEmi',this.controller_ptoEmi.text);
        // pref.setString('dirMatriz',this.controller_dirMatriz.text);

        
        //this.controller_ambiente.text;
        // productoInfo.tipoEmision= this.controller_tipoEmision.text;
        // productoInfo.razonSocial = this.controller.text;
        // productoInfo.ruc = this.controller_ruc.text;
        // productoInfo.codDoc = this.controller_codDoc.text;
        // productoInfo.estab = this.controller_estab.text;
        // productoInfo.ptoEmi = this.controller_ptoEmi.text;
        // productoInfo.dirMatriz = this.controller_dirMatriz.text;

        // print ("[cnotroller ]" + this.controller_ambiente.text);
        //print ( productoInfo.ambiente);


        //print ('sadsa');
      }),
        //key: _formKey,
        child: CardSettings( //cardElevation: 67,
          children: <Widget>[
            CardSettingsHeader(
              labelAlign: TextAlign.center,
              label: 'Datos de Emisor',
              color: Colors.blue,

            ),
            // CardSettingsListPicker(contentAlign: TextAlign.center,
            //   values: ['1','2'],
            //   //hintText: 'ada',
            //   //hintText: 'Seleccione',
            //   label: 'Ambiente',
            //   initialValue: '1',
            //   options: ['Prueba','Produccion'],
            //   onChanged: ((value) async{
            //       print ('[valor] ' +value);
            //       SharedPreferences prefs = await SharedPreferences.getInstance();
            //       switch (int.parse(value)) {
            //         case 1:
            //         productoInfo.ambiente = 'prueba';
            //             prefs.setString('ambiente', 'prueba');
            //           break;
            //         case 2:
            //         productoInfo.ambiente = 'produccion';
            //             prefs.setString('ambiente', 'produccion');
            //           break;
            //         default:
            //       }
            //       //prefs.setString('ambiente', value);
            //   }),
            // ),
            CardSettingsText(hintText: 'sadad',
              //hintText: 'ayua',
              // controller: controller,
              labelWidth: 150,
              label: 'Ambiente',
              initialValue: this.controller_ambiente.text,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Title is required.';
              },
              onSaved: (value) => print ('dadsadddddd'),
              onChanged: ((value) {
                // print ('dasdadsddddd');

              }),
            ),
            // CardSettingsListPicker(contentAlign: TextAlign.center,
            //   values: ['1','2'],
            //   //hintText: 'ada',
            //   hintText: 'Seleccione',
            //   label: 'Tipo Emision',
            //   initialValue: 'Prueba',
            //   options: ['Prueba','Produccion'],
            //   onChanged: ((value) async{
            //     //print (value);
            //     SharedPreferences prefs = await SharedPreferences.getInstance();
            //     prefs.setString('tipoEmision', value);
            //   }),
            // ),
            CardSettingsText(hintText: 'sadad',
              //hintText: 'ayua',
              controller: controller,
              labelWidth: 150,
              label: 'Tipo de emision',
              initialValue: title,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Title is required.';
              },
              onSaved: (value) => print ('dadsadddddd'),
              onChanged: ((value) {
                print ('dasdadsddddd');

              }),
            ),
            CardSettingsText(
              enabled: false,
              // ,hintText: 'sadad',
              //hintText: 'ayua',
              controller: this.controller,
              labelWidth: 150,
              label: 'Razon Social',
              initialValue: productoInfo.xml_razonSocial,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Title is required.';
              },
              onSaved: (value) => print ('dadsadddddd'),
              onChanged: ((value) {
                // print ('dasdadsddddd');

              }),
            ),
            CardSettingsText(
              controller: controller_ruc,
              keyboardType: TextInputType.numberWithOptions(),

              maxLength: 13,
              autovalidate: true,
              labelWidth: 150,
              label: 'Ruc',
              initialValue: productoInfo.xml_ruc,
              // hintText: 'ruc 13 digitos',
              validator: (value) {
                try{
                  if (value.length>13) return 'Ruc es de 13 numeros';
                }
                catch(e){
                  print ('faf');
                }

              },
              onSaved: (value) => url = value,
              onChanged: ((value){
                print(value);
                setState(() {

                });
              }),
            ),
            // CardSettingsListPicker(
            //   contentAlign: TextAlign.center,
            //   values: ['01','03','04','05','06','07'],
            //   //hintText: 'ada',
            //   hintText: 'Factura',
            //   label: 'Codigo Doc',
            //   initialValue: 'Prueba',
            //   options: ['Factura','Liquidacion', 'Nota de credito'
            //     , 'Nota de debito','Guia de remision','comprobante de retencion'],
            //   onChanged: ((value) {
            //     //print (value);
            //     // SharedPreferences prefs = await SharedPreferences.getInstance();
            //     // prefs.setString('codDoc', value);
            //   }),
            // ),
            CardSettingsText(hintText: 'sadad',
              //hintText: 'ayua',
              
              labelWidth: 150,
              label: 'Codigo Doc.',
              initialValue: productoInfo.xml_codDoc,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Title is required.';
              },
              onSaved: (value) => print ('dadsadddddd'),
              onChanged: ((value) {
                print ('dasdadsddddd');
              }),
            ),
            CardSettingsText(controller: controller_estab,
              hintText: 'Establecimiento',labelWidth: 150,
              label: 'Establecimiento',
              initialValue: productoInfo.xml_estab,
              // validator: (value) {
              //   if (!value.startsWith('http:')) return 'Must be a valid website.';
              // },
              // onSaved: (value) => url = value,
            ),
            CardSettingsText(controller: controller_ptoEmi,
              labelWidth: 150,
              hintText: 'punto de emission',   
              label: 'Punto Emision',
              // initialValue: productoInfo.xml_ptoEmi,
              initialValue: productoInfo.xml_agenciaElegida
              // validator: (value) {
              //   //if (!value.startsWith('http:')) return 'Must be a valid website.';
              // },
              // onSaved: (value) => url = value,
            ),
            CardSettingsText(controller: controller_dirMatriz,
              labelWidth: 150,
              hintText: 'direccion matriz',
              label: 'Dir Matriz',
              initialValue: productoInfo.xml_dirMatriz,
              // validator: (value) {
              //   //if (!value.startsWith('http:')) return 'Must be a valid website.';
              // },
              // onSaved: (value) => url = value,
            ),
            // FilePickerDemo()
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
      drawer:
      SizedBox(

        width: MediaQuery.of(context).size.width * 0.45,//20.0,,
        child:

        Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(//physics: const NeverScrollableScrollPhysics(),
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children:

            <Widget>[
              DrawerHeader(
                child:

                Stack(children: <Widget>[Center (child: Container(height: 120,color:Colors.blueAccent) ),
                  Center(child: Text('Menu',textAlign: TextAlign.right,style: TextStyle(fontSize: 22,color: Colors.white),),)  ,

                ],),


                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Row(children: <Widget>[
                  Icon(Icons.monetization_on),
                  Text('Nueva Factura',textAlign: TextAlign.right,),
                ],),
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
                title: Row(children: <Widget>[

                  Container(//



                    height: 40,width: 150,color: Colors.white60,child: Row(children: <Widget>[
                    Icon(Icons.send),
                    Text('Reenviar factura',textAlign: TextAlign.end,),

                  ],),)
                  ,


                ],),
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
                title: Row(children: <Widget>[
                  Icon(Icons.storage),
                  Text('Facturas emitidas',textAlign: TextAlign.center,),
                ],),
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
                title: Row(children: <Widget>[
                  Icon(Icons.person),
                  Text('Clientes',textAlign: TextAlign.center,),
                ],),
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
                title: Row(children: <Widget>[
                  Icon(Icons.book),
                  Text('Productos',textAlign: TextAlign.center,),
                ],),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  //Navigator.pop(context);


                },
              ),
              ListTile(
                title: Row(children: <Widget>[
                  Icon(Icons.share),
                  Text('VPN',textAlign: TextAlign.center,),
                ],),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  //Navigator.pop(context);


                },
              ),
              ListTile(
                title: Row(children: <Widget>[
                  Icon(Icons.settings),
                  Text('Ajustes',textAlign: TextAlign.center,),
                ],),
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
}

