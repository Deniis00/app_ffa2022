import 'dart:async';

import 'package:ffa_2022/src/blocs/validators.dart';
import 'package:rxdart/rxdart.dart';



class EstanteBloc with Validators {

  final _estanteController  = BehaviorSubject<String>();

  //Resuperar datos de string
  Stream<String> get estanteStream  => _estanteController.stream.transform(validarEstante);

  //Inserta valores en string
  Function(String) get changeEstante  => _estanteController.sink.add;

  //Obtener ultimo valor ingresado a streams
  String get usuario  => _estanteController.value;

  clear(){
    _estanteController.value = '';
  }

  setEstante(String valor){
    _estanteController.value = valor;
  }

  dispose(){
    _estanteController?.close();
  }

}