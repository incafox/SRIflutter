import 'package:card_settings/card_settings.dart';
import 'package:card_settings/helpers/decimal_text_input_formatter.dart';
import 'package:card_settings/widgets/card_settings_panel.dart';
import 'package:card_settings/widgets/text_fields/card_settings_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_final_sri/utilities/constants.dart';
import 'package:flutter_final_sri/main.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_final_sri/productosJson.dart';
import 'package:provider/provider.dart';

import '../provider_productos.dart';

// class SecondScreenLogin extends StatelessWidget {
//   static const String _title = 'Flutter Code Sample';

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: _title,
//       home: Scaffold(
//         appBar: AppBar(title: const Text(_title)),
//         body: Center(
//           child: MyStatefulWidget(),
//         ),
//       ),
//     );
//   }
// }

List<Empresas> empresitas = []; // await fetchPhotos(http.Client());
List<Agencias> agencitas = [];

class SecondScrenLogin extends StatefulWidget {
  SecondScrenLogin({Key key}) : super(key: key);

  @override
  _SecondScrenLoginState createState() => _SecondScrenLoginState();
}

class _SecondScrenLoginState extends State<SecondScrenLogin> {
  String dropdownValue = 'One';
  bool _completo = false;
  bool _agenciaVisible = false;
  bool _continuarVisible=false;
  //todo > metodo flask para
  TextEditingController controller_descripcion = TextEditingController();
  TextEditingController controller_costoUnitario =
      TextEditingController(text: '0');
  TextEditingController controller_cantidad = TextEditingController(text: '1');
  TextEditingController controller_total = TextEditingController(text: '0');
  TextEditingController controller_impuesto = TextEditingController(text: '0');


  void obtieneDataAuxiliar(String empresa, String agencia){
    
  }


  @override
  Widget build(BuildContext context) {
    final productoInfo = Provider.of<ProductosArrayInfo>(context);
    // for (Empresas item in productoInfo.empresas) {
    //   print("build >> " + item.nombre.toString());
    // }

    List<String> tempCodigos = [];// productoInfo.getCodigosEmpresas();

    List<String> tempNombres = [];//productoInfo.getNombresEmpresas();

    int i = 0;
     for (Empresas item in productoInfo.empresas) {
       tempNombres.add(i.toString()+". "+item.nombre);
       tempCodigos.add(item.codigo);
        print("primer >> " + item.nombre.toString());
        i++;
      }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "",
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Form(
        onChanged: (() {
          // productoInfo.modifyProduct(this.index, this.controller_descripcion.text);
          // productoInfo.lista = this.controller_descripcion.text;
        }),
        //key: _formKey,
        child: CardSettings(
          //cardElevation: 67,
          children: <Widget>[
            CardSettingsHeader(
              labelAlign: TextAlign.center,
              label: 'Seleccione',
              color: Colors.blue,
            ),
            CardSettingsListPicker(
              contentAlign: TextAlign.center,
              values: tempCodigos, // ['0','12','14'],
              //hintText: 'ada',
              //hintText: 'Seleccione',
              label: 'Empresa',
              initialValue: '1',
              options: tempNombres, //['0%','12%','14%'],
              onChanged: ((value) async {
                productoInfo.empresa = value;
                // productoInfo.xml_empresaElegida = value;
                List<Agencias> tmp = await fetchAgencias(http.Client(), value);
                productoInfo.agencias = tmp;
                print ('consultando + empresa >> ' + value.toString());
                for (Agencias item in tmp) {
                  print("build agencia >> " + item.nombre.toString());
                }
                print('[valor] ' + value);
                this.controller_impuesto.text = value.toString();
                print("rec >>>> ");
                double im = double.parse(this.controller_impuesto.text) / 100.0;
                print("puro > " + im.toString());
                print(" tecto " + this.controller_impuesto.text);
                im = im * double.parse(this.controller_total.text);
                this.controller_impuesto.text = im.toString();
                productoInfo.xml_empresaElegida = value;
                print(" im " + im.toString());
                setState(() {
                  this._agenciaVisible=true;
                });
              }),
            ),
            Visibility(visible: this._agenciaVisible,
                          child: CardSettingsListPicker(
                contentAlign: TextAlign.center,
                values: productoInfo.getCodigosAgencias(), // ['0','12','14'],
                //hintText: 'ada',
                //hintText: 'Seleccione',
                label: 'Agencia',
                initialValue: '1',
                options: productoInfo.getNombresAgencias(), // ['0%','12%','14%'],
                onChanged: ((value) async {
                  productoInfo.xml_agenciaElegida = value;
                  print('agencia seleccionada > ' + value.toString());
                  Empresas empresitaxxx = productoInfo.getEmpresaElegida(productoInfo.xml_empresaElegida);
                  Agencias agencitaxxx = productoInfo.getAgenciaElegida(productoInfo.xml_agenciaElegida);
                  print ('elegidos');
                  print (empresitaxxx.nombre);
                  print (agencitaxxx.nombre);
                  productoInfo.xml_ambiente = empresitaxxx.ambienEmp;
                  productoInfo.xml_tipoEmision = '';
                  productoInfo.xml_razonSocial = empresitaxxx.nombre;
                  productoInfo.xml_ruc = empresitaxxx.rucEmp;
                  productoInfo.xml_tipoEmision="001";
                  productoInfo.xml_codDoc= "01";
                  productoInfo.xml_ptoEmi=productoInfo.xml_cod_vendedor.toString().substring(1,productoInfo.xml_cod_vendedor.toString().length);
                  productoInfo.xml_estab = value.substring(2,value.length);
                  productoInfo.xml_dirMatriz = empresitaxxx.direccEmp;

                  this.obtieneDataAuxiliar(productoInfo.xml_agenciaElegida, productoInfo.empresa);

                  // productoInfo.xml_codDoc = empresitaxxx.co
                  print("mascota debug");
                  print(empresitaxxx.rucEmp);
                  print(productoInfo.xml_ruc);


                  setState(() {
                    this._continuarVisible = true;



                  });
                  // print(" im "+im.toString());
                }),
              ),
            ),
            Visibility(
              visible: this._continuarVisible,
                          child: Padding(
                padding: EdgeInsets.all(100.0),
                child: RaisedButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.blue)),
                  onPressed: () {
                    //mediante funcion de otro .dart con parametros todos los datos de
                    //del form, generar el xml, codificar y enviar
                    //poner siguiente pantalla aca
                    Navigator.push(//original MyApp
                   context, MaterialPageRoute(builder: (context) => MyHomePage()));
                    // productoInfo.get_empresa_logo();

                    //ENTREGA TODOS LOS DATOS A PROVIDER
                    // productoInfo.xml_ambiente = 
                    // productoInfo.xml_codDoc = 
                    // productoInfo.xml_dirEstablecimiento = 
                    // productoInfo.xml_dirMatriz = 
                  },
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text("continuar".toUpperCase(),
                      style: TextStyle(fontSize: 17)),
                ),
              ),
            )
            // Text('total' + this.controller_total.text),
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
    );
  }
}

