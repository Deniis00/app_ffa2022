

import 'package:intl/intl.dart';

class ListaTesteMotivoDevolucion {

  List<TesteMotivoDevolucionModel> items = new List();

  ListaTesteMotivoDevolucion();

  ListaTesteMotivoDevolucion.fromJsonList( List<dynamic> jsonList  ){

    if ( jsonList == null ) return;

    jsonList.forEach( (item) {
      final estado = TesteMotivoDevolucionModel.fromJson(item);
      items.add(estado);
    });

  }

}

class TesteMotivoDevolucionModel {

  TesteMotivoDevolucionModel({
    this.id,
    this.observacion
  });

  int id;
  String observacion;


  factory TesteMotivoDevolucionModel.fromJson(Map<String, dynamic> json) => TesteMotivoDevolucionModel(
      id          : json["id"],
      observacion : json["observacion"],
  );

}