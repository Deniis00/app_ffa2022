import 'package:flutter/material.dart';
import 'package:pegasus_flt/src/blocs/asigna_estante_bloc.dart';
import 'package:pegasus_flt/src/blocs/detalles_nota_bloc.dart';
import 'package:pegasus_flt/src/blocs/estante_bloc.dart';

import 'package:pegasus_flt/src/blocs/login_bloc.dart';
import 'package:pegasus_flt/src/blocs/nota_pendiente_bloc.dart';
import 'package:pegasus_flt/src/blocs/nro_reg_bloc.dart';
import 'package:pegasus_flt/src/blocs/separa_por_nota_bloc.dart';
import 'package:pegasus_flt/src/blocs/teste_nota_seleccionada_bloc.dart';
export 'package:pegasus_flt/src/blocs/login_bloc.dart';

class Provider extends InheritedWidget{
  //Bloc Login
  final loginBloc = LoginBloc();
  final _notasPendientesBloc = NotaPendienteBloc();
  final _detalleNotasBloc = DetallesNotaBloc();
  final _estanteBloc = EstanteBloc();
  final _nroRegBloc = NroRegBloc();
  final _asignaEstanteBloc = AsignaEstanteBloc();
  final _testeNotaSeleccionadaBloc = TesteNotaSeleccionadaBloc();
  final _separaPorNota = SeparaPorNotaBloc();

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static Provider _instancia;

  factory Provider({ Key key, Widget child }) {

    if ( _instancia == null ) {
      _instancia = new Provider._internal(key: key, child: child );
    }

    return _instancia;

  }

  Provider._internal({ Key key, Widget child })
      : super(key: key, child: child );

  /*Provider({Key key, Widget child})
    :super(key: key, child: child);*/

  static LoginBloc of ( BuildContext context ){
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }

  static NotaPendienteBloc notasPendientesBloc (BuildContext context ){
    return ( context.dependOnInheritedWidgetOfExactType<Provider>() as Provider )._notasPendientesBloc;
  }

  static DetallesNotaBloc detallesNotaBloc (BuildContext context ){
    return ( context.dependOnInheritedWidgetOfExactType<Provider>() as Provider )._detalleNotasBloc;
  }

  static EstanteBloc estanteBloc (BuildContext context ){
    return ( context.dependOnInheritedWidgetOfExactType<Provider>() as Provider )._estanteBloc;
  }

  static NroRegBloc nroRegBloc (BuildContext context ){
    return ( context.dependOnInheritedWidgetOfExactType<Provider>() as Provider )._nroRegBloc;
  }


  static AsignaEstanteBloc asignaEstanteBloc (BuildContext context ){
    return ( context.dependOnInheritedWidgetOfExactType<Provider>() as Provider )._asignaEstanteBloc;
  }

  static TesteNotaSeleccionadaBloc testeNotaSeleccionadaBloc (BuildContext context ){
    return ( context.dependOnInheritedWidgetOfExactType<Provider>() as Provider )._testeNotaSeleccionadaBloc;
  }

  static SeparaPorNotaBloc separaPorNotaBloc (BuildContext context ){
    return ( context.dependOnInheritedWidgetOfExactType<Provider>() as Provider )._separaPorNota;
  }

}