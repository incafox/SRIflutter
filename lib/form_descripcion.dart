import 'package:card_settings/card_settings.dart';
import 'package:card_settings/helpers/decimal_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final_sri/provider_productos.dart';
import 'package:flutter_final_sri/tab_factura_editar.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'singleton_formulario_actual.dart' as singleton;
import 'tab_factura_editar.dart';

class CardProduct extends StatefulWidget {
  // method() => createState().setDescripcion(value);
  // String value;
  @override
  final globalKey = GlobalKey<CardProductState>();

    final Function func;
    final int indice;
    // List<String> samples(){
    //   return this.
    // }
  CardProduct({@required this.indice,@required this.func });// : super(key: key);
  @override
  CardProductState createState() => CardProductState(this.indice);
}

class CardProductState extends State<CardProduct> {
  CardProductState(this.indice);
  final int indice;
  // CardProductState(Key key):super(key : key);
  String descripcion ;//; = 're'; //= Text('ada');
  String costoUnitario;// = 'er'; // = Text('ada');
  int cantidad = 1; //= Text('ada');
  String total = ''; // = Text('ada');]
  String impuesto = '';
  // int indice;
  List<Container> bucket = [];
  FormDescripcion formulario; // = new FormDescripcion(  );
  // final cardKey = GlobalKey<CardProductState>();
  // GlobalKey<CardProductState> _cardState;

  @override
  initState() {
    // TODO: implement initState\
    this.descripcion = '';
    this.cantidad = 1;
    this.costoUnitario = '0';
    this.total = '0';
    this.impuesto = '0';
    // this.formulario = new FormDescripcion();
    // this.cardKey = GlobalKey();
    // this.widget.key = _cardState;
    // this.descripcion = Text('dadsa');
    // this.costoUnitario = Text('ada');
    // this.cantidad = Text('ada');
    // this.total = Text('asda');
    // this.formulario = FormDescripcion(productoText: this.descripcion,);
    super.initState();
  }

  //final GlobalKey<CardProductState> key = new GlobalKey<CardProductState>();
  @override
  Widget build(BuildContext context) {
    final productoInfo = Provider.of<ProductosArrayInfo>(context);

    //final productoInfo=Provider.of<Pro ductosArrayInfo>(context);
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return FormDescripcion(
              func: function, 
              cantidad: this.cantidad.toString(),
              descripcion: this.descripcion.toString(),
              costoUnitario: this.costoUnitario.toString(),
              total: this.total.toString(),
              impuesto : this.impuesto.toString(),
              );
            // return this.formulario;
          }),
        );
      },
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Container(
          decoration:new  BoxDecoration(
            //borde,
          color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8))
        ),
            width: double.infinity,
            // color: Colors.black12,
            child: Column(
              children: <Widget>[
                SizedBox(height: 26,width: 57,
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
                      color: Colors.red,
                      onPressed: (){
                        // List<Widget> y = productoInfo.productos;

                  // print('size > ' + y.length.toString());

                  List <String> r = productoInfo.descripciones;
                  List <String> co = productoInfo.costosUnitarios;
                  List <String> ca = productoInfo.cantidades;
                  List <String> im = productoInfo.impuestos;
                  List <String> to = productoInfo.totales;
                  r[indice] = "None";
                  co[indice] = "None";
                  ca[indice] = "None";
                  to[indice] = "None";
                  im[indice] = "None";
                  productoInfo.descripciones = r;
                  productoInfo.costosUnitarios = co;
                   productoInfo.cantidades = ca;
                  productoInfo.impuestos = im;
                  productoInfo.totales = to;
                  
                        productoInfo.precioFinalTotal =  productoInfo.getPrecioTotal();
                        print('indeice >>' + widget.indice.toString());
                        widget.func(widget.indice);
                      },
                      child: Icon(Icons.close,color: Colors.white,)),
                ),

              Table(columnWidths: const <int, TableColumnWidth>{
      0: FlexColumnWidth(19.0),
      1: FlexColumnWidth(50.0),
    },
      border: TableBorder.all(color: Colors.black45),
      children: [
        TableRow(children: [
          Text(' Descripcion'),
          Text('\t'+this.descripcion),
        ]),
        TableRow(children: [
          Text(' Costo Unitario'),
          Text('\t'+this.costoUnitario),
        ]),
        TableRow(children: [
          Text(' Cantidad'),
          Text('\t'+this.cantidad.toString()),
        ]),
        TableRow(children: [
          Text(' Total'),
          Text('\t'+this.total),
        ]),
        TableRow(children: [
          Text(' Impuesto'),
          Text('\t'+this.impuesto),
        ])
      ],
    ),
    Container(height: 14,)
              ],
            )),
      ),
    );
  }

  // function(value) => setState(() => descripcion = value);
  function(descrip, costuni, cant, total, impuesto) => setState(() {
    descripcion = descrip;
    this.costoUnitario = costuni.toString();  
    this.cantidad = int.parse(cant);  
    this.total = total.toString();  
    this.impuesto = impuesto;
    final productoInfo=Provider.of<ProductosArrayInfo>(context,listen: false);
    List<String> f = productoInfo.descripciones;
    List<String> co = productoInfo.costosUnitarios;
    List<String> ca = productoInfo.cantidades;
    List<String> to = productoInfo.totales;
    List<String> im = productoInfo.impuestos;

    try 
    {
      f.removeAt(this.indice);
      co.removeAt(this.indice);
      ca.removeAt(this.indice);
      to.removeAt(this.indice);
      im.removeAt(this.indice);
    } 
    catch (e) 
    {
    }
    f.insert(this.indice, this.descripcion);
    productoInfo.descripciones = f;

    co.insert(this.indice, this.costoUnitario);
    productoInfo.costosUnitarios = co;

    ca.insert(this.indice, this.cantidad.toString() );
    productoInfo.cantidades = ca;

    to.insert(this.indice, this.total);
    productoInfo.totales = to;

    im.insert(this.indice, this.impuesto);
    productoInfo.impuestos = im;

  } );
}

