

import 'dart:core';

class ListaTesteNotaSeleccionada {

  List<TesteNotaSeleccionadaModel> items = new List();

  ListaTesteNotaSeleccionada();

  ListaTesteNotaSeleccionada.fromJsonList( List<dynamic> jsonList  ){

    if ( jsonList == null ) return;

    jsonList.forEach( (item) {
      final estado = TesteNotaSeleccionadaModel.fromJson(item);
      items.add(estado);
    });
  }

}

class TesteNotaSeleccionadaModel {

  TesteNotaSeleccionadaModel({
    this.nroReg,
    this.codigo,
    this.descripcion,
    this.motivoCambio,
    this.serial,
    this.observacion,
    this.cantidad,
    this.registrada,
    this.descripcionMotivo,
    this.idTest,
  });

  String nroReg;
  String codigo;
  String descripcion;
  int motivoCambio;
  String serial;
  String observacion;
  String cantidad;
  String registrada;
  String descripcionMotivo;
  int idTest;

  factory TesteNotaSeleccionadaModel.fromJson(Map<String, dynamic> json) => TesteNotaSeleccionadaModel(
    nroReg            : json["nro_reg"].toString(),
    codigo            : json["codigo"].toString(),
    descripcion       : json["descripcion"],
    motivoCambio      : int.parse(json["motivo_cambio"].toString()),
    serial            : json["serial"],
    observacion       : json["observacion"],
    cantidad          : json["cantidad"].toString(),
    registrada        : json["registrada"].toString(),
    descripcionMotivo : json["descripcion_motivo"],
    idTest            : json["id_test"],
  );

}