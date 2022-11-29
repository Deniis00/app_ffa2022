
import 'dart:convert';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ffa_2022/src/blocs/provider.dart';
import 'package:ffa_2022/src/blocs/teste_nota_seleccionada_bloc.dart';
import 'package:ffa_2022/src/model/teste_movito_devolucion_model.dart';
import 'package:ffa_2022/src/model/teste_nota_seleccionada_model.dart';
import 'package:ffa_2022/src/pages/teste_inicio_page.dart';
import 'package:ffa_2022/src/providers/teste_notas_encontradas_provider.dart';
import 'package:ffa_2022/src/providers/usuario_providers.dart';
import 'package:ffa_2022/src/utils/preferencias_usuario.dart';
import 'package:ffa_2022/src/utils/utils.dart';
import 'package:ffa_2022/src/widgets/DividerB.dart';



class TesteNotaSeleccionadaPage extends StatefulWidget{



  String _nro_nota;

  TesteNotaSeleccionadaPage(this._nro_nota);

  @override
  _TesteNotaSeleccionadaPageState createState()=> _TesteNotaSeleccionadaPageState();


}


class _TesteNotaSeleccionadaPageState extends State<TesteNotaSeleccionadaPage> with TickerProviderStateMixin,AfterLayoutMixin {

  String _separador = "";
  String _nombreSeparador = "";

  @override
  void afterFirstLayout(BuildContext context){
    showDialog<void>(context: context, builder: (context) => _ingresaSeparador()).then((val){
      if(_separador.length == 0){
        Navigator.pop(context);
        mostrarAlerta(context, 'Separador no encontrado');
      }
    });
  }

  List<TesteNotaSeleccionadaModel> _listaTesteNotaSeleccionada;

  Size _size ;

  TesteNotaSeleccionadaBloc _testeNotaSeleccionadaBloc;

  String _seleccionado = "";

  List<DropdownMenuItem<String>> _dropDownMenuItems;

  final _prefs = new PreferenciasUsuario();



  @override
  Widget build(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((_) => {
//          showDialog<void>(context: context, builder: (context) => _ingresaSeparador())
//     });

    _size = MediaQuery.of(context).size;

    _testeNotaSeleccionadaBloc = Provider.testeNotaSeleccionadaBloc(context);

    _testeNotaSeleccionadaBloc.listaTesteNotaSeleccionada(widget._nro_nota);

    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
        },
        child:Scaffold(
          appBar: AppBar(
            title: Text("Teste - ${_nombreSeparador}"),
            actions: [
              IconButton(
                icon: Icon(Icons.check, size: 30.0,),
                color: Colors.white,
                onPressed: (){
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => TesteInicioPage()),
                        (Route<dynamic> route) => false,
                  );
                },
              )
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: _cargaTesteNotaSeleccionada(_testeNotaSeleccionadaBloc),
              ),
            ],
          ),
        )
    );

  }

  Widget _cargaTesteNotaSeleccionada(TesteNotaSeleccionadaBloc testeNotaSeleccionadaBloc){
    return StreamBuilder(
        stream: testeNotaSeleccionadaBloc.testeNotaSeleccionadaStream,
        builder: (BuildContext context, AsyncSnapshot<List<TesteNotaSeleccionadaModel>> snapshot){
          if(snapshot.hasData){

            final notas = snapshot.data;
            _listaTesteNotaSeleccionada = new List<TesteNotaSeleccionadaModel>();
            String lvUltimoCodigo = "";
            int lvCantidadContada = 0;
            TesteNotaSeleccionadaModel am;
            for(var e in notas){

              if(lvUltimoCodigo != e.codigo && lvUltimoCodigo != ""){

                lvCantidadContada = 0;

              }

              lvUltimoCodigo = e.codigo;
              am = e;
              lvCantidadContada = lvCantidadContada + 1;

              if(e.idTest > 0 ) {

                TesteNotaSeleccionadaModel m = new TesteNotaSeleccionadaModel();
                m.nroReg = e.nroReg;
                m.descripcionMotivo = e.descripcionMotivo;
                m.descripcion = e.descripcion;
                m.serial = e.serial;
                m.motivoCambio = e.motivoCambio;
                m.observacion = e.observacion;
                m.registrada = e.registrada;
                m.cantidad = e.cantidad;
                m.codigo = e.codigo;
                m.idTest = e.idTest;

                _listaTesteNotaSeleccionada.add(m);
              }else{
                _listaTesteNotaSeleccionada.add(e);
              }

              if(lvCantidadContada == double.parse(am.registrada) || (double.parse(am.cantidad) > 1) && double.parse(am.registrada)==0){
                var lvCantidad = double.parse(am.cantidad);

                if(double.parse(am.registrada) == 0){
                  lvCantidad = lvCantidad -1;
                }
                double cantidadAdd = lvCantidad - double.parse(am.registrada);
                for(int i = 0 ; cantidadAdd > i;i++){
                  am.observacion = "";
                  am.serial = "";
                  am.motivoCambio = 0;
                  am.descripcionMotivo = "NINGUNA";
                  am.idTest = 0;
                  _listaTesteNotaSeleccionada.add(am);
                }
              }

            }



            return ListView.builder(
              itemCount: _listaTesteNotaSeleccionada.length,
              itemBuilder: (context, i) =>
                  Column(
                    children: [
                      Container(
                        color: _listaTesteNotaSeleccionada[i].idTest > 0 ? Colors.greenAccent : null, // if current item is selected show blue color
                        child: Padding(
                          padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 14.0),
                          //EdgeInsets.only(bottom: 40, top: 10),
                          child: itemTransferencias(_listaTesteNotaSeleccionada[i]),
                        ),
                      ),
                      DividerB()
                    ],
                  ),
            );

          }else{
            return Center( child: CircularProgressIndicator());
          }
        }
    );
  }


  Widget itemTransferencias(TesteNotaSeleccionadaModel notas){
    return InkWell(
      onTap: () async {
        showDialog<void>(context: context, builder: (context) => _creaDialogoCantidadRegistrada(notas));
      },
      child:Container(

        padding: EdgeInsets.all(5),
        child:  Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Container(
                        width: _size.width * 0.32,
                        alignment: Alignment.centerLeft,
                        child: Text("Código: ${notas.codigo}", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                      ),
                      Container(
                          width: _size.width * 0.5,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Text("Serial: ", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                              Expanded(
                                child:Container(
                                  alignment: Alignment.centerLeft,
                                  child:  Text((notas.serial.length < 14? notas.serial : "..."+notas.serial.substring(notas.serial.length - 13) ),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.black, fontSize: 15),textAlign: TextAlign.start),
                                ),
                              ),
                            ],
                          )
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text("Descripción: ", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                      ),
                      Expanded(
                        child:Container(
                          alignment: Alignment.centerLeft,
                          child: Text("${notas.descripcion}",overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black, fontSize: 15),textAlign: TextAlign.center,),
                        ),
                      ),

                    ],
                  ),
                ),

//                Container(
//                  alignment: Alignment.centerLeft,
//                  margin: EdgeInsets.symmetric(vertical: 3),
//                  child: Row(
//                    children: [
//                      Container(
//                        alignment: Alignment.centerLeft,
//                        child: Text("Observación: ", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
//                      ),
//                      Expanded(
//                        child:Container(
//                          alignment: Alignment.centerLeft,
//                          child: Text("${notas.observacion}",overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black, fontSize: 15),textAlign: TextAlign.center,),
//                        ),
//                      ),
//
//                    ],
//                  ),
//                )
              ]
          ),
        ),

      ),
    );

  }


  Widget _creaDialogoCantidadRegistrada(TesteNotaSeleccionadaModel producto){


//      final _controller = TextEditingController(text: producto.cantidadRegistrada);
    final _controller = TextEditingController(text: producto.serial);
    final _controllerObservacion = TextEditingController(text: producto.observacion);
    _seleccionado  = producto.motivoCambio.toString();

    return  Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: EdgeInsets.all(10),
                child: Stack(
                  clipBehavior: Clip.none, alignment: Alignment.center,
                  children: <Widget>[
                    SingleChildScrollView(
                      child:   Container(
                        width: double.infinity,
                        //  height: _size.height *0.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white
                        ),
                        padding: EdgeInsets.fromLTRB(0, 10, 20, 20),
                        child: Column(
                          children: [
                            Text("Cod. ${producto.codigo}",style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              width: _size.width * 0.75,
                              child: Text("Motivo Devolución",style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),textAlign: TextAlign.start),
                            ),
                            _crearComboBox(),
                            Container(
                              margin: EdgeInsets.only(bottom: 20),
                              width: _size.width * 0.8,
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextField(
                                  //autofocus: true,
                                  controller: _controller,
                                  //onTap: () => _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.value.text.length),
                                  //    keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Serial',
                                    //                            icon: Icon(Icons.arrow_forward_ios, color: Colors.deepOrangeAccent,),
                                    suffixIcon: IconButton(
                                      onPressed: () async {

                                        String barcodeScanRes = "";

                                        /*final bar = await BarcodeScanner.scan();

                                        barcodeScanRes = bar;*/

                                        try {
                                          barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                                              '#ff6666', 'Cancel', true, ScanMode.QR);
                                          print(barcodeScanRes);
                                        } catch(ex) {
                                          barcodeScanRes = '-1';
                                        }

                                        if (barcodeScanRes == "-1" || barcodeScanRes == null) {
                                          barcodeScanRes = "";
                                        }

                                        _controller.text = barcodeScanRes;

                                      },
                                      icon: Icon(Icons.settings_overscan),
                                    ),
                                  ),

                                  onSubmitted: (String str){
                                    //                setState((){
                                    //                  Navigator.pop(context);
                                    //                  _separarProducto(producto, _controller.text);
                                    //                });
                                  }
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 20),
                              width: _size.width * 0.8,
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextField(
                                //                        autofocus: true,
                                  controller: _controllerObservacion,
                                  //onTap: () => _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.value.text.length),
                                  //   keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Observacion',
                                    //                            icon: Icon(Icons.arrow_forward_ios, color: Colors.deepOrangeAccent,),
                                  ),

                                  onSubmitted: (String str){
                                    //                setState((){
                                    //                  Navigator.pop(context);
                                    //                  _separarProducto(producto, _controller.text);
                                    //                });
                                  }
                              ),
                            ),
                            Container(
                              width: _size.width * 0.8,
                              child: ElevatedButton(
                                child: Row (
                                  children: [
                                    Expanded(flex: 8, child: SizedBox()),
                                    Expanded(
                                        flex: 1,
                                        child: SizedBox()
                                    ),
                                    Container(

                                      child: Text('CONFIRMAR'),
                                    ),
                                    Expanded(flex: 8, child: SizedBox()),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    elevation: 0.0,
                                    backgroundColor: Colors.blueAccent,
                                    textStyle: TextStyle(color: Colors.white)),
                                onPressed: () async {

                                  //            Parameters2Arguments param = new Parameters2Arguments(_radioValue1, _txtCliente.text);
                                  //            Navigator.pushNamed(context, 'teste_notas_encontradas', arguments: param);
                                    TesteNotasEncontradasProvider p = new TesteNotasEncontradasProvider();
                                    EasyLoading.show(status: "Cargando..");
                                    try{
                                      await p.getTesteInsertaDatos(json.encode({"nro_reg":producto.nroReg, "codigo":producto.codigo,
                                        "separador":_separador, "serial":_controller.text, "motivo_cambio":int.parse(_seleccionado),
                                        "observacion":_controllerObservacion.text, "serial_anterior":producto.serial,
                                        "nombre_separador":_nombreSeparador, "id_test":producto.idTest}));

                                      EasyLoading.dismiss();

                                      Navigator.pop(context);
                                      setState(() {});
                                    }catch(r){
                                      Navigator.pop(context);
                                      Fluttertoast.showToast(
                                          msg: "Problemas de Conexion, vuelva a intentar",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 2
                                      );
                                    }

                                },
                              ),
                            )

                          ],
                        ),
                      ),
                    ),
                  ],
                )
            );
  }


  Widget _crearComboBox(){

    return StatefulBuilder(
          builder: (context, setState) {
          return FutureBuilder(
                future: getDropDownMenuItems(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<DropdownMenuItem<String>>> snapshot) {
                  if (snapshot.hasData) {
                    _dropDownMenuItems = snapshot.data;

                    if (_seleccionado.length == 0) {
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
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }
            );
          }
    );

  }


  Future<List<DropdownMenuItem<String>>> getDropDownMenuItems() async {
    List<DropdownMenuItem<String>> items = new List();

    TesteNotasEncontradasProvider p = new TesteNotasEncontradasProvider();

    List<TesteMotivoDevolucionModel> _radares = await p.getListaTesteMotivoDevolucion();

    for (TesteMotivoDevolucionModel radar in _radares) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(new DropdownMenuItem(
          value: radar.id.toString(),
          child: new Text(radar.observacion)
      ));
    }
    return items;
  }

  Widget _ingresaSeparador(){

    final _controller = TextEditingController();

    final SimpleDialog dialog = SimpleDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Cod. Separador"),
        ],
      ),

      children: [
        SizedBox(height: 5,),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
              autofocus: true,
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                icon: Icon(Icons.arrow_forward_ios, color: Colors.deepOrangeAccent,),
              ),
              onSubmitted: (String str)async{


                  UsuarioProvider uP = new UsuarioProvider();

                  EasyLoading.show(status: "Cargando..");

                  Map info = await uP.loginSeparador(context, _controller.text);

                  EasyLoading.dismiss();

                  if(info['ok']){

                    setState(() {
                      _separador = _controller.text;
                      _nombreSeparador = info['nombreUsuario'];
                    });

                  }

                  Navigator.pop(context);

              }
          ),
        ),
        SizedBox(height: 20,)
      ],
    );

    return dialog;


  }

}