// class FormDescripcion extends StatefulWidget {
//  FormDescripcion(this.cardKey);//: super(key: key);
//     final GlobalKey<CardProductState> cardKey;

// //  FormDescripcion(this.cardKey);//: super(key: key);
// //  final GlobalKey<CardProductState> actualProductKey;
//  @override
//  State<StatefulWidget> createState() {
//    // TODO: implement createState
//    return _FormDescripcionState();
//  }
// }
// GlobalKey<CardProductState> keyCard = GlobalKey();

//class MyHomePage extends StatelessWidget {
class FormDescripcion extends StatelessWidget {
  final Function func;
  final String descripcion;
  final String costoUnitario;
  final String cantidad;
  final String total;
  final String impuesto;

  FormDescripcion({Key key,@required this.func,
                    @required this.descripcion,@required this.costoUnitario,
                    @required this.cantidad,@required this.total,
                    @required this.impuesto}) : super(key: key);

  // final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  // TextEditingController controller = TextEditingController();
  // TextEditingController controller_ambiente = new TextEditingController();
  // TextEditingController controller_ruc = TextEditingController();
  // TextEditingController controller_tipoEmision = TextEditingController();
  // TextEditingController controller_estab = TextEditingController();
  // TextEditingController controller_ptoEmi = TextEditingController();
  // TextEditingController controller_secuencial = TextEditingController();
  // TextEditingController controller_codDoc = TextEditingController();
  // TextEditingController controller_claveAcceso = TextEditingController();

  TextEditingController controller_descripcion = TextEditingController();
  TextEditingController controller_costoUnitario = TextEditingController(text: '0');
  TextEditingController controller_cantidad  = TextEditingController(text: '1');
  TextEditingController controller_total  = TextEditingController(text: '0');
  TextEditingController controller_impuesto  = TextEditingController(text: '0');

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(),
    );
  }
//  _inicializaVariables() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    this.ambiente = (prefs.getString('ambiente')); //+ 1;
//    this.tipoEmision = (prefs.getString('tipoEmision')); //+ 1;
//    this.razonSocial = (prefs.getString('razonSocial')); //+ 1;
//    this.ruc = (prefs.getString('ruc')); //+ 1;
//    this.claveAcceso = (prefs.getString('claveAcceso')); //+ 1;
//    this.codDoc = (prefs.getString('codDoc')); //+ 1;
//    this.estab = (prefs.getString('estab')); //+ 1;
//    this.ptoEmi = (prefs.getString('ptoEmi')); //+ 1;
//    this.secuencial = (prefs.getString('secuencial')); //+ 1;
//    this.dirMatriz = (prefs.getString('dirMatriz')); //+ 1;
//    //print('Pressed $counter times.');
//    //await prefs.setString(identificador, counter);
//  }

  @override
  Widget build(BuildContext context) {
    this.controller_descripcion.text = this.descripcion;
    this.controller_costoUnitario.text = this.costoUnitario;
    this.controller_cantidad.text = this.cantidad;
    this.controller_total.text = this.total;
    this.controller_impuesto.text = this.impuesto;
    final productoInfo = Provider.of<ProductosArrayInfo>(context);
    // inicio();
    // this.producto = CardProduct();
    // var _ponyModel = 22;
//    _inicializaVariables();
//    setState(() {
////      this._inicializaVariables();
//    });
//    singleton.MyXmlSingleton().inicializaVariables();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red, elevation: 20,
        title: Text('Ficha de Producto'),
        //backgroundColor: Colors.red,
        centerTitle: true,
        actions: <Widget>[
          // Padding(
          //   padding: EdgeInsets.fromLTRB(2, 8, 2, 8),
          //   child: RaisedButton(
          //     elevation: 25,
          //     shape: new RoundedRectangleBorder(
          //         borderRadius: new BorderRadius.circular(18.0),
          //         side: BorderSide(color: Colors.black26)),
          //     onPressed: () {
          //       //mediante funcion de otro .dart con parametros todos los datos de
          //       //del form, generar el xml, codificar y enviar
          //       singleton.MyXmlSingleton().addCelda();
          //     },
          //     color: Colors.black,
          //     textColor: Colors.white,
          //     child:
          //         Text("Guardar".toUpperCase(), style: TextStyle(fontSize: 12)),
          //   ),
          // )
        ],
      ),
      body: Form(
        onChanged: (() {
          func(
            controller_descripcion.text,
            controller_costoUnitario.text,
            controller_cantidad.text,
            controller_total.text,
            controller_impuesto.text
          );
          // productoInfo.modifyProduct(this.index, this.controller_descripcion.text);
          // productoInfo.lista = this.controller_descripcion.text;
          print(controller_descripcion.text);
          // print('conto unit: '+this.controller_costoUnitario.text.toString());
          double contunit = double.parse(this.controller_costoUnitario.text) ;
          int cantidad = int.parse(this.controller_cantidad.text) ;
          // print((contunit*cantidad).toString());
          // this.controller_total.text = "\$" +(contunit*cantidad).toString();
          double formatDecimal = contunit*cantidad;
          // formatDecimal = double.;
          this.controller_total.text = (contunit*cantidad).toString();
          print (this.controller_total.text);
                // this.controller_costoUnitario.text = (value);

          double pTotal = productoInfo.getPrecioTotal();
          productoInfo.precioFinalTotal = pTotal;
          
          //print(widget.cardKey.currentState.descripcion);
        }),
        //key: _formKey,
        child: CardSettings(
          //cardElevation: 67,
          children: <Widget>[
            CardSettingsHeader(
              labelAlign: TextAlign.center,
              label: 'Producto',
              color: Colors.blueAccent,
            ),
//        this.controller_descripcion.text = widget.actualProductKey.currentState.descripcion.data;
//        this.controller_costoUnitario.text = widget.actualProductKey.currentState.descripcion.data;
//        this.controller_cantidad.text = widget.actualProductKey.currentState.descripcion.data;
//        this.controller_total.text = widget.actualProductKey.currentState.descripcion.data;

            CardSettingsText(
              numberOfLines: 2, hintText: 'Descripcion de producto',
              //hintText: 'ayua',
              controller: controller_descripcion,
              labelWidth: 100,
              label: 'Descripcion',
              maxLength: 70,
              // initialValue: productoInfo.lista,
              initialValue: controller_descripcion.text,
              // validator: (value) {
              //   if (value == null || value.isEmpty) return 'Title is required.';
              // },
              // onSaved: (value) => print ('daedsadddddd'),
              onChanged: ((value) {
                // print(value);
                productoInfo.lista = value;
//                this.producto.setDescripcion(value);
                // this.producto.value = value;
              }),
            ),
//             CardSettingsListPicker(
//               // numberOfLines: 3, hintText: 'codigo de impuesto',
//               hintText: 'codigo de impuesto',
//               controller: controller_descripcion,
//               labelWidth: 100,
//               label: 'Descripcion',
//               maxLength: 70,
//               // initialValue: productoInfo.lista,
//               initialValue: controller_descripcion.text,

//               // validator: (value) {
//               //   if (value == null || value.isEmpty) return 'Title is required.';
//               // },
//               // onSaved: (value) => print ('daedsadddddd'),
//               onChanged: ((value) {
//                 print(value);
//                 productoInfo.lista = value;
// //                this.producto.setDescripcion(value);
//                 // this.producto.value = value;
//               }),
//             ),
            
            CardSettingsText(
              controller: this.controller_costoUnitario,
              keyboardType: TextInputType.numberWithOptions(),
              maxLength: 10,
              autovalidate: true,
              labelWidth: 170,
              label: 'Costo Unitario',
             initialValue: this.controller_costoUnitario.text,
              hintText: 'Numero',
//              validator: (value) {
//                try{
//                  if (value.length>13) return 'Ruc es de 13 numeros';
//                }
//                catch(e){
//                  print ('faf');
//                }
//
//              },
//              onSaved: (value) => url = value,
              onChanged: ((value) {
                // print('conto unit'+this.controller_costoUnitario.value.toString());
                this.controller_costoUnitario.text = (value);
//                this.producto.setCostoUni(value);
              }),
            ),
            CardSettingsText(
              controller: this.controller_cantidad,
              keyboardType: TextInputType.numberWithOptions(decimal: false),

              maxLength: 10,
              autovalidate: true,
              labelWidth: 170,
              label: 'Cantidad',
            //  initialValue: this.producto.getCantidad(),
              hintText: 'Numero',
              validator: (value) {
                try {
                  if (value is double) return 'Ruc es de 13 numeros';
                } catch (e) {
                  // print ('faf');
                }
              },
//              onSaved: (value) => url = value,  
              onChanged: ((value) {
                // print(value);
//                this.producto.setCantidad(value);
              }),
            ),
            
            CardSettingsText(
              
              //  focusNode: AlwaysDisabledFocusNode(), 
              autocorrect: true,
              inputFormatters: [DecimalTextInputFormatter(decimalDigits: 2)],
              enabled: false,
                hintText: '\$',
                controller: this.controller_total,
                labelWidth: 170,
                label: 'Total sin impuesto',
//              initialValue: this.producto.getTotal(),
                validator: (value) {
                  if (!value.startsWith('http:'))
                    return 'Must be a valid website.';
                },
                onChanged: ((value) {
                  print(value);
//                  this.producto.setTotal(value);
                })
//              onSaved: (value) => url = value,
                ),
              CardSettingsListPicker(contentAlign: TextAlign.center,
                values: ['0','12','14'],
                //hintText: 'ada',
                //hintText: 'Seleccione',
                label: 'Tipo Impuesto',
                initialValue: '1',
                options: ['0%','12%','14%'],
                onChanged: ((value) async
                {
                  print ('[valor] ' +value);
                  this.controller_impuesto.text = value.toString();
                  print("rec >>>> ");
                  double im = double.parse(this.controller_impuesto.text)/100.0;
                  print("puro > "+ im.toString());
                  print(" tecto "+this.controller_impuesto.text);
                  im = im*double.parse(this.controller_total.text);
                  this.controller_impuesto.text = im.toString(); 
                  
                  print(" im "+im.toString());
                  // print(this.controller_impuesto.text);
                    // switch (int.p arse(value)) {
                    //   case 0:
                    //       this.controller_impuesto.text = value.toString();
                    //     break;
                    //   case 12:
                    //       this.controller_impuesto.text = value.toString();
                    //     break;
                    //   default:
                    // }
                    //prefs.setString('ambiente', value);
              }),
            ),
            CardSettingsText(
              controller: this.controller_impuesto,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              maxLength: 10,
              autovalidate: true,
              labelWidth: 170,
              label: 'impuesto',
            //  initialValue: this.producto.getCantidad(),
              hintText: 'Numero',
              validator: (value) {
                // try {
                //   // if (value is double) return 'Ruc es de 13 numeros';
                // } catch (e) {
                //   // print ('faf');
                // }
              },
//              onSaved: (value) => url = value,  
              onChanged: ((value) {
                print(value);
//                this.producto.setCantidad(value);
              }),
            ),
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
    );
  }
}
