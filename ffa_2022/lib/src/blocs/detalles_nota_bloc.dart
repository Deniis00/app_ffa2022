

import 'package:ffa_2022/src/model/detalle_nota_model.dart';
import 'package:ffa_2022/src/providers/detalles_nota_providers.dart';
import 'package:rxdart/rxdart.dart';

class DetallesNotaBloc{

  final _detallesNotaController = new BehaviorSubject<List<DetalleNotaModel>>();
  final _detallesNotaProvider = new DetallesNotaProviders();

  Stream<List<DetalleNotaModel>> get detallesNotaStream => _detallesNotaController.stream;

  void listaDetallesNota(String filtro) async {

    final estados = await _detallesNotaProvider.getListaDetallesNota(filtro);

    _detallesNotaController.sink.add(estados);

  }

  dispose(){
    _detallesNotaController.close();
  }

}