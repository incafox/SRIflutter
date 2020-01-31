
import 'package:card_settings/card_settings.dart';
import 'package:flutter/material.dart';

class FacturasPasadas extends StatelessWidget {
  const FacturasPasadas({
    Key key,
    //@required this.color,
    //@required this.name,
  }) : super(key: key);

  //final Color color;
  //final String name;
  //String dropdownValue = 'One';
  //String title = "Spheria";
  //String author = "Cody Leet";
  //String url = "http://www.codyleet.com/spheria";


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child:  Form(
        //key: _formKey,
        child: CardSettings(
          children: <Widget>[
            CardSettingsHeader(color: Colors.blueAccent,label: 'Facturas pasadas',labelAlign: TextAlign.center,),
            Row(children: <Widget>[
              Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Text('Factura 2020/3/1 21:44', style: TextStyle(fontSize: 16),))
              ,
              Padding(padding: EdgeInsets.fromLTRB(2, 0, 2, 0),child:

              RaisedButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blueAccent)),
                onPressed: () {
                  //mediante funcion de otro .dart con parametros todos los datos de
                  //del form, generar el xml, codificar y enviar


                },
                color: Colors.blueAccent,
                textColor: Colors.white,
                child: Text("pdf".toUpperCase(),
                    style: TextStyle(fontSize: 12)),
              ),
              ),
              Padding(padding: EdgeInsets.fromLTRB(2, 0, 2, 0),child:

              RaisedButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blueAccent)),
                onPressed: () {
                  //mediante funcion de otro .dart con parametros todos los datos de
                  //del form, generar el xml, codificar y enviar


                },
                color: Colors.blueAccent,
                textColor: Colors.white,
                child: Text("ticket".toUpperCase(),
                    style: TextStyle(fontSize: 12)),
              ),
              )

            ],)
            ,
            Row(children: <Widget>[
              Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Text('Factura 2020/3/1 21:44', style: TextStyle(fontSize: 16),))
              ,
              Padding(padding: EdgeInsets.fromLTRB(2, 0, 2, 0),child:

              RaisedButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blueAccent)),
                onPressed: () {
                  //mediante funcion de otro .dart con parametros todos los datos de
                  //del form, generar el xml, codificar y enviar


                },
                color: Colors.blueAccent,
                textColor: Colors.white,
                child: Text("pdf".toUpperCase(),
                    style: TextStyle(fontSize: 12)),
              ),
              ),
              Padding(padding: EdgeInsets.fromLTRB(2, 0, 2, 0),child:

              RaisedButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blueAccent)),
                onPressed: () {
                  //mediante funcion de otro .dart con parametros todos los datos de
                  //del form, generar el xml, codificar y enviar


                },
                color: Colors.blueAccent,
                textColor: Colors.white,
                child: Text("ticket".toUpperCase(),
                    style: TextStyle(fontSize: 12)),
              ),
              )

            ],)
            ,Row(children: <Widget>[
              Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Text('Factura 2020/3/1 21:44', style: TextStyle(fontSize: 16),))
              ,
              Padding(padding: EdgeInsets.fromLTRB(2, 0, 2, 0),child:

              RaisedButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blueAccent)),
                onPressed: () {
                  //mediante funcion de otro .dart con parametros todos los datos de
                  //del form, generar el xml, codificar y enviar


                },
                color: Colors.blueAccent,
                textColor: Colors.white,
                child: Text("pdf".toUpperCase(),
                    style: TextStyle(fontSize: 12)),
              ),
              ),
              Padding(padding: EdgeInsets.fromLTRB(2, 0, 2, 0),child:

              RaisedButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blueAccent)),
                onPressed: () {
                  //mediante funcion de otro .dart con parametros todos los datos de
                  //del form, generar el xml, codificar y enviar


                },
                color: Colors.blueAccent,
                textColor: Colors.white,
                child: Text("ticket".toUpperCase(),
                    style: TextStyle(fontSize: 12)),
              ),
              )

            ],)
            ,Row(children: <Widget>[
              Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Text('Factura 2020/3/1 21:44', style: TextStyle(fontSize: 16),))
              ,
              Padding(padding: EdgeInsets.fromLTRB(2, 0, 2, 0),child:

              RaisedButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blueAccent)),
                onPressed: () {
                  //mediante funcion de otro .dart con parametros todos los datos de
                  //del form, generar el xml, codificar y enviar


                },
                color: Colors.blueAccent,
                textColor: Colors.white,
                child: Text("pdf".toUpperCase(),
                    style: TextStyle(fontSize: 12)),
              ),
              ),
              Padding(padding: EdgeInsets.fromLTRB(2, 0, 2, 0),child:

              RaisedButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blueAccent)),
                onPressed: () {
                  //mediante funcion de otro .dart con parametros todos los datos de
                  //del form, generar el xml, codificar y enviar


                },
                color: Colors.blueAccent,
                textColor: Colors.white,
                child: Text("ticket".toUpperCase(),
                    style: TextStyle(fontSize: 12)),
              ),
              )

            ],)
            ,
          ],
        ),
      ),

    );
  }
}