//primera pantalla para login

Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response =
      await client.get('http://167.172.203.137/services/mssql/getusuari');
  client.close();
//      await client.get('https://jsonplaceholder.typicode.com/photos');

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsePhotos, response.body);
}

// A function that converts a response body into a List<Photo>.
List<Photo> parsePhotos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

class Photo {
  final String codigo_usu;
  final String clave_usu;

  Photo(
      {this.codigo_usu,
      this.clave_usu}); //this.cod_corregir, this.nombre_principal,

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      codigo_usu: json['codigo_usu'],
      clave_usu: json['clave_usu'],
    );
  }
}

//para empresas
Future<List<Empresas>> fetchEmpresas(http.Client client) async {
  final response =
      await client.get('http://167.172.203.137/services/mssql/getempresas');
  client.close();
//      await client.get('https://jsonplaceholder.typicode.com/photos');

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseEmpresas, response.body);
}

// A function that converts a response body into a List<Photo>.
List<Empresas> parseEmpresas(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Empresas>((json) => Empresas.fromJson(json)).toList();
}

class Empresas {
  final String nombre;
  final String codigo;
  final String ambienEmp;
  final String rucEmp;
  final String direccEmp;
  Empresas(
      {this.codigo, this.nombre, this.ambienEmp, this.rucEmp, this.direccEmp}); //this.cod_corregir, this.nombre_principal,

  factory Empresas.fromJson(Map<String, dynamic> json) {
    return Empresas(
      codigo: json['empresa_id'],
      nombre: json['razsoc_emp'],
      ambienEmp: json['ambien_emp'],
      rucEmp: json['ruc_emp'],
      direccEmp: json['direcc_emp']
    );
  }
}

