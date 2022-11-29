
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ffa_2022/src/blocs/nota_pendiente_bloc.dart';
import 'package:ffa_2022/src/blocs/provider.dart';
import 'package:ffa_2022/src/model/nota_pendiente_model.dart';
import 'package:ffa_2022/src/providers/notas_pendientes_providers.dart';
import 'package:ffa_2022/src/utils/preferencias_usuario.dart';

import 'package:ffa_2022/src/utils/utils.dart';
import 'package:ffa_2022/src/widgets/DividerA.dart';
import 'package:ffa_2022/src/widgets/DividerB.dart';

import '../utils/utils.dart';

class NotasPendientesPage extends StatefulWidget{

@override
_NotasPendientesPageState createState()=> _NotasPendientesPageState();


}

class _NotasPendientesPageState extends State<NotasPendientesPage> {

  final prefs = new PreferenciasUsuario();
  List<NotaPendienteModel> _listaNotasPendientes;
  NotaPendienteBloc _notasPendientesBlock;
  Timer _timer;
  bool _ejecutarTimer = true;
  bool _ejecutarTimerNotificacion = true;
  bool _cancelTimer = false;

  FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  var _init;
  Timer _timerNoti;


  @override
  void initState(){
    super.initState();

    /*final pushProvider = new PushNotificationProvider();
    pushProvider.initNotification();

    pushProvider.mensajesStream.listen((valor) {
      print('argumento desde main $valor');
      //navigatorKey.currentState.pushNamed('home');
    });*/

    var _androidInit = AndroidInitializationSettings('pgs_icon');
    var _iOSInit = IOSInitializationSettings();
    _init = InitializationSettings(android: _androidInit, iOS: _iOSInit);
    _notifications.initialize(_init);

  }

  @override
  Widget build(BuildContext context) {

    _notasPendientesBlock = Provider.notasPendientesBloc(context);
    _notasPendientesBlock.listaNotasPendientes(prefs.idUsuario, prefs.radar);

    _timer = Timer.periodic(Duration(seconds: 3), (Timer t) async {

      if(_ejecutarTimer == true) {

        _ejecutarTimer = false;

        await _notasPendientesBlock.listaNotasPendientes(
            prefs.idUsuario, prefs.radar);

        _ejecutarTimer = true;


      }

      if(_cancelTimer){
        t.cancel();
      }

    });

    _timerNoti = Timer.periodic(Duration(seconds: 5), (Timer t) async {

      if(_ejecutarTimerNotificacion) {
          _ejecutarTimerNotificacion = false;
          await _notificaNotas(prefs);
          _ejecutarTimerNotificacion = true;
      }

      if(_cancelTimer){
        t.cancel();
      }

    });


    return  Scaffold(
      appBar: appBar(),
        body: Column(
          children: [
            Container(
                margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                child: Column(
                  children: [
                    Text("Notas Pendientes", style: TextStyle(fontSize: 23.0),),
                    _txtUltimaNota(),
                  ],
                )
            ),
            DividerA(),
            Expanded(
                child: ListaNotasPendientes(_notasPendientesBlock),
            ),
            Text("Ver. "+version(), style: TextStyle(fontWeight: FontWeight.bold),),
        ],
       )
    );

  }

