

import 'package:pegasus_flt/src/model/asigna_estante_model.dart';
import 'package:pegasus_flt/src/model/detalle_nota_model.dart';
import 'package:pegasus_flt/src/providers/asigna_estante_providers.dart';
import 'package:pegasus_flt/src/providers/detalles_nota_providers.dart';
import 'package:rxdart/rxdart.dart';

class AsignaEstanteBloc{

  final _asignaEstanteController = new BehaviorSubject<List<AsignaEstanteModel>>();
  final _asignaEstanteProvider = new AsignaEstanteProviders();

  Stream<List<AsignaEstanteModel>> get asignaEstanteStream => _asignaEstanteController.stream;

  void listaAsignaEstantes(String codDeposito, String filtro) async {

    print(codDeposito+" "+filtro);

    final estados = await _asignaEstanteProvider.getListaAsignaEstantes(codDeposito, filtro);

    _asignaEstanteController.sink.add(estados);

  }

  dispose(){
    _asignaEstanteController.close();
  }

}