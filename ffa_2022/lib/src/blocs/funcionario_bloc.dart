

import 'package:ffa_2022/src/model/funcionario_model.dart';
import 'package:ffa_2022/src/model/nota_pendiente_model.dart';
import 'package:ffa_2022/src/providers/funcionarios_providers.dart';
import 'package:ffa_2022/src/providers/notas_pendientes_providers.dart';
import 'package:rxdart/rxdart.dart';

class FuncionarioBloc{

  final _notaPendienteController = new BehaviorSubject<List<FuncionarioModel>>();
  final _funcionarioProvider = new FuncionariosProviders();

  Stream<List<FuncionarioModel>> get estadoServicioStream => _notaPendienteController.stream;

  void listaFuncionarios() async {

    final estados = await _funcionarioProvider.getFuncionarios();

    _notaPendienteController.sink.add(estados);

  }

  dispose(){
    _notaPendienteController.close();
  }

}