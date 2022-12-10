import 'dart:convert';
import 'package:ffa_2022/src/model/funcionario_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:ffa_2022/src/model/nota_pendiente_model.dart';
import 'package:ffa_2022/src/utils/utils.dart';

import '../utils/preferencias_usuario.dart';

class FuncionariosProviders {
  final pref = new PreferenciasUsuario();

  Future<List<FuncionarioModel>> getFuncionarios() async {
    final resp = await http.get(
      Uri.parse(pref.apiUrl + '/funcionarios_sin_mostrar'),
    );

    Map<String, dynamic> decodeResp = json.decode(resp.body);

    List<FuncionarioModel> list = decodeResp['data'].isNotEmpty
        ? new ListarFuncionarios.fromJsonList(decodeResp['data']).items
        : [];

    return list;
  }

  Future<Map> actualizaMuestraFuncionario(
      BuildContext context, String idFuncionario) async {
    final resp = await http.put(Uri.parse(
        pref.apiUrl + '/actualizar_funcionario_a_mostrar/' + idFuncionario));

    try {
      Map<String, dynamic> decodeResp = json.decode(resp.body);

      if (decodeResp['success'] == 1) {
        return {'ok': true, 'success': 1};
      } else {
        return {'ok': false};
      }
    } catch (error) {
      return {'ok': false};
    }
  }

  Future<FuncionarioModel> actualizaMuestraFuncionario2(
      BuildContext context, String idFuncionario) async {
    FuncionarioModel retorno = new FuncionarioModel();

    final resp = await http.put(Uri.parse(
        pref.apiUrl + '/actualizar_funcionario_a_mostrar/' + idFuncionario));

    try {
      Map<String, dynamic> decodeResp = json.decode(resp.body);
      retorno = FuncionarioModel.fromJson(decodeResp['funcionario']);
      if (decodeResp['success'] == 1) {
        return retorno;
      } else {
        return retorno;
      }
    } catch (error) {
      return retorno;
    }
  }
}
