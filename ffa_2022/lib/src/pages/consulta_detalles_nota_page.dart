import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math' as math;
import 'package:ffa_2022/src/blocs/detalles_nota_bloc.dart';
import 'package:ffa_2022/src/blocs/provider.dart';
import 'package:ffa_2022/src/model/detalle_nota_model.dart';
import 'package:ffa_2022/src/model/nota_pendiente_model.dart';
import 'package:ffa_2022/src/providers/detalles_nota_providers.dart';
import 'package:ffa_2022/src/utils/preferencias_usuario.dart';
import 'package:ffa_2022/src/utils/utils.dart';
import 'package:ffa_2022/src/widgets/DividerA.dart';
import 'package:ffa_2022/src/widgets/DividerB.dart';
import 'package:ffa_2022/src/widgets/app_bar_widget.dart';

class ConsultaDetallesNotaPage extends StatefulWidget {

  NotaPendienteModel _notas;

  ConsultaDetallesNotaPage(this._notas);

  @override
  _ConsultaDetallesNotaPage createState()=> _ConsultaDetallesNotaPage();

}


class _ConsultaDetallesNotaPage extends State<ConsultaDetallesNotaPage> with TickerProviderStateMixin {

  AnimationController _controller;
  static const List<IconData> _icons = const [ Icons.play_arrow, Icons.print, Icons.segment];

  final _detallesNotaProvider = new DetallesNotaProviders();

  List<DetalleNotaModel> _listaDetalleNota;
  DetallesNotaBloc _detallesNotaBloc;

  @override
  void initState() {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {

    final NotaPendienteModel nota = widget._notas;
    _detallesNotaBloc = Provider.detallesNotaBloc(context);
    _detallesNotaBloc.listaDetallesNota( nota.nroReg.toString());


    return WillPopScope(
      child: Scaffold(
        appBar: CustomAppBarSec("Nota Nro. ${nota.nroReg} - Estante ${nota.estante}"),
        body: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                child: Text(nota.observacion, style: TextStyle(fontSize: 18.0),),
              ),
              DividerA(),
              Expanded(
                child: _detallesNotaPendientes(_detallesNotaBloc),
              )
            ]
        ),
        floatingActionButton: new Column(
          mainAxisSize: MainAxisSize.min,
          children: new List.generate(_icons.length, (int index) {
            Widget child = new Container(
              height: 65.0,
              width: 140.0,
              alignment: Alignment.topRight,
              child: new ScaleTransition(
                scale: new CurvedAnimation(
                  parent: _controller,
                  curve: new Interval(
                      0.0,
                      1.0 - index / _icons.length / 2.0,
                      curve: Curves.easeOut
                  ),
                ),
                child: new FloatingActionButton.extended(
                  heroTag: null,
                  backgroundColor: Colors.white,
                  label: Text(index == 0 ? "Separar ":index == 1 ? "Imprimir" : "Detalles"),
                  icon: new Icon(_icons[index], color: Colors.black),
                  onPressed: () {

                    //Separar
                    if(index == 0){
                      _volverASepararNota2();
                    }

                    if(index == 1){
                      _imprimeTicketSeparacion();
                    }
                    
                    if(index == 2){
                      _obtenerAuditoria();
                    }


                  },
                ),
              ),
            );
            return child;
          }).toList()..add(
            Container(
              height: 60.0,
              width: 140.0,
              alignment: Alignment.topRight,
              child: new FloatingActionButton(
                heroTag: null,
                child: new AnimatedBuilder(
                  animation: _controller,
                  builder: (BuildContext context, Widget child) {
                    return new Transform(
                      transform: new Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                      alignment: FractionalOffset.center,
                      child: new Icon(_controller.isDismissed ? Icons.menu_open : Icons.close),
                    );
                  },
                ),
                onPressed: () {
                  if (_controller.isDismissed) {
                    _controller.forward();
                  } else {
                    _controller.reverse();
                  }
                },
              ),
            )
          ),
        ),
      ),
    );


  }

  Widget _detallesNotaPendientes(DetallesNotaBloc detallesNotaBloc){
    return StreamBuilder(
        stream: detallesNotaBloc.detallesNotaStream,
        builder: (BuildContext context, AsyncSnapshot<List<DetalleNotaModel>> snapshot){
          if(snapshot.hasData){
            final notas = snapshot.data;

            _listaDetalleNota = notas;

            return RefreshIndicator(
                onRefresh: _consultaDetallesNota,
                child: ListView.builder(
                  itemCount: notas.length,
                  itemBuilder: (context, i) => Column(
                      children: [
                        _crearItem(notas[i]),
                        DividerB()
                      ],
                    ),

                )
            );

          }else{
            return Center( child: CircularProgressIndicator());
          }
        }
    );
  }



  Widget _crearItem(DetalleNotaModel producto){

   return Column(
     children: [
       Container(
           margin: EdgeInsets.all(15),
           child: Row(
             children: [
               Expanded(
                   flex: 10,
                   child: Column(
                     children: [
                       Row(
                         children: [
                          Column(children: [
                               Container(height: 35.0, child:  Column(
                                   children: [
                                     Text("${producto.codigo}", style: TextStyle(fontSize: 15.0),),
                                   ],
                                 ),
                               )
                             ]),
                           SizedBox(width: 10,),
                            Expanded(child: Column(
                             children: [
                               Container(height: 35.0, child:  Column(
                                   children: [
                                     Text(producto.descripcion_producto,  textAlign: TextAlign.left, style: TextStyle(fontSize: 14.0),),
                                   ],
                               ),
                               )
                             ],
                           )),
//                           Column(
//                             children: [
//                               Text("${producto.codigo}", style: TextStyle(fontSize: 15.0),),
//                             ],
//                           ),
//                           SizedBox(width: 10,),
//                           Expanded(child: Column(
//                             children: [
//                               Text(producto.descripcion_producto,  textAlign: TextAlign.center, style: TextStyle(fontSize: 15.0), overflow: TextOverflow.ellipsis,),
//                             ],
//                           ))
//                           ,
                         ],
                       ),
                       SizedBox(height: 10,),
                       Row(
                         children: [
                           Column(
                             children: [
                               Text("${producto.estante}", style: TextStyle(fontSize: 15.0),),
                             ],
                           ),
                          // Expanded(child: SizedBox()),
                           SizedBox(width: 40,),
                           Column(
                             children: [
                               Text("${producto.cantidad}", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                             ],
                           ),
                           //Expanded(child: SizedBox()),
                           Expanded(child: Column(
                             children: [
                               Text("${producto.cod_deposito}", textAlign: TextAlign.center, style: TextStyle(fontSize: 15.0),overflow: TextOverflow.ellipsis,),
                             ],
                           ))
                         ],
                       ),
                     ],
                   )
               ),
             ],
           )

       )
     ],
   );
  }

  Future<Null> _consultaDetallesNota () async {
    return await _detallesNotaBloc.listaDetallesNota(widget._notas.nroReg.toString());
  }



  void _imprimeTicketSeparacion() async{

    DetallesNotaProviders provider = new DetallesNotaProviders();

    EasyLoading.show(status: "Cargando..");

    try {
      await provider.imprimeTicketSeparacion(widget._notas.nroReg.toString());

      EasyLoading.dismiss();

      mostrarConfirmarcion(context, "Ticket Impreso!!");
    }catch(error){
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: "Problemas de Conexion, vuelva a intentar",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2
      );
    }

  }

  void _volverASeparar() async{

    DetallesNotaProviders provider = new DetallesNotaProviders();

    EasyLoading.show(status: "Cargando..");

    try {
      await provider.volverASeparar(widget._notas.nroReg.toString());

      EasyLoading.dismiss();

      mostrarConfirmarcion(context, "Nota en Separacion!!");
    }catch(error){
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: "Problemas de Conexion, vuelva a intentar",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2
      );
    }

  }

  void _volverASepararNota2() async {

    final _prefs = new PreferenciasUsuario();

    DetallesNotaProviders provider = new DetallesNotaProviders();

    EasyLoading.show(status: "Cargando..");

    try {
      await provider.volverASepararNota2(
          _prefs.idUsuario, _prefs.separador, widget._notas.nroReg.toString(),
          _prefs.nombreUsuario);

      EasyLoading.dismiss();

      mostrarConfirmarcion(context, "Nota en Separacion!!");
    }catch(error){
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: "Problemas de Conexion, vuelva a intentar",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2
      );
    }

  }

  void _obtenerAuditoria() async{

    DetallesNotaProviders provider = new DetallesNotaProviders();

    EasyLoading.show(status: "Cargando..");

    try {
      Map info = await provider.obtieneAuditoria(
          widget._notas.nroReg.toString());

      EasyLoading.dismiss();

      if (info['ok']) {
        String lv_auditoria = info['auditoria'];
        mostrarMensaje(context, "Detalles", lv_auditoria);
      }
    }catch(error){
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: "Problemas de Conexion, vuelva a intentar",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2
      );
    }

  }

}
