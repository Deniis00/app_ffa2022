
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pegasus_flt/src/blocs/asigna_estante_bloc.dart';
import 'package:pegasus_flt/src/blocs/provider.dart';
import 'package:pegasus_flt/src/model/asigna_estante_model.dart';
import 'package:pegasus_flt/src/model/depositos_model.dart';
import 'package:pegasus_flt/src/providers/asigna_estante_providers.dart';
import 'package:pegasus_flt/src/providers/depositos_providers.dart';
import 'package:pegasus_flt/src/providers/detalles_nota_providers.dart';
import 'package:pegasus_flt/src/utils/preferencias_usuario.dart';
import 'package:pegasus_flt/src/utils/utils.dart';
import 'package:pegasus_flt/src/widgets/DividerA.dart';
import 'package:pegasus_flt/src/widgets/DividerB.dart';


class AsignaEstantePage extends StatefulWidget{

@override
_AsignaEstantePageState createState()=> _AsignaEstantePageState();


}

class _AsignaEstantePageState extends State<AsignaEstantePage> with TickerProviderStateMixin {

  TextEditingController _controller = new TextEditingController();
  static const List<IconData> _icons = const [ Icons.archive];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _seleccionado = "";
  bool _ejecutaTimer = true;

  SearchBar searchBar;
  final prefs = new PreferenciasUsuario();
  List<AsignaEstanteModel> _listaAsignaEstante;
  AsignaEstanteBloc _asignaEstantesBloc;
  Timer _timer;
  String _filtro_notas = "";
  bool _cancelTimer = false;


  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: Text("Asignar Estante"),
        actions: [
          searchBar.getSearchAction(context),
          IconButton(
            icon: Icon(Icons.settings_overscan, size: 30.0,),
            color: Colors.white,
            onPressed: () async {

              String barcodeScanRes = "";

             // final bar = await BarcodeScanner.scan();
              //barcodeScanRes  = bar;
              try {
                barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                    '#ff6666', 'Cancel', true, ScanMode.QR);
                print(barcodeScanRes);
              } catch(ex) {
                barcodeScanRes = '-1';
              }



              if(barcodeScanRes == "-1" || barcodeScanRes == null){
                barcodeScanRes = "";
              }

              //barcodeScanRes = "859647";

              if(barcodeScanRes.length > 0){



                DetallesNotaProviders _notasPendientesProvider = new DetallesNotaProviders();

                EasyLoading.show(status: "Cargando..");

                try {
                  Map info = await _notasPendientesProvider.obtieneCodigoBase(
                      barcodeScanRes);

                  EasyLoading.dismiss();

                  if (info['codigo'].length > 0) {
                    searchBar.beginSearch(context);

                    _controller.text = info['codigo'];

                    _filtro_notas = info['codigo'];
                  } else {
                    mostrarAlerta(context, 'Producto no encontrado !!');
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

            },
          ),
        ]
    );
  }

  _AsignaEstantePageState(){
    searchBar = new SearchBar(
        controller: _controller,
        hintText: "Buscar",
        inBar: false,
        closeOnSubmit: false,
        clearOnSubmit: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: (e){

          setState(() {

              _filtro_notas = e;

              _asignaEstantesBloc.listaAsignaEstantes(_seleccionado, _filtro_notas);

          });

          print("submite");

        },
        onCleared: () {

          setState(() {

            _filtro_notas = "";

            _asignaEstantesBloc.listaAsignaEstantes(_seleccionado, _filtro_notas);

          });

          print("cleared");

        },
        onClosed: () {
          setState(() {

            _filtro_notas = "";

            _asignaEstantesBloc.listaAsignaEstantes(_seleccionado, _filtro_notas);

          });
          print("closed");
        });



  }


  @override
  Widget build(BuildContext context) {

    _asignaEstantesBloc = Provider.asignaEstanteBloc(context);
    _asignaEstantesBloc.listaAsignaEstantes(_seleccionado, _filtro_notas);

    _timer = Timer.periodic(Duration(seconds: 3), (Timer t) async  {

      if(_ejecutaTimer) {

        _ejecutaTimer = false;
        await _asignaEstantesBloc.listaAsignaEstantes(_seleccionado, _filtro_notas);
        _ejecutaTimer = true;

      }

      if(_cancelTimer) {
        t.cancel();
      }
    });

    return WillPopScope(
        onWillPop: () {
          _cancelTimer = true;
          Navigator.pop(context);
      },
      child:Scaffold(
        appBar: searchBar.build(context),
          body: Column(
            children: [
              Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  child: Column(
                    children: [
                      Text("Deposito", style: TextStyle(fontSize: 18.0),),
                      _crearComboBox()
                    ],
                  )
              ),
              DividerA(),
              Expanded(
                  child: ListaNotasPendientes(_asignaEstantesBloc),
              ),
          ],
        ),
      )
    );

  }

  Widget ListaNotasPendientes(AsignaEstanteBloc asignaEstanteBloc){
      return StreamBuilder(
        stream: asignaEstanteBloc.asignaEstanteStream,
        builder: (BuildContext context, AsyncSnapshot<List<AsignaEstanteModel>> snapshot){
           if(snapshot.hasData){
              final notas = snapshot.data;

              _listaAsignaEstante = notas;

              return RefreshIndicator(
                  onRefresh: (){},//_consultaNotasPendientes,
                  child: ListView.builder(
                    itemCount: notas.length,
                    itemBuilder: (context, i) =>  Column(
                      children: [
                        Padding(
                          padding:
                          EdgeInsets.symmetric(vertical: 27.0, horizontal: 14.0),
                          child: crearItem(notas[i]),
                        ),
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

  Widget crearItem(AsignaEstanteModel notas){
    return Container(

      height: 40.0,
      child: ListTile(
        title:  Transform.translate(
            offset: Offset(0, -20),
            child: Text('Codigo Producto: ${notas.codigo}  \nEstante: ${notas.estante}        Stock: ${notas.stock}',
              style: TextStyle(fontSize: 17),)
        ),
        subtitle: Transform.translate(
            offset: Offset(0, -20),
            child: Text('Producto: ${notas.descripcionProducto}', style: TextStyle(fontSize: 18),)
        ),
          onTap: (){
            showDialog<void>(context: context, builder: (context) => _creaDialogoAsignaEstante(notas));
        },
      ),
    );

  }


  Widget _crearComboBox(){

    return FutureBuilder(
        future: getDropDownMenuItems(),
        builder: (BuildContext context, AsyncSnapshot<List<DropdownMenuItem<String>>> snapshot) {
          if(snapshot.hasData){

            _dropDownMenuItems = snapshot.data;

            if(_seleccionado.length == 0){
              _seleccionado = _dropDownMenuItems[0].value;
            }

            return DropdownButton<String>(
              value: _seleccionado,
              onChanged: (String newValue) {
                setState(() {
                  _seleccionado = newValue;
                });
              },
              items: _dropDownMenuItems,
            );

          }else{
            return Center( child: CircularProgressIndicator());
          }
        }
    );

  }

  Future<List<DropdownMenuItem<String>>> getDropDownMenuItems() async {
    List<DropdownMenuItem<String>> items = new List();

    DepositosProviders pro = new DepositosProviders();

    List<DepositosModel> _radares = await pro.getListaDepositos2("");

    for (DepositosModel radar in _radares) {
      items.add(new DropdownMenuItem(
          value: radar.codDeposito.toString(),
          child: new Text(radar.deposito)
      ));
    }
    return items;
  }

  Widget _creaDialogoAsignaEstante(AsignaEstanteModel estante){

    final _controller = TextEditingController(text: estante.estante);

    _controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: estante.estante.length,
    );


    final SimpleDialog dialog = SimpleDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Asigna Estante \n      Cod. ${estante.codigo}"),
        ],
      ),

      children: [
        SizedBox(height: 5,),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
              autofocus: true,
              controller: _controller,
              //onTap: () => _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.value.text.length),
              //keyboardType: TextInputType.number,
              decoration: InputDecoration(
                icon: Icon(Icons.arrow_forward_ios, color: Colors.deepOrangeAccent,),
              ),
              onSubmitted: (String str){
                setState((){
                  //Navigator.pop(context);
                  _actualizaEstante(str, estante);

                });
              }
          ),
        ),
        SizedBox(height: 20,)
      ],
    );

    return dialog;



  }




  void _actualizaEstante(String estante, AsignaEstanteModel est) async {


    if(estante.length == 0){
      mostrarAlerta(context, 'Ingresar estante!!');
      return;
    }

    AsignaEstanteProviders pro = new AsignaEstanteProviders();

    EasyLoading.show(status: "Cargando..");

    try {
      Map resp = await pro.actualizaEstante(
          _seleccionado, prefs.radar, estante, est.codigo, prefs.separador);

      EasyLoading.dismiss();

      if (resp['ok']) {
        await mostrarConfirmarcion(context, "Estante Asignado");
        Navigator.pop(context);
      } else {
        mostrarAlerta(context, 'Error al actualizar estante !! ');
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