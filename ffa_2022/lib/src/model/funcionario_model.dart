

import 'package:intl/intl.dart';

class ListarFuncionarios {

  List<FuncionarioModel> items = new List();

  ListarFuncionarios();

  ListarFuncionarios.fromJsonList( List<dynamic> jsonList  ){

    if ( jsonList == null ) return;

    jsonList.forEach( (item) {
      final estado = FuncionarioModel.fromJson(item);
      items.add(estado);
    });
  }


}

class FuncionarioModel {

  FuncionarioModel({
    this.id,
    this.idFuncionario,
    this.nombreFuncionario

  });

  int id;
  int idFuncionario;
  String nombreFuncionario;


  factory FuncionarioModel.fromJson(Map<String, dynamic> json) => FuncionarioModel(
      id                  : json["id"],
      idFuncionario       : json["id_funcionario"],
      nombreFuncionario   : json["nombre_funcionario"],

  );

}


