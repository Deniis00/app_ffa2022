

import 'package:intl/intl.dart';

class ListarNotasPendientes {

  List<NotaPendienteModel> items = new List();

  ListarNotasPendientes();

  ListarNotasPendientes.fromJsonList( List<dynamic> jsonList  ){

    if ( jsonList == null ) return;

    jsonList.forEach( (item) {
      final estado = NotaPendienteModel.fromJson(item);
      items.add(estado);
    });
  }

}

class NotaPendienteModel {

  NotaPendienteModel({
    this.nroReg,
    this.cliente,
    this.fecha,
    this.vendedor,
    this.importancia,
    this.deposito,
    this.observacion,
    this.transferencias,
    this.volverSeparar,
    this.estante
  });

  int nroReg;
  String cliente;
  DateTime fecha;
  String vendedor;
  int importancia;
  int deposito;
  String observacion;
  int transferencias;
  int volverSeparar;
  String estante;


  factory NotaPendienteModel.fromJson(Map<String, dynamic> json) => NotaPendienteModel(
      nroReg        : json["nroReg"],
      cliente       : json["cliente"],
      fecha         : new DateFormat("dd-MM-yyyy hh:mm:ss").parse((json["fecha"])),
      vendedor      : json["vendedor"],
      importancia   : json["importancia"],
      deposito      : json["deposito"],
      observacion   : json["observacion"],
      transferencias: json["transferencias"],
      volverSeparar : json["volver_separar"],
      estante       : json["estante"],
  );

}