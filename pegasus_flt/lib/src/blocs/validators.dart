import 'dart:async';
import 'package:pegasus_flt/src/utils/utils.dart';



class Validators {

  final validarSeparador = StreamTransformer<String, String>.fromHandlers(
      handleData: ( separador, sink){
        if ( isNumeric(separador)){
          sink.add(separador);
        }else{
          sink.addError('Ingresar Nro. Separador!!');
        }
      }
  );

  final validarEstante = StreamTransformer<String, String>.fromHandlers(
      handleData: ( estante, sink){
        if ( estante.length > 0){
          sink.add(estante);
        }else{
          sink.addError('Ingresar Codigo De Estante!!');
        }
      }
  );

  final validarNroReg = StreamTransformer<String, String>.fromHandlers(
      handleData: ( estante, sink){
        if ( estante.length > 0){
          sink.add(estante);
        }else{
          sink.addError('Ingresar Nro. de Nota!!');
        }
      }
  );

}