

import 'dart:core';

class ListaTesteNotasEncontradas {

  List<TesteNotasEncontradasModel> items = new List();

  ListaTesteNotasEncontradas();

  ListaTesteNotasEncontradas.fromJsonList( List<dynamic> jsonList  ){

    if ( jsonList == null ) return;

    jsonList.forEach( (item) {
      final estado = TesteNotasEncontradasModel.fromJson(item);
      items.add(estado);
    });
  }

}

class TesteNotasEncontradasModel {

  TesteNotasEncontradasModel({
    this.nroReg,
    this.cliente,
    this.nroFactura,
  });

  String nroReg;
  String cliente;
  String nroFactura;

  factory TesteNotasEncontradasModel.fromJson(Map<String, dynamic> json) => TesteNotasEncontradasModel(
    nroReg     : json["nro_reg"].toString(),
    cliente    : json["nombre_cliente"],
    nroFactura : json["nro_factura"].toString(),
  );

}