  Widget ListaNotasPendientes(NotaPendienteBloc notasPendientesBlock){
      return StreamBuilder(
        stream: notasPendientesBlock.estadoServicioStream,
        builder: (BuildContext context, AsyncSnapshot<List<NotaPendienteModel>> snapshot){
           if(snapshot.hasData){
              final notas = snapshot.data;

              _listaNotasPendientes = notas;

              return RefreshIndicator(
                  onRefresh: _consultaNotasPendientes,
                  child: ListView.builder(
                    itemCount: notas.length,
                    itemBuilder: (context, i) => Dismissible(
                     // direction: DismissDirection.startToEnd,
                      confirmDismiss: (direction) async {
                        if(direction == DismissDirection.startToEnd) {
                          _consultaSeprar(notas[i]);
                        }else if(direction == DismissDirection.endToStart){
                          _imprimirNota(notas[i]);
                        }
                        return false;
                        },
                      key: UniqueKey(),
                      //key: Key(notas.toString()),
                      background: slideRightBackground(),
                      //secondaryBackground: slideLeftBackground(),
                      //onDismissed: (e) => _consultaSeprar(notas[i]),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                            EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
                            child: crearItem(notas[i]),
                          ),
                          DividerB()
                        ],
                      ),
                    ),
                  )
              );

           }else{
             return Center( child: CircularProgressIndicator());
           }
        }
      );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              "Separar",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.arrow_right,
              color: Colors.white,
            ),
            Text(
              "Separar",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            Expanded(
                child: SizedBox(
                width: 20,
                ),
            )
            ,
            Icon(
              Icons.print,
              color: Colors.white,
            ),
            Text(
              "Imprimir",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  Widget crearItem(NotaPendienteModel notas){
    return Container(

      height: 30.0,
      child: ListTile(
        title:  Transform.translate(
            offset: Offset(0, -20),
            child: Row(
              children: <Widget>[
                  Column(
                    children: <Widget>[
                         Text('Nro. Reg.: ${notas.nroReg}', style: TextStyle(fontSize: 20),)
                    ],
                  ),
                  Spacer(),
                  notas.estante != null ?  Column(
                    children: <Widget>[
                        Text('Estante: ${notas.estante}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                    ],
                  ): Text(""),
              ],
            )
        ),
        subtitle: Transform.translate(
            offset: Offset(0, -20),
            child: Text('Cliente: ${notas.cliente}', style: TextStyle(fontSize: 18), overflow: TextOverflow.ellipsis,)
        ),
        trailing: Transform.translate(
            offset: Offset(0, -20),
            child: notas.importancia == 0
                ? notas.transferencias > 0
                ? Icon(Icons.compare_arrows, color: Colors.blueAccent,)
                :Icon(Icons.arrow_right, color: Colors.green)
                :Icon(Icons.error_outline, color: Colors.deepOrange,)
        ),
        onTap: (){
          _consultaSeprar(notas);
        },
      ),
    );

  }

  Future<Null> _consultaNotasPendientes () async {
      return await _notasPendientesBlock.listaNotasPendientes(prefs.idUsuario, prefs.radar);
  }

  void _consultaNotasPendientesVoid () async {
    EasyLoading.show(status: "Cargando..");
    await _notasPendientesBlock.listaNotasPendientes(prefs.idUsuario, prefs.radar);
    EasyLoading.dismiss();
  }

  _consultaSeprar(NotaPendienteModel notas) {


     MensajeConfirmacion(context, "Aviso", "Separar Pedido Nro. ${notas.nroReg}?")
          .then((value) async {
              if(value != null) {
                if (value) {

                  NotasPendientesProviders _notasPendientesProvider = new NotasPendientesProviders();

                  EasyLoading.show(status: "Cargando..");

                  try{

                            Map info = await _notasPendientesProvider.iniciaSeparacion(context, prefs.idUsuario, prefs.separador, notas.nroReg.toString(), prefs.nombreUsuario);

                            EasyLoading.dismiss();

                            if(!info['ok']){

                              await mostrarAlerta(context, 'Nota ya no se se encuentra disponible para separar!!');
                              _consultaNotasPendientesVoid();

                            } else if(info['success'] == 1){

                               await Navigator.pushNamed(context, 'detalles_nota', arguments: notas);
                               _consultaNotasPendientesVoid();

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

      });
  }

  _imprimirNota(NotaPendienteModel notas) {

    if(notas.volverSeparar == 1){
      mostrarAlerta(context, "No se puede imprimir nota re-separada !!");
      return;
    }

    MensajeConfirmacion(context, "Aviso", "Imprimir Nota Nro. ${notas.nroReg}?")
        .then((value) async {
      if(value != null) {
        if (value) {

          NotasPendientesProviders _notasPendientesProvider = new NotasPendientesProviders();

          EasyLoading.show(status: "Cargando..");

          try {
            Map info = await _notasPendientesProvider.imprimirNota(
                "", "", notas.nroReg.toString(), prefs.separador);

            EasyLoading.dismiss();

            if (!info['ok']) {
              await mostrarAlerta(context,
                  'Nota ya no se se encuentra disponible para separar!!');
              _consultaNotasPendientesVoid();
            } else {
              //mostrarMensaje(context, "Aviso", "Nota Impresa");
              MensajeSiNo(context, "Impresion", "Se imprimir correctamente?")
                  .then((resp) {
                if (!resp) {
                  _imprimirNota(notas);
                }
              });
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
    });
  }


  Widget _txtUltimaNota() {

    NotasPendientesProviders provider = new NotasPendientesProviders();

   return FutureBuilder<Map>(
      future: provider.obtieneUltimaNota(prefs.idUsuario.toString()), // a Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        if(snapshot.hasData){

         Map datos = snapshot.data;

          if(datos['ok']){
            return Text("Ultima Nota: "+datos['ultima_nota'], style: TextStyle(fontSize: 17.0),);
          }else {
            return Text("", style: TextStyle(fontSize: 17.0),);
          }
        }else{
          return  Text(" ", style: TextStyle(fontSize: 17.0),);
        }
      },
    );

  }


  _notificaNotas(PreferenciasUsuario _prefs) async {
    final _notaProv = new NotasPendientesProviders();
    Map info = await _notaProv.listaNotificaNota(_prefs.idUsuario, _prefs.radar);

    if(info['ok']){
      if(info['notificar'] > 0){


        _notifications.show(
            0,
            "Notificacion",
            "Nuevas Notas para Separar",
            NotificationDetails(
                android: AndroidNotificationDetails(
                    "Notificacion",
                    "Nuevas Notas para Separar",
                    ""
                ),
                iOS: IOSNotificationDetails()
            )
        );


      }

    }
  }


 Widget appBar () {
   return AppBar(
     centerTitle: false,
     title: Text('${prefs.nombreUsuario} - Radar ${prefs.radar}'),
     actions: [
       IconButton(
         icon: Icon(Icons.border_bottom, size: 30.0,),
         color: Colors.white,
         onPressed: () {
            _separarPorNota();
         },
       ),
       IconButton(
         icon: Icon(Icons.archive, size: 30.0,),
         color: Colors.white,
         onPressed: () {
           _asignaEstante();
         },
       ),
       IconButton(
         icon: Icon(Icons.search, size: 30.0,),
         color: Colors.white,
         onPressed: () {

           _buscaNotasSeparadas();

         },
       ),
       IconButton(
         icon: Icon(Icons.logout, size: 30.0,),
         color: Colors.white,
         onPressed: () {
           _logOut(context);
         },
       )
     ],
   );
 }


  _logOut(BuildContext c) async {
    //final usuarioProvider = new UsuarioProvider();
    //Map info = await usuarioProvider.desactivarTokenMensaje(c, prefs.usuario, prefs.password, prefs.token);
    //if(!info['ok']){
    //mostrarAlerta(c, 'Error al desconectar!!');
    //}else {

    prefs.nombreUsuario = '';
    prefs.separador = '';
    prefs.idUsuario = '0';
    _cancelTimer = true;
    Navigator.pushReplacementNamed(c, 'login');

    //}

  }

  _buscaNotasSeparadas(){
    Navigator.pushNamed(context, 'busca_notas_separadas');
  }

  _asignaEstante(){
    Navigator.pushNamed(context, 'asigna_estante');
  }

  _separarPorNota(){
    Navigator.pushNamed(context, 'separar_por_nota');
  }

}