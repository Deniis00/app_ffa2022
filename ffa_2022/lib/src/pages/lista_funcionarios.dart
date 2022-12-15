
import 'dart:async';

import 'package:ffa_2022/src/blocs/funcionario_bloc.dart';
import 'package:ffa_2022/src/model/funcionario_model.dart';
import 'package:ffa_2022/src/providers/funcionarios_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ffa_2022/src/blocs/provider.dart';
import 'package:ffa_2022/src/utils/preferencias_usuario.dart';
import 'package:ffa_2022/src/utils/utils.dart';

import 'package:ffa_2022/src/widgets/DividerB.dart';

import '../utils/utils.dart';

class ListaFuncionariosPage extends StatefulWidget{

@override
_ListaFuncionariosPageState createState()=> _ListaFuncionariosPageState();


}

class _ListaFuncionariosPageState extends State<ListaFuncionariosPage> {

  final prefs = new PreferenciasUsuario();
  List<FuncionarioModel> _listaFuncionarios;
  FuncionarioBloc _funcionariosBloc;
  String _filtro_notas = "";
  SearchBar searchBar;

  TextEditingController _controllerS = new TextEditingController();

  _ListaFuncionariosPageState(){

    setGvFiltro("");

    searchBar = new SearchBar(
        controller: _controllerS,
        hintText: "Buscar Funcionario",
        inBar: false,
        closeOnSubmit: false,
        clearOnSubmit: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,

        onSubmitted: (e){

          setState(() {

            _filtro_notas = e;
            setGvFiltro(e);
            //notas.setFiltro(_filtro_notas);

          });



        },
        onCleared: () {

          setState(() {

            _filtro_notas = "";
            setGvFiltro("");

          });

          print("cleared");

        },
        onClosed: () {
          setState(() {

            _filtro_notas = "";
            setGvFiltro("");

          });
          print("closed");
        });


  }



  FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  var _init;


  @override
  void initState(){
    super.initState();


    var _androidInit = AndroidInitializationSettings('ffa-2022');
    var _iOSInit = IOSInitializationSettings();
    _init = InitializationSettings(android: _androidInit, iOS: _iOSInit);
    _notifications.initialize(_init);

  }

  @override
  Widget build(BuildContext context) {

    _funcionariosBloc = Provider.funcionariosBloc(context);
    _funcionariosBloc.listaFuncionarios();

    return  Scaffold(
      appBar: searchBar.build(context)/*appBar()*/,
        body: Column(
          children: [
            Expanded(
                child: ListaFuncionarios(_funcionariosBloc),
            ),
        ],
       )
    );

  }

  Widget ListaFuncionarios(FuncionarioBloc funcionarioBloc){
      return StreamBuilder(
        stream: _funcionariosBloc.estadoServicioStream,
        builder: (BuildContext context, AsyncSnapshot<List<FuncionarioModel>> snapshot){
           if(snapshot.hasData){
              final funcionarios = snapshot.data;

              _listaFuncionarios = funcionarios;

              _listaFuncionarios.retainWhere((e){
                return e.nombreFuncionario.toLowerCase().contains(_filtro_notas.toLowerCase());

              });


              return RefreshIndicator(
                  onRefresh: _actualizaListaFuncionarios,
                  child: ListView.builder(
                    itemCount: funcionarios.length,
                    itemBuilder: (context, i) => Dismissible(

                      confirmDismiss: (direction) async {
                        if(direction == DismissDirection.startToEnd) {
                         _actualizarFuncionario(funcionarios[i]);
                        }
                        return false;
                        },
                      key: UniqueKey(),

                      background: slideRightBackground(),

                      child: Column(
                        children: [
                          Padding(
                            padding:
                            EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
                            child: crearItem(funcionarios[i]),
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
              "llego funcionario",
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

  Widget crearItem(FuncionarioModel funcionario){
    return Container(

      height: 30.0,
      child: ListTile(
        title: Transform.translate(
            offset: Offset(0, -20),
            child: Text('${funcionario.nombreFuncionario}', style: TextStyle(fontSize: 20), overflow: TextOverflow.ellipsis,)
        ),

        onTap: (){

            _actualizarFuncionario(funcionario);

        },
      ),
    );

  }

  Future<Null> _actualizaListaFuncionarios () async {
      return await _funcionariosBloc.listaFuncionarios();
  }


  Widget appBar () {
   return AppBar(
     centerTitle: true,
     iconTheme: IconThemeData(
       color: Colors.white, //change your color here
     ),
     title: const Text(
         'FFA 2022',
         textAlign: TextAlign.center,
         style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)
     ),
     titleTextStyle: TextStyle(
       color: Colors.white,
     ),
     backgroundColor: Colors.red,
     actions: [
       searchBar.getSearchAction(context),
       ],
   );
 }

 _actualizarFuncionario(FuncionarioModel funcionario) async {

   FuncionariosProviders _funcionariosProvider = new FuncionariosProviders();

   try{

     Map info = await _funcionariosProvider.actualizaMuestraFuncionario(context, "${funcionario.idFuncionario}");



     if(!info['ok']){

       EasyLoading.show(status: "No se ha podido Actualizar");

     } else if(info['success'] == 1){

      mostrarMensaje(context, "FFA 2022", "BIENVENIDO..",funcionario.nombreFuncionario);

     }

     EasyLoading.dismiss();
    _actualizaListaFuncionarios();
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

  _buscaNotasSeparadas(){
    Navigator.pushNamed(context, 'busca_notas_separadas');
  }

  void mostrarMensaje(BuildContext context, String titulo, String mensaje, String nombre) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,

      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.red,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Center(
            child: Text(
                titulo,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold,color: Colors.white)
            ),
          ),
          content: new SingleChildScrollView(
            scrollDirection: Axis.vertical, //.horizontal
            child:  Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                  mensaje,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15.0,color: Colors.white)
              ),

                  Text(
                      nombre,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15.0,color: Colors.white)
                  )

                ],
              ),
            ),
          ),
//
          actions: <Widget>[
            Center(
              child: TextButton(
                child: Text('Aceptar', style: TextStyle(color: Colors.white),),
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                },
              ),
            ),
          ],
        );
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Text(
            'FFA 2022',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)
        ),
        titleTextStyle: TextStyle(
          color: Colors.white,
        ),
        backgroundColor: Color.fromRGBO(255, 0, 0, 1),
        actions: [
          searchBar.getSearchAction(context),

        ]
    );
  }



}