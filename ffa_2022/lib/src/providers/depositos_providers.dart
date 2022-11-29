import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ffa_2022/src/model/depositos_model.dart';
import 'package:ffa_2022/src/model/impresora_radar_model.dart';
import 'package:ffa_2022/src/utils/utils.dart';

class DepositosProviders {


      Future<List<DepositosModel>> getListaDepositos(String codigo) async {

            final data ={
                  'id'   : codigo
            };

            // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
            final resp = await http.post( Uri.parse(baseUrl() + '/rest.php?tag=listaDepositos'),
                  body: data
            );


            Map<String, dynamic> decodeResp = json.decode(resp.body);

            List<DepositosModel> list = decodeResp['depositos'].isNotEmpty
            ? new ListaDepositos.fromJsonList(decodeResp['depositos']).items
                : [];

            return list;

      }

      /*Obtiene los depositos ordenado por codigo deposito*/
       Future<List<DepositosModel>> getListaDepositos2(String codigo) async {

            final data ={
                  'id'   : codigo
            };

            // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
            final resp = await http.post( Uri.parse(baseUrl() + '/rest.php?tag=listaDepositos2'),
                  body: data
            );


            Map<String, dynamic> decodeResp = json.decode(resp.body);

            List<DepositosModel> list = decodeResp['depositos'].isNotEmpty
            ? new ListaDepositos.fromJsonList(decodeResp['depositos']).items
                : [];

            return list;

      }

      Future <Map> insertDepositoTransferencia(String codigo, String depositos) async {
            //Future.delayed(Duration.zero, () => mostrarAlerta(context));
            final data ={
                  'id'   : codigo,
                  'data' : depositos
            };
            // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
            final resp = await http.post(Uri.parse(baseUrl() + '/rest.php?tag=insertaDepositoTransferencia'),
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