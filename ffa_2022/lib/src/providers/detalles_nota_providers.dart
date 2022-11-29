import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ffa_2022/src/model/detalle_nota_model.dart';
import 'package:ffa_2022/src/utils/utils.dart';

class DetallesNotaProviders {


      Future<List<DetalleNotaModel>> getListaDetallesNota(String filtro) async {

            final data ={
                  'filtro'    : filtro
            };
            // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
            final resp = await http.post(Uri.parse(baseUrl() + '/rest.php?tag=consultaNota&opcion=1'),
                  body: data
            );


            Map<String, dynamic> decodeResp = json.decode(resp.body);

            List<DetalleNotaModel> list = decodeResp['detalle_nota'].isNotEmpty
            ? new ListarDetalleNotas.fromJsonList(decodeResp['detalle_nota']).items
                : [];

            return list;

      }


      Future <Map> separarProducto(String codigo, String estado, String nroReg) async {
            //Future.delayed(Duration.zero, () => mostrarAlerta(context));
            final data ={
                  'codigo' : codigo,
                  'estado' : estado,
                  'filtro' : nroReg
            };
            // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
            final resp = await http.post(Uri.parse(baseUrl() + '/rest.php?tag=separarProductos'),
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


      Future <Map> separarProductoCantidad(String codigo, String estado, String nroReg, String cantidad) async {
            //Future.delayed(Duration.zero, () => mostrarAlerta(context));
            final data ={
                  'opcion' : '1',
                  'codigo' : codigo,
                  'estado' : estado,
                  'filtro' : nroReg,
                  'filtro2': cantidad
            };
            // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
            final resp = await http.post(Uri.parse(baseUrl() + '/rest.php?tag=separarProductoCantidad'),
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


      Future <Map> validaCodigoAlternativo(String codigo, String codigo1) async {
            //Future.delayed(Duration.zero, () => mostrarAlerta(context));
            final data ={
                  'filtro'      : codigo,
                  'filtro2'     : codigo1
            };
            // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
            final resp = await http.post( Uri.parse(baseUrl() + '/rest.php?tag=validaCodigoAlternativo'),
                body: data
            );

            try {

                  Map<String, dynamic> decodeResp = json.decode(resp.body);

                  if (decodeResp['success'] == 1) {
                        int lv_encontrado = decodeResp['encontrado'];

                        return {'ok' : true, 'encontrado' : lv_encontrado};
                  } else {
                        return {'ok': true, 'encontrado' : ''};
                  }
            }catch(error){

                  return {'ok': false, 'encontrado' : ''};
            }

      }


      Future <Map> obtieneEstanteSugerido(String codigo) async {
            //Future.delayed(Duration.zero, () => mostrarAlerta(context));
            final data ={
                  'id'      : codigo
            };
            // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
            final resp = await http.post( Uri.parse(baseUrl() + '/rest.php?tag=obtenerEstanteSugerido'),
                body: data
            );

            try {

                  Map<String, dynamic> decodeResp = json.decode(resp.body);

                  if (decodeResp['success'] == 1) {
                        String lv_estante = decodeResp['estante'];
                        return {'ok' : true, 'estante' : lv_estante};
                  } else {
                        return {'ok': false};
                  }
            }catch(error){

                  return {'ok': false};
            }

      }


      Future <Map> imprimeTicketSeparacion(String nroReg) async {
            //Future.delayed(Duration.zero, () => mostrarAlerta(context));
            final data ={
                  'filtro'  : nroReg
            };
            // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
            final resp = await http.post( Uri.parse(baseUrl() + '/rest.php?tag=imprimeTicketSeparacion'),
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

      Future <Map> agregaEstanteNotaSeparada(String nroReg, String estante) async {

            final data ={
                  'opcion'  : '4',
                  'filtro'  : nroReg,
                  'filtro2' : estante
            };
            // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
            final resp = await http.post( Uri.parse(baseUrl() + '/rest.php?tag=agregaEstanteNotaSeparada'),
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

  Future <Map> validaEstante(String estante) async {

            final data ={
                  'opcion'  : '5',
                  'filtro'  : estante,
                  'filtro2' : estante
            };
            final resp = await http.post( Uri.parse(baseUrl() + '/rest.php?tag=agregaEstanteNotaSeparada'),
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


      Future <Map> volverASeparar(String nroReg) async {
            //Future.delayed(Duration.zero, () => mostrarAlerta(context));
            final data ={
                  'filtro'  : nroReg
            };
            // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
            final resp = await http.post( Uri.parse(baseUrl() + '/rest.php?tag=volverASeparar'),
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


      Future <Map> volverASepararNota2(String idUsuario, String idSeparador, String nroReg, String nombreUsuario) async {
            //Future.delayed(Duration.zero, () => mostrarAlerta(context));
            final data ={
                  'idusuario'   : idUsuario,
                  'idseparador' : idSeparador,
                  'filtro'      : nroReg,
                  'filtro2'      : nombreUsuario
            };
            // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
            final resp = await http.post(Uri.parse(baseUrl() + '/rest.php?tag=volverASepararNota2'),
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


      Future <Map> obtieneAuditoria(String codigo) async {
            //Future.delayed(Duration.zero, () => mostrarAlerta(context));
            final data ={
                  'id'      : codigo
            };
            // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
            final resp = await http.post( Uri.parse(baseUrl() + '/rest.php?tag=obtieneAutidoria'),
                body: data
            );

            try {

                  Map<String, dynamic> decodeResp = json.decode(resp.body);

                  if (decodeResp['success'] == 1) {
                        String lv_auditoria = decodeResp['auditoria'];
                        return {'ok' : true, 'auditoria' : lv_auditoria};
                  } else {
                        return {'ok': false};
                  }
            }catch(error){

                  return {'ok': false};
            }

      }


      Future <Map> obtieneCodigoBase(String codigo) async {
            //Future.delayed(Duration.zero, () => mostrarAlerta(context));
            final data ={
                  'filtro'      : codigo
            };
            // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
            final resp = await http.post( Uri.parse(baseUrl() + '/rest.php?tag=obtieneCodigoBase'),
                body: data
            );

            try {

                  Map<String, dynamic> decodeResp = json.decode(resp.body);

                  if (decodeResp['success'] == 1) {
                        String lv_encontrado = decodeResp['codigo'];

                        return {'ok' : true, 'codigo' : lv_encontrado};
                  } else {
                        return {'ok': false, 'codigo' : "" };
                  }
            }catch(error){

                  return {'ok': false};
            }

      }


      Future <Map> validaSeparadorActual(String codigo, String codigo1) async {
            //Future.delayed(Duration.zero, () => mostrarAlerta(context));
            final data ={
                  'filtro'      : codigo1,
                  'filtro2'     : codigo
            };
            // final o = await Future.delayed(new Duration(milliseconds: 1000),(){});
            final resp = await http.post( Uri.parse(baseUrl() + '/rest.php?tag=validaSeparadorActual'),
                body: data
            );

            try {

                  Map<String, dynamic> decodeResp = json.decode(resp.body);

                  int lv_encontrado = decodeResp['encontrado'];

                  if (lv_encontrado > 0) {



                        return {'ok' : true, 'encontrado' : lv_encontrado};

                  } else {

                        return {'ok': false, 'encontrado' : lv_encontrado};

                  }
            }catch(error){

                  return {'ok': false};
            }

      }


}