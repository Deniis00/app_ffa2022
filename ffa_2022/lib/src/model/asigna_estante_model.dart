

import 'package:intl/intl.dart';

class ListarAsignaEstante {

  List<AsignaEstanteModel> items = new List();

  ListarAsignaEstante();

  ListarAsignaEstante.fromJsonList( List<dynamic> jsonList  ){

    if ( jsonList == null ) return;

    jsonList.forEach( (item) {
      final estado = AsignaEstanteModel.fromJson(item);
      items.add(estado);
    });
  }

}

class AsignaEstanteModel {

  AsignaEstanteModel({
    this.codigo,
    this.descripcionProducto,
    this.estante,
    this.codDeposito,
    this.stock
  });

  String codigo;
  String descripcionProducto;
  String estante;
  String codDeposito;
  String stock;

  factory AsignaEstanteModel.fromJson(Map<String, dynamic> json) => AsignaEstanteModel(
      codigo                : json["codigo"].toString(),
      descripcionProducto   : json["descripcion_producto"].toString(),
      estante               : json["estante"].toString(),
      codDeposito           : json["cod_deposito"].toString(),
      stock                 : json["stock"].toString(),
  );

}