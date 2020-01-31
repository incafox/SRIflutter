import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';



//va a servir exlucivamente para datos de cliente
//tambien para datos de pdf y manejo de estados
//jaja que creisy
class MyXmlSingleton {
  static final MyXmlSingleton _instance = MyXmlSingleton._internal();
  factory MyXmlSingleton() => _instance;

  //info tributaria
  String ambiente;
  String tipoEmision;
  String razonSocial;
  String ruc;
  String claveAcceso;
  String codDoc;
  String estab;
  String ptoEmi;
  String secuencial;
  String dirMatriz;

  //infor factura
  //INFO FACTURA

  String fechaEmision;
  String dirEstablecimiento;
  String obligadoContabilidad;
  String tipoIdentificacionComprador;
  String razonSocialComprador;
  String identificacionComprador;
  String totalSinImpuestos;
  String totalDescuento;
  String codigo;
  String codigoPorcentaje;
  String baseImponible;
  String tarifa;
  String valor;
  String propina;
  String importeTotal;
  String moneda;
  String formaPago;
  String total;

String getInfoFactura(){
  String infoFactura = """
    <infoFactura>
    <fechaEmision>${this.fechaEmision}</fechaEmision>
    <dirEstablecimiento>${this.dirEstablecimiento}</dirEstablecimiento>
    <obligadoContabilidad>${this.obligadoContabilidad}</obligadoContabilidad>
    <tipoIdentificacionComprador>${this.tipoIdentificacionComprador}</tipoIdentificacionComprador>
    <razonSocialComprador>${this.razonSocialComprador}</razonSocialComprador>
    <identificacionComprador>${this.identificacionComprador}</identificacionComprador>
    <totalSinImpuestos>${this.totalSinImpuestos}</totalSinImpuestos>
    <totalDescuento>${this.totalDescuento}</totalDescuento>
    <totalConImpuestos>
      <totalImpuesto>
        <codigo>${this.codigo}</codigo>
        <codigoPorcentaje>${this.codigoPorcentaje}</codigoPorcentaje>
        <baseImponible>${this.baseImponible}</baseImponible>
        <tarifa>${this.tarifa}</tarifa>
        <valor>${this.valor}</valor>
      </totalImpuesto>
    </totalConImpuestos>
    <propina>${this.propina}</propina>
    <importeTotal>${this.importeTotal}</importeTotal>
    <moneda>${this.moneda}</moneda>
    <pagos>
      <pago>
        <formaPago>${this.formaPago}</formaPago>
        <total>${this.total}</total>
      </pago>
    </pagos>
  </infoFactura>
    """;

  return infoFactura;
}

//CAMPOS DETALLES



String getDetalles(){


  String detalles = """
  <detalles>
    <detalle>
      <codigoPrincipal>965839468943</codigoPrincipal>
      <descripcion>producto1</descripcion>
      <cantidad>1.00</cantidad>
      <precioUnitario>500.00</precioUnitario>
      <descuento>0</descuento>
      <precioTotalSinImpuesto>500.00</precioTotalSinImpuesto>
      <impuestos>
        <impuesto>
          <codigo>2</codigo>
          <codigoPorcentaje>2</codigoPorcentaje>
          <tarifa>12</tarifa>
          <baseImponible>500.00</baseImponible>
          <valor>60</valor>
        </impuesto>
      </impuestos>
    </detalle>
    <detalle>
      <codigoPrincipal>965839468943</codigoPrincipal>
      <descripcion>producto1</descripcion>
      <cantidad>1.00</cantidad>
      <precioUnitario>500.00</precioUnitario>
      <descuento>0</descuento>
      <precioTotalSinImpuesto>500.00</precioTotalSinImpuesto>
      <impuestos>
        <impuesto>
          <codigo>2</codigo>
          <codigoPorcentaje>2</codigoPorcentaje>
          <tarifa>12</tarifa>
          <baseImponible>500.00</baseImponible>
          <valor>60</valor>
        </impuesto>
      </impuestos>
    </detalle>
  </detalles>
</factura>
  
  """;

  return detalles;
}

  /*
  * <detalles>
    <detalle>
      <codigoPrincipal>965839468943</codigoPrincipal>
      <descripcion>producto1</descripcion>
      <cantidad>1.0000</cantidad>
      <precioUnitario>150.0000</precioUnitario>
      <descuento>0</descuento>
      <precioTotalSinImpuesto>150.0000</precioTotalSinImpuesto>
      <impuestos>
        <impuesto>
          <codigo>2</codigo>
          <codigoPorcentaje>2</codigoPorcentaje>
          <tarifa>12</tarifa>
          <baseImponible>150.0000</baseImponible>
          <valor>18</valor>
        </impuesto>
      </impuestos>
    </detalle>
  </detalles>
  * */

  String codigoPrincipal; // 965839468943</codigoPrincipal>
  String descripcion; //>producto1</descripcion>
  String cantidad; //>1.0000</cantidad>
  String precioUnitario; //>150.0000</precioUnitario>
  String descuento; //>0</descuento>
  String precioTotalSinImpuesto; //>150.0000</precioTotalSinImpuesto>



  //finales
  String infoTributaria;

  /*
  Widget getTextWidgets(List<String> strings)
  {
    return new Row(children: strings.map((item) => new Text(item)).toList());
  }
   Widget getTextWidgets(List<String> strings)
  {
    List<Widget> list = new List<Widget>();
    for(var i = 0; i < strings.length; i++){
        list.add(new Text(strings[i]));
    }
    return new Row(children: list);
  }
  * */

  TextEditingController forDebug = new TextEditingController(text: 'para debug');
/*
  void setEmisor(String ambient,String tipoEmi,
              String razSoc, String ruc, String clavAcc,
              String codDoc, String estab, String ptoEmi,
              String sec, String dirMatriz)
  {
    this.ambiente = ambient;
    this.tipoEmision =  tipoEmi;
    this.razonSocial = razSoc;
    this.ruc = ruc;
    this.claveAcceso = clavAcc;
    this.codDoc = codDoc;
    this.estab = estab;
    this.ptoEmi = ptoEmi;
    this.secuencial = sec;
    this.dirMatriz = dirMatriz;

    this.infoTributaria = """
    <infoTributaria>
    <ambiente>${this.ambiente}</ambiente>
    <tipoEmision>${this.tipoEmision}</tipoEmision>
    <razonSocial>${this.razonSocial}</razonSocial>
    <ruc>${this.ruc}</ruc>
    <claveAcceso>${this.claveAcceso}</claveAcceso>
    <codDoc>${this.codDoc}</codDoc>
    <estab>${this.estab}</estab>
    <ptoEmi>${this.ptoEmi}</ptoEmi>
    <secuencial>${this.secuencial}</secuencial>
    <dirMatriz>${this.dirMatriz}</dirMatriz>
  </infoTributaria>
    """;


  }


 */
  inicializaVariables() async {
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

  MyXmlSingleton._internal() {
    // init things inside this
  }

// Methods, variables ...
}
