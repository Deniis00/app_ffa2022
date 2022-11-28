import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pegasus_flt/src/model/asigna_estante_model.dart';
import 'package:pegasus_flt/src/model/impresora_radar_model.dart';
import 'package:pegasus_flt/src/utils/utils.dart';

class AsignaEstanteProviders {


      Future<List<AsignaEstanteModel>> getListaAsignaEstantes(String codDeposito, String filtro) async {

            final data ={
                  'id'     : codDeposito,
                  'filtro' : filtro,
                  'opcion' : '2'
            };
            // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
            final resp = await http.post( Uri.parse(baseUrl() + '/rest.php?tag=consultaStockEstante2'),
                  body: data
            );


            Map<String, dynamic> decodeResp = json.decode(resp.body);

            List<AsignaEstanteModel> list = decodeResp['estantes'].isNotEmpty
            ? new ListarAsignaEstante.fromJsonList(decodeResp['estantes']).items
                : [];

            return list;

      }



      Future <Map> actualizaEstante(String codDeposito, String idRadar, String estante, String codigo, String separador ) async {

            final data ={
                  'opcion'  : '2',
                  'id'      : codDeposito,
                  'valor'   : idRadar,
                  'filtro'  : estante,
                  'codigo'  : codigo,
                  'filtro2' : separador
            };

            final resp = await http.post(Uri.parse(baseUrl() + '/rest.php?tag=actualizaEstante2'),
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