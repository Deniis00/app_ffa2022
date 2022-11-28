

import 'package:pegasus_flt/src/model/teste_nota_seleccionada_model.dart';
import 'package:pegasus_flt/src/providers/teste_notas_encontradas_provider.dart';
import 'package:rxdart/rxdart.dart';


class TesteNotaSeleccionadaBloc{

  final _testeNotaSeleccionadaController = new BehaviorSubject<List<TesteNotaSeleccionadaModel>>();
  final _testeNotaSeleccionadaProvider = new TesteNotasEncontradasProvider();

  Stream<List<TesteNotaSeleccionadaModel>> get testeNotaSeleccionadaStream => _testeNotaSeleccionadaController.stream;

  void listaTesteNotaSeleccionada(String filtro) async {

    _testeNotaSeleccionadaController.sink.add(null);

    final estados = await _testeNotaSeleccionadaProvider.getTesteNotaSeleccionada(filtro);

    _testeNotaSeleccionadaController.sink.add(estados);

  }

  dispose(){
    _testeNotaSeleccionadaController.close();
  }

}