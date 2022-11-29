import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ffa_2022/src/model/impresora_radar_model.dart';
import 'package:ffa_2022/src/utils/utils.dart';

class ImpresoraRadarProviders {


      Future<List<ImpresoraRadarModel>> getListaImpresorasRadar(String filtro) async {

            final data ={
                  'filtro'    : filtro
            };
            // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
            final resp = await http.post( Uri.parse(baseUrl() + '/rest.php?tag=listaImpresorasRadar'),
                  body: data
            );


            Map<String, dynamic> decodeResp = json.decode(resp.body);

            List<ImpresoraRadarModel> list = decodeResp['impresoras'].isNotEmpty
            ? new ListaImpresoraRadar.fromJsonList(decodeResp['impresoras']).items
                : [];

            return list;

      }

}