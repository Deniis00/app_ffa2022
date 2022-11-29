import 'dart:async';

import 'package:ffa_2022/src/blocs/validators.dart';
import 'package:rxdart/rxdart.dart';



class LoginBloc with Validators {

  final _usuarioController  = BehaviorSubject<String>();

  //Resuperar datos de string
  Stream<String> get usuarioStream  => _usuarioController.stream.transform(validarSeparador);

  //Inserta valores en string
  Function(String) get changeUsuario  => _usuarioController.sink.add;

  //Obtener ultimo valor ingresado a streams
  String get usuario  => _usuarioController.value;

  clearUsuario(){
    _usuarioController.value = '';
  }

  dispose(){
    _usuarioController?.close();
  }

}