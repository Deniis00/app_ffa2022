
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ffa_2022/src/model/nota_pendiente_model.dart';
import 'package:ffa_2022/src/model/teste_movito_devolucion_model.dart';
import 'package:ffa_2022/src/model/teste_nota_seleccionada_model.dart';
import 'package:ffa_2022/src/model/teste_notas_encontradas_model.dart';
import 'package:ffa_2022/src/utils/utils.dart';

class TesteNotasEncontradasProvider{

  Future<List<TesteNotasEncontradasModel>> getListaTesteNotasEncontradas(String filtro, String filtro2) async {

    final data ={
      'filtro' : filtro,
      'valor'  : filtro2
    };
    // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
    final resp = await http.post(Uri.parse(baseUrl() + '/rest.php?tag=consultaNotaParaTest&opcion=1'),
        body: data
    );


    Map<String, dynamic> decodeResp = json.decode(resp.body);

    List<TesteNotasEncontradasModel> list = decodeResp['notas'].isNotEmpty
        ? new ListaTesteNotasEncontradas.fromJsonList(decodeResp['notas']).items
        : [];

    return list;

  }

  Future<List<TesteNotaSeleccionadaModel>> getTesteNotaSeleccionada(String filtro) async {

    final data ={
      'filtro' : filtro
    };
    // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
    final resp = await http.post(Uri.parse(baseUrl() + '/rest.php?tag=consultaNotaSeleccionadaTeste&opcion=1'),
        body: data
    );


    Map<String, dynamic> decodeResp = json.decode(resp.body);

    List<TesteNotaSeleccionadaModel> list = decodeResp['nota'].isNotEmpty
        ? new ListaTesteNotaSeleccionada.fromJsonList(decodeResp['nota']).items
        : [];

    return list;

  }


  Future<List<TesteMotivoDevolucionModel>> getListaTesteMotivoDevolucion() async {

    // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
    final resp = await http.post( Uri.parse(baseUrl() + '/rest.php?tag=consultaTesteMotivoDevolucion'));


    Map<String, dynamic> decodeResp = json.decode(resp.body);

    List<TesteMotivoDevolucionModel> list = decodeResp['motivo'].isNotEmpty
        ? new ListaTesteMotivoDevolucion.fromJsonList(decodeResp['motivo']).items
        : [];

    return list;

  }


  Future <Map>  getTesteInsertaDatos(String datos) async {


    final data ={
      'formdata' : datos
    };


    // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
    final resp = await http.post( Uri.parse(baseUrl() + '/rest.php?tag=consultaTesteInsertaDatos2'),
        body: data
    );


    Map<String, dynamic> decodeResp = json.decode(resp.body);

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



  Future <Map> TesteValidaNota(String nroReg) async {
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

}