import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:pegasus_flt/src/model/nota_pendiente_model.dart';
import 'package:pegasus_flt/src/utils/utils.dart';

class NotasPendientesProviders {

  Future<List<NotaPendienteModel>> getListaNotasPendientes(String filtro, String filtro2) async {

    final data ={
      'filtro'    : filtro,
      'filtro2'   : filtro2
    };
    // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
    final resp = await http.post(Uri.parse(baseUrl() + '/rest.php?tag=consultaNotasPendientes1&opcion=1'),
        body: data
    );


    Map<String, dynamic> decodeResp = json.decode(resp.body);

    List<NotaPendienteModel> list = decodeResp['notas_pendientes'].isNotEmpty
        ? new ListarNotasPendientes.fromJsonList(decodeResp['notas_pendientes']).items
        : [];

    return list;

  }


  Future <Map<String, dynamic>> getObservacionNota(BuildContext context, String nroReg) async {
    //Future.delayed(Duration.zero, () => mostrarAlerta(context));
    final data ={
      'filtro'    : nroReg
    };
    // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
    final resp = await http.post(Uri.parse(baseUrl() + '/rest.php?tag=consultaObservacionNota'),
        body: data
    );

    try {

      Map<String, dynamic> decodeResp = json.decode(resp.body);

      if (decodeResp['success'] == 1) {
        return {'ok' : true, 'observacion_nota' : decodeResp['observacion_nota']};
      } else {
        return {'ok': false};
      }
    }catch(error){

      return {'ok': false};
    }

  }


  Future <Map> iniciaSeparacion(BuildContext context, String idUsuario, String idSeparador, String nroReg, String nombreUsuario) async {
    //Future.delayed(Duration.zero, () => mostrarAlerta(context));
    final data ={
      'idusuario'   : idUsuario,
      'idseparador' : idSeparador,
      'filtro'      : nroReg,
      'filtro2'      : nombreUsuario
    };
    // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
    final resp = await http.post(Uri.parse(baseUrl() + '/rest.php?tag=inicioSepararNotasPendiente'),
        body: data
    );

    try {

      Map<String, dynamic> decodeResp = json.decode(resp.body);

      if (decodeResp['success'] == 1) {
        return {'ok' : true, 'success' : 1};
      } else {
        return {'ok': false};
      }
    }catch(error){

      return {'ok': false};
    }

  }


  Future <Map> cancelaSeparacion(BuildContext context, String idUsuario, String idSeparador, String nroReg) async {
    //Future.delayed(Duration.zero, () => mostrarAlerta(context));
    final data ={
      'idusuario'   : idUsuario,
      'idseparador' : idSeparador,
      'filtro'      : nroReg
    };
    // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
    final resp = await http.post(Uri.parse(baseUrl() + '/rest.php?tag=cancelaSepararNotasPendiente'),
        body: data
    );

    try {

      Map<String, dynamic> decodeResp = json.decode(resp.body);

      if (decodeResp['success'] == 1) {
        return {'ok' : true};
      } else {
        return {'ok': false};
      }
    }catch(error){

      return {'ok': false};
    }

  }


  Future <Map> finalizaSeparacion(String nroReg, String estante) async {
    //Future.delayed(Duration.zero, () => mostrarAlerta(context));
    final data ={
      'filtro2' : estante,
      'filtro'  : nroReg
    };
    // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
    final resp = await http.post( Uri.parse(baseUrl() + '/rest.php?tag=finalizaSepararNotaPendiente'),
        body: data
    );

    try {

      Map<String, dynamic> decodeResp = json.decode(resp.body);

      if (decodeResp['success'] == 1) {
        return {'ok' : true};
      } else {
        return {'ok': false};
      }

    }catch(error){

      return {'ok': false};

    }

  }


  Future <Map> imprimirNota(String codigo, String estado, String nroReg, String idSeparador) async {
    //Future.delayed(Duration.zero, () => mostrarAlerta(context));
    final data ={
      'codigo'      : codigo,
      'estado'      : estado,
      'filtro'      : nroReg,
      'idseparador' : idSeparador
    };
    // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
    final resp = await http.post(Uri.parse(baseUrl() + '/rest.php?tag=imprimirNota'),
        body: data
    );

    try {

      Map<String, dynamic> decodeResp = json.decode(resp.body);

      if (decodeResp['success'] == 1) {
        return {'ok' : true};
      } else {
        return {'ok': false};
      }
    }catch(error){

      return {'ok': false};
    }

  }


  Future <Map> validaNota(String nroReg) async {
    //Future.delayed(Duration.zero, () => mostrarAlerta(context));
    final data ={
      'filtro'      : nroReg
    };
    // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
    final resp = await http.post( Uri.parse(baseUrl() + '/rest.php?tag=validaExisteNota'),
        body: data
    );

    try {

      Map<String, dynamic> decodeResp = json.decode(resp.body);

      if (decodeResp['success'] == 1) {

        List<NotaPendienteModel> list = decodeResp['notas_pendientes'].isNotEmpty
            ? new ListarNotasPendientes.fromJsonList(decodeResp['notas_pendientes']).items
            : [];

        return {'ok' : true, 'nota' : list[0]};
      } else {
        return {'ok': false};
      }
    }catch(error){

      return {'ok': false};
    }

  }

  Future <Map> varificaExisteSeparacion(String nroReg) async {
        //Future.delayed(Duration.zero, () => mostrarAlerta(context));
    final data ={
      'opcion':'10',
      'filtro': nroReg
    };
    // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
    final resp = await http.post( Uri.parse(baseUrl() + '/rest.php?tag=verificaExisteSeparacion'),
        body: data
    );

    try {

      Map<String, dynamic> decodeResp = json.decode(resp.body);

      if (decodeResp['success'] == 1) {
        String existe_separacion = decodeResp['existe_separacion'].toString();
        return {'ok' : true, 'existe_separacion' : existe_separacion};
      } else {
        return {'ok': false};
      }

    }catch(error){

      return {'ok': false};
    }  
  }

  Future <Map> verificaExisteTransferencia(String nroReg) async {
    //Future.delayed(Duration.zero, () => mostrarAlerta(context));
    final data ={
      'opcion':'11',
      'filtro': nroReg
    };
    // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
    final resp = await http.post( Uri.parse(baseUrl() + '/rest.php?tag=verificaExisteTransferencia'),
        body: data
    );

    try {

      Map<String, dynamic> decodeResp = json.decode(resp.body);

      if (decodeResp['success'] == 1) {
        String existe_separacion = decodeResp['existe_separacion'].toString();
        return {'ok' : true, 'existe_separacion' : existe_separacion};
      } else {
        return {'ok': false};
      }

    }catch(error){

      return {'ok': false};
    }
  }

  Future <Map> validaNotaEnSistema(String nroReg) async {
    //Future.delayed(Duration.zero, () => mostrarAlerta(context));
    final data ={
      'filtro'      : nroReg
    };
    // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
    final resp = await http.post( Uri.parse(baseUrl() + '/rest.php?tag=validaExisteNotaEnSistema'),
        body: data
    );

    try {

      Map<String, dynamic> decodeResp = json.decode(resp.body);

      if (decodeResp['success'] == 1) {

        List<NotaPendienteModel> list = decodeResp['notas_pendientes'].isNotEmpty
            ? new ListarNotasPendientes.fromJsonList(decodeResp['notas_pendientes']).items
            : [];

        return {'ok' : true, 'nota' : list[0]};
      } else {
        return {'ok': false};
      }
    }catch(error){

      return {'ok': false};
    }

  }


  Future <Map> listaNotificaNota(String id_usuario, String radar) async {
    //Future.delayed(Duration.zero, () => mostrarAlerta(context));
    final data ={
      'filtro' : id_usuario,
      'filtro2': radar
    };
    // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
    final resp = await http.post( Uri.parse(baseUrl() + '/rest.php?tag=consultaNotasNotificar'),
        body: data
    );

    try {

      Map<String, dynamic> decodeResp = json.decode(resp.body);

      if (decodeResp['success'] == 1) {

        return {'ok' : true, 'notificar' : decodeResp['notificar']};
      } else {
        return {'ok': false};
      }
    }catch(error){

      return {'ok': false};
    }

  }


  Future <Map> obtieneUltimaNota(String idUsuario) async {
    //Future.delayed(Duration.zero, () => mostrarAlerta(context));
    final data ={
      'id'      : idUsuario
    };
    // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
    final resp = await http.post( Uri.parse(baseUrl() + '/rest.php?tag=obtieneUtlimaNotaSeparada'),
        body: data
    );

    try {

      Map<String, dynamic> decodeResp = json.decode(resp.body);

      if (decodeResp['success'] == 1) {
        String lv_ultima_nota = decodeResp['ultima_nota'].toString();
        return {'ok' : true, 'ultima_nota' : lv_ultima_nota};
      } else {
        return {'ok': false};
      }

    }catch(error){

      return {'ok': false};
    }

  }


  Future <Map> separacionPorNota(String nroReg, String estante, String idSeparador, String usuario) async {
    //Future.delayed(Duration.zero, () => mostrarAlerta(context));
    final data ={
      'filtro2' : estante,
      'filtro'  : nroReg,
      'idseparador': idSeparador,
      'usuario': usuario
    };
    // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
    final resp = await http.post( Uri.parse(baseUrl() + '/rest.php?tag=separacionPorNota'),
        body: data
    );

    try {

      Map<String, dynamic> decodeResp = json.decode(resp.body);

      if (decodeResp['success'] == 1) {
        return {'ok' : true};
      } else {
        return {'ok': false};
      }

    }catch(error){

      return {'ok': false};

    }

  }


}