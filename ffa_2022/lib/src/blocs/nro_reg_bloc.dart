import 'dart:async';

import 'package:ffa_2022/src/blocs/validators.dart';
import 'package:rxdart/rxdart.dart';



class NroRegBloc with Validators {

  final _nroRegController  = BehaviorSubject<String>();

  //Resuperar datos de string
  Stream<String> get nroRegStream  => _nroRegController.stream.transform(validarNroReg);

  //Inserta valores en string
  Function(String) get changeEstante  => _nroRegController.sink.add;

  //Obtener ultimo valor ingresado a streams
  String get nroReg  => _nroRegController.value;

  clear(){
    _nroRegController.value = '';
  }

  setEstante(String valor){
    _nroRegController.value = valor;
  }

  dispose(){
    _nroRegController?.close();
  }

}