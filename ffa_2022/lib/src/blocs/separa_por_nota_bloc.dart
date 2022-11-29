import 'dart:async';

import 'package:ffa_2022/src/blocs/validators.dart';
import 'package:rxdart/rxdart.dart';



class SeparaPorNotaBloc with Validators {

  final _estanteController  = BehaviorSubject<String>();
  final _nroRegController  = BehaviorSubject<String>();

  //Resuperar datos de string
  Stream<String> get estanteStream  => _estanteController.stream.transform(validarEstante);
  Stream<String> get nroRegStream  => _nroRegController.stream.transform(validarNroReg);

  //Inserta valores en string
  Function(String) get changeEstante  => _estanteController.sink.add;
  Function(String) get changeNroReg  => _nroRegController.sink.add;

  //Obtener ultimo valor ingresado a streams
  String get usuario  => _estanteController.value;
  String get nroReg  => _estanteController.value;

  clear(){
    _estanteController.value = '';
    _nroRegController.value = '';
  }

  setEstante(String valor){
    _estanteController.value = valor;
  }

  setNroReg(String valor){
    _nroRegController.value = valor;
  }

  dispose(){
    _estanteController?.close();
    _nroRegController?.close();
  }

}