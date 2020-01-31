import 'package:card_settings/card_settings.dart';
import 'package:flutter/material.dart';

class TabProductos extends StatelessWidget {
  Widget addProducto() {
    String url = 'sadsa';
    return CardSettingsText(
      labelWidth: 150,
      label: 'Tipo Identificacion',
      initialValue: 'Editar tipo identificacion',
      validator: (value) {
        if (!value.startsWith('http:')) return 'Must be a valid website.';
      },
      onSaved: (value) => url = value,
    );
  }

  //final Color color;
  //final String name;
  //String dropdownValue = 'One';
  //String title = "Spheria";
  //String author = "Cody Leet";
  //String url = "http://www.codyleet.com/spheria";
  List<Widget> listaProductos;
  var list = ["one", "two", "three", "four"]; //todo :poner esto en singleton

  @override
  Widget build(BuildContext context) {
//CardSettingsHeader(color: Colors.blueAccent,label: 'Lista de productos',labelAlign: TextAlign.center,),
    return Container(
      color: Colors.white,
      child: Form(
        //key: _formKey,
        child: CardSettings(
          children: <Widget>[
            Row(children: <Widget>[
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
                  child: Text("+Inventario".toUpperCase(),
                      style: TextStyle(fontSize: 17)),
                ),
              ),
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
                  child: Text("+   Manual".toUpperCase(),
                      style: TextStyle(fontSize: 17)),
                ),
              ),


            ],),

            Container(
              color: Colors.blueAccent,
              height: 33,
              child: Text(
                'Productos',
                textAlign: TextAlign.center,

                style: TextStyle(color: Colors.white,fontSize: 17)
              ),
            ),
            for (var item in list)
              Card(
                child: Text(item),
              ),
            Container(
              color: Colors.blueAccent,
              height: 33,
              child: Text(
                'Importe',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white,fontSize: 17),
              ),
            ),
            RaisedButton(
              child: Text(
                'agregar producto',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.red,
              onPressed: () {
                print('daaa');
              },
            )
          ],
        ),
      ),
    );
  }
}