Future<List<Agencias>> fetchAgencias(
    http.Client client, String empreCod) async {
  // Map map = new Map<String, dynamic>();
  // map["empresa"] = empreCod;
    Map data = {
    'empresa': empreCod
  };
  //encode Map to JSON
  var body = json.encode(data);
  print('asumiendo post > ' + body.toString());
  final response = await client
      .post('http://167.172.203.137/services/mssql/getagenci',
      headers: {"Content-Type": "application/json"},
       body: body);
  client.close();
//      await client.get('https://jsonplaceholder.typicode.com/photos');
  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseAgencias, response.body);
}

// A function that converts a response body into a List<Photo>.
List<Agencias> parseAgencias(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Agencias>((json) => Agencias.fromJson(json)).toList();
}

class Agencias {
  final String direc;
  final String codigo;
  final String nombre;
  Agencias(
      {this.codigo,
      this.direc,
      this.nombre}); //this.cod_corregir, this.nombre_principal,

  factory Agencias.fromJson(Map<String, dynamic> json) {
    return Agencias(
        codigo: json['agenci_id'],
        direc: json['direcc_age'],
        nombre: json['nombre_age']);
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  bool _showLoading = false;
  bool _claveCorrecta = false;
  TextEditingController _user = new TextEditingController();
  TextEditingController _pass = new TextEditingController();
  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Usuario',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: _user,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person_pin,
                color: Colors.white,
              ),
              hintText: 'Introduce tu usuario',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Clave',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: this._pass,
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Introduce tu clave',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => print('Forgot Password Button Pressed'),
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            'Recuerdame',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    final productoInfo = Provider.of<ProductosArrayInfo>(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          setState(() {
            this._showLoading = true;
          });
          //Para test
          // Navigator.pushReplacement(//ProductosJsonSearchPage MyApp
          //     context, MaterialPageRoute(builder: (context) => MyApp()));
          //FINAL
          // Navigator.pushReplacement(//ProductosJsonSearchPage MyApp
          //         context, MaterialPageRoute(builder: (context) => MyApp()));
          List<Photo> temp = await fetchPhotos(http.Client());
          for (Photo item in temp) {
            print("datos puestos : ");
            print(this._user.text);
            print(this._pass.text);
            //asigna en provider
            productoInfo.xml_cod_vendedor = this._user.text;
            if (item.codigo_usu == this._user.text &&
                item.clave_usu == this._pass.text) {
              this._claveCorrecta = true;
              // empresitas= await fetchEmpresas(http.Client());
              productoInfo.empresas = await fetchEmpresas(http.Client());
              print("empresitas = " + empresitas.length.toString());
              for (Empresas item in productoInfo.empresas) {
                print("primer >> " + item.nombre.toString());
              }
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => SecondScrenLogin()));
            } else {
              if (item.codigo_usu == this._user.text &&
                  item.clave_usu != this._pass.text) {
                print('clave incorrecta');
              } else {}
            }
          }
          //si termina el bucle
          setState(() {
            this._showLoading = false;
          });

          if (!_claveCorrecta) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20.0)), //this right here
                    child: Container(
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'El usuario no existe'),
                            ),
                            // SizedBox(
                            //   width: 320.0,
                            //   child: RaisedButton(
                            //     onPressed: () {},
                            //     child: Text(
                            //       "Ok",
                            //       style: TextStyle(color: Colors.white),
                            //     ),
                            //     color: const Color(0xFF1BC0C5),
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }

          print('Login Button Pressed');
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- OR -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Sign in with',
          style: kLabelStyle,
        ),
      ],
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () => print('Login with Facebook'),
            AssetImage(
              'assets/logos/facebook.jpg',
            ),
          ),
          _buildSocialBtn(
            () => print('Login with Google'),
            AssetImage(
              'assets/logos/google.jpg',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => print('Sign Up Button Pressed'),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(  
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 100.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Innova S.G.',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(),
                      // SizedBox(height: 30.0),
                      _buildEmailTF(),
                      Divider(),
                      // SizedBox(
                      //   height: 30.0,
                      // ),
                      _buildPasswordTF(),
                      Divider(),
                      // _buildForgotPasswordBtn(),
                      _buildRememberMeCheckbox(),
                      _buildLoginBtn(),
                      // _buildSignInWithText(),
                      // _buildSocialBtnRow(),
                      // _buildSignupBtn(),
                    ],
                  ),
                ),
              ),
              Container(
                child: Visibility(
                    visible: this._showLoading,
                    child: SpinKitDualRing(size: 80, color: Colors.deepPurple)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
