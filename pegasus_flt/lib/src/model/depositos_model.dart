

import 'package:intl/intl.dart';

class ListaDepositos {

  List<DepositosModel> items = new List();

  ListaDepositos();

  ListaDepositos.fromJsonList( List<dynamic> jsonList  ){

    if ( jsonList == null ) return;

    jsonList.forEach( (item) {
      final estado = DepositosModel.fromJson(item);
      items.add(estado);
    });

  }

}

class DepositosModel {

  DepositosModel({
    this.codDeposito,
    this.deposito,
    this.seleccionado
  });

  int codDeposito;
  String deposito;
  bool seleccionado;


  factory DepositosModel.fromJson(Map<String, dynamic> json) => DepositosModel(
      codDeposito : json["cod_deposito"],
      deposito    : json["deposito"],
      seleccionado: json['seleccionado'] == 0 ? false : true,
  );


  Map toJson() => {
    'cod_deposito' : codDeposito,
    'deposito'     : deposito,
    'seleccionado' : seleccionado
  };

}