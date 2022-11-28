import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:pegasus_flt/src/utils/utils.dart';

class UsuarioProvider {

  Future <Map> login(BuildContext context, String usuario, String password, String token) async {
    //Future.delayed(Duration.zero, () => mostrarAlerta(context));

    final data ={
      'user'     : usuario,
      'password' : password,
      'token'    : token
    };
    // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
    final resp = await http.post( Uri.parse(baseUrl() + '/rest.php?tag=probarconexion'),
        body: data
    );

    try {

      Map<String, dynamic> decodeResp = json.decode(resp.body);

      if (decodeResp['success'] == 0) {
        return {'ok': true};
      } else {
        return {'ok': false};
      }
    }catch(error){

      return {'ok': false};
    }

  }

  Future <Map> loginR(BuildContext context, String usuario, String password, String token) async {
    //Future.delayed(Duration.zero, () => mostrarAlerta(context));

    final data ={
      'user'     : usuario,
      'password' : password,
      'token'    : token
    };
    // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
    final resp = await http.post( Uri.parse(baseUrl() + '/login.php?tag=login&User='+usuario+'&Password='+password),
        body: data
    );

    try {

      Map<String, dynamic> decodeResp = json.decode(resp.body);

      if (decodeResp['success'] == 1) {
        return {'ok' : true, 'idUsuario' : decodeResp['idUsuario']};
      } else {
        return {'ok': false};
      }
    }catch(error){

      return {'ok': false};
    }

  }

  Future <Map> loginSeparador(BuildContext context, String separador) async {

    final data ={
      'filtro'    : separador
    };
    // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
    final resp = await http.post( Uri.parse(baseUrl() + '/rest.php?tag=consultaUsuarioSeparador'),
        body: data
    );

    try {

      Map<String, dynamic> decodeResp = json.decode(resp.body);

      if (decodeResp['success'] == 1 && decodeResp['idUsuario'] > 0) {
        return {'ok' : true, 'idUsuario' : decodeResp['idUsuario'], 'nombreUsuario' : decodeResp['nombreUsuario']};
      } else {
        return {'ok': false};
      }
    }catch(error){

      return {'ok': false};
    }

  }


}