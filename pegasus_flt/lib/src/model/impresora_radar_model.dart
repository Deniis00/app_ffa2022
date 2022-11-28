

import 'package:intl/intl.dart';

class ListaImpresoraRadar {

  List<ImpresoraRadarModel> items = new List();

  ListaImpresoraRadar();

  ListaImpresoraRadar.fromJsonList( List<dynamic> jsonList  ){

    if ( jsonList == null ) return;

    jsonList.forEach( (item) {
      final estado = ImpresoraRadarModel.fromJson(item);
      items.add(estado);
    });

  }

}

class ImpresoraRadarModel {

  ImpresoraRadarModel({
    this.idPrinter,
    this.nombre
  });

  int idPrinter;
  String nombre;


  factory ImpresoraRadarModel.fromJson(Map<String, dynamic> json) => ImpresoraRadarModel(
      idPrinter      : json["id_printer"],
      nombre     : json["nombre"],
  );

}