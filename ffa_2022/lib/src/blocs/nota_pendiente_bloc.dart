

import 'package:ffa_2022/src/model/nota_pendiente_model.dart';
import 'package:ffa_2022/src/providers/notas_pendientes_providers.dart';
import 'package:rxdart/rxdart.dart';

class NotaPendienteBloc{

  final _notaPendienteController = new BehaviorSubject<List<NotaPendienteModel>>();
  final _notaPendienteProvider = new NotasPendientesProviders();

  Stream<List<NotaPendienteModel>> get estadoServicioStream => _notaPendienteController.stream;

  void listaNotasPendientes(String filtro, String filtro2) async {

    final estados = await _notaPendienteProvider.getListaNotasPendientes(filtro, filtro2);

    _notaPendienteController.sink.add(estados);

  }

  dispose(){
    _notaPendienteController.close();
  }

}