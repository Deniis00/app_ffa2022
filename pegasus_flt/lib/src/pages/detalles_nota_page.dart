import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pegasus_flt/src/blocs/detalles_nota_bloc.dart';
import 'package:pegasus_flt/src/blocs/provider.dart';
import 'package:pegasus_flt/src/model/depositos_model.dart';
import 'package:pegasus_flt/src/model/detalle_nota_model.dart';
import 'package:pegasus_flt/src/model/nota_pendiente_model.dart';
import 'package:pegasus_flt/src/providers/depositos_providers.dart';
import 'package:pegasus_flt/src/providers/detalles_nota_providers.dart';
import 'package:pegasus_flt/src/providers/notas_pendientes_providers.dart';
import 'package:pegasus_flt/src/utils/preferencias_usuario.dart';
import 'package:pegasus_flt/src/utils/utils.dart';
import 'package:pegasus_flt/src/widgets/DividerA.dart';
import 'package:pegasus_flt/src/widgets/DividerB.dart';

import '../providers/detalles_nota_providers.dart';
import '../providers/detalles_nota_providers.dart';

class DetallesNotaPage extends StatefulWidget {
  NotaPendienteModel _notas;

  DetallesNotaPage(this._notas);

  @override
  _DetallesNotaPageState createState() => _DetallesNotaPageState();
}

class _DetallesNotaPageState extends State<DetallesNotaPage> {
  final _detallesNotaProvider = new DetallesNotaProviders();

  final _prefs = new PreferenciasUsuario();

  List<DetalleNotaModel> _listaDetalleNota;

  DetallesNotaBloc _detallesNotaBloc;

  List<DepositosModel> _listaDepositos;

  Timer _timer;

  bool _ejecutaTimer = true;

  bool cancelarTimer = false;

  @override
  Widget build(BuildContext context) {
    //final NotaPendienteModel nota = ModalRoute.of(context).settings.arguments;
    final _detalleNotaProvider = new DetallesNotaProviders();
    final NotaPendienteModel nota = widget._notas;
    _detallesNotaBloc = Provider.detallesNotaBloc(context);
    _detallesNotaBloc.listaDetallesNota(nota.nroReg.toString());
    _cargaDepositosTransferencias();

    _timer = Timer.periodic(Duration(seconds: 2), (Timer t) async {
      if (_ejecutaTimer) {
        _ejecutaTimer = false;

        try {
          DetallesNotaProviders p = new DetallesNotaProviders();
          Map resp = await p.validaSeparadorActual(
              nota.nroReg.toString(), _prefs.separador);
          if (resp['encontrado'] == 0) {
            Navigator.pop(context);
            await mostrarAlerta(
                context,
                'Nota Nro. ' +
                    nota.nroReg.toString() +
                    ' ya se encuentra en separacion!!');
            cancelarTimer = true;
          }
        } catch (error) {}

        _ejecutaTimer = true;
      }

      if (cancelarTimer) {
        t.cancel();
      }
    });

    return WillPopScope(
      onWillPop: () {
        _cancelarSepracion(widget._notas);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text("Nota Nro. ${nota.nroReg}"),
          actions: [
            IconButton(
              icon: Icon(
                Icons.compare_arrows,
                size: 30.0,
              ),
              color: Colors.white,
              onPressed: () {
                showDialog<void>(
                    context: context,
                    builder: (context) => _creaDialogoDepositos());
              },
            ),
            IconButton(
              icon: Icon(
                Icons.check_box,
                size: 30.0,
              ),
              color: Colors.white,
              onPressed: () {
                _confirmarSeparacion(widget._notas);
              },
            )
          ],
        ),
        body: Column(children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            child: Text(
              nota.observacion,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          DividerA(),
          Expanded(
            child: _detallesNotaPendientes(_detallesNotaBloc),
          )
        ]),
//        floatingActionButton: FloatingActionButton(
//            onPressed: () {
//              showDialog<void>(context: context, builder: (context) => _creaDialogoDepositos());
//            },
//            child: Icon(Icons.compare_arrows),
//            backgroundColor: Colors.blueAccent,
//        )
      ),
    );
  }

  Widget _detallesNotaPendientes(DetallesNotaBloc detallesNotaBloc) {
    return StreamBuilder(
        stream: detallesNotaBloc.detallesNotaStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<DetalleNotaModel>> snapshot) {
          if (snapshot.hasData) {
            final notas = snapshot.data;

            _listaDetalleNota = notas;

            return RefreshIndicator(
                onRefresh: _consultaDetallesNota,
                child: ListView.builder(
                  itemCount: notas.length,
                  itemBuilder: (context, i) => Dismissible(
                    //direction: DismissDirection.startToEnd,
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        //_separarProducto(notas[i]);
                        _separarProductoCantidad(notas[i], "0", true);
                      } else if (direction == DismissDirection.endToStart) {
                        _capturaCodigo(notas[i]);
                      }

                      return false;
                    },
                    key: UniqueKey(),
                    //key: Key(notas.toString()),
                    background: slideRightBackground(notas[i].separado),
                    //secondaryBackground: slideLeftBackground(),
                    //onDismissed: (e) => _consultaSeprar(notas[i]),
                    child: Column(
                      children: [crearItem(notas[i]), DividerB()],
                    ),
                  ),
                ));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
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
              "Transferencias",
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

  Widget slideRightBackground(int separado) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      color: separado == 1 ? Colors.red : Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              separado == 1 ? Icons.check_box_outline_blank : Icons.check,
              color: Colors.white,
              size: 35,
            ),
            Expanded(
              child: SizedBox(
                width: 20,
              ),
            ),
            Icon(
              Icons.settings_overscan,
              color: Colors.white,
            ),
            Text(
              "Escanear",
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

  Widget crearItem(DetalleNotaModel producto) {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.all(15),
            child: InkWell(
                onTap: () {
                  //_separarProducto(producto);
                  showDialog<void>(
                      context: context,
                      builder: (context) =>
                          _creaDialogoCantidadSeparada(producto));
                },
                child: Row(
                  children: [
                    Expanded(
                        flex: 10,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Column(children: [
                                  Container(
                                    height: 35.0,
                                    child: Column(
                                      children: [
                                        Text(
                                          "${producto.codigo}",
                                          style: TextStyle(fontSize: 15.0),
                                        ),
                                      ],
                                    ),
                                  )
                                ]),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: Column(
                                  children: [
                                    Container(
                                      height: 35.0,
                                      child: Column(
                                        children: [
                                          Text(
                                            producto.descripcion_producto,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(fontSize: 14.0),
                                          ),
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
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "${producto.estante}",
                                      style: TextStyle(fontSize: 15.0),
                                    ),
                                  ],
                                ),
                                // Expanded(child: SizedBox()),
                                SizedBox(
                                  width: 40,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "Cant.: ${producto.cantidad}",
                                      style: TextStyle(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Expanded(
                                    child: Column(
                                  children: [
                                    Text(
                                      "Pend.: ${int.parse(producto.cantidad) - producto.cant_separada}",
                                      style: TextStyle(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )),
                                //Expanded(child: SizedBox()),
                                Expanded(
                                    child: Column(
                                  children: [
                                    Text(
                                      "${producto.cod_deposito}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 15.0),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ))
                              ],
                            ),
                          ],
                        )),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Center(
                            child: producto.separado == 1
                                ? Icon(
                                    Icons.check_box_outlined,
                                    color: Colors.green,
                                    size: 40,
                                  )
                                : Icon(
                                    Icons.check_box_outline_blank,
                                    color: Colors.deepOrange,
                                    size: 40,
                                  ),
                          ),
                        ],
                      ),
                    )
                  ],
                )))
      ],
    );
  }

  Future<Null> _consultaDetallesNota() async {
    return await _detallesNotaBloc
        .listaDetallesNota(widget._notas.nroReg.toString());
  }

  void _separarProducto(DetalleNotaModel producto) async {
    String mensaje = "Desea Marcar producto ${producto.descripcion_producto}?";
    String lv_separado = "1";
    String lv_titulo = "Marcar";

    if (producto.separado == 1) {
      mensaje = "Desea Desmarcar producto ${producto.descripcion_producto}?";
      lv_separado = "0";
      lv_titulo = "Desmarcar";
    }

    EasyLoading.show(status: "Cargando..");

    try {
      await _detallesNotaProvider.separarProducto(
          producto.codigo, lv_separado, widget._notas.nroReg.toString());
      await _consultaDetallesNota();

      EasyLoading.dismiss();
    } catch (error) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: "Problemas de Conexion, vuelva a intentar",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2);
    }
  }

  void _separarProductoCantidad(
      DetalleNotaModel producto, String cantidad, bool total) async {
    String mensaje = "Desea Marcar producto ${producto.descripcion_producto}?";
    String lv_separado = "1";
    String lv_titulo = "Marcar";

    if (!total) {
      if (!isNumeric(cantidad)) {
        mostrarAlerta(context, 'Número incorrecto!!');
        return;
      } else if (producto.cant_separada + int.parse(cantidad) < 0) {
        mostrarAlerta(context, 'Cantidad separada no puede ser menor a 0!!');
        return;
      } else if (int.parse(producto.cantidad) <
          (producto.cant_separada + int.parse(cantidad))) {
        mostrarAlerta(
            context, 'Cantidad separada no puede ser mayor a la solicitada!!');
        return;
      } else if ((int.parse(producto.cantidad) -
              (producto.cant_separada + int.parse(cantidad))) <
          0) {
        mostrarAlerta(context, 'Cantidad separada no puede ser menor a 0!!');
        return;
      }

      if (int.parse(producto.cantidad) ==
          (producto.cant_separada + int.parse(cantidad))) {
        lv_separado = "1";
      } else {
        lv_separado = "0";
      }
    } else {
      if (int.parse(producto.cantidad) == producto.cant_separada) {
        cantidad = (int.parse(producto.cantidad) * -1).toString();
      } else {
        cantidad =
            (int.parse(producto.cantidad) - producto.cant_separada).toString();
      }

      if (int.parse(cantidad) > 0) {
        lv_separado = "1";
      } else {
        lv_separado = "0";
      }
    }

    EasyLoading.show(status: "Cargando..");

    try {
      await _detallesNotaProvider.separarProductoCantidad(producto.codigo,
          lv_separado, widget._notas.nroReg.toString(), cantidad);
      await _consultaDetallesNota();

      EasyLoading.dismiss();
    } catch (error) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: "Problemas de Conexion, vuelva a intentar",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2);
    }
  }

  void _agregaEstanteNota(String nroReg, String estante) async {
    EasyLoading.show(status: "Cargando..");

    try {
      await _detallesNotaProvider.agregaEstanteNotaSeparada(nroReg, estante);
      EasyLoading.dismiss();
    } catch (error) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: "Problemas de Conexion, vuelva a intentar",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2);
    }
  }

  void _validaAgregaEstanteNota(
      NotaPendienteModel nota, String nroReg, String estante) async {
    try {
      if (await _validaEstante(estante)) {
        _agregaEstanteNota(nroReg, estante);
        _cancelaNota(nota);
        _close();
      } else {
        mostrarAlerta(context, "El numero de estante ingresado no existe!!");
        return;
      }
    } catch (error) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: "Problemas de Conexion, vuelva a intentar",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2);
    }
  }

  void _cancelarSepracion(NotaPendienteModel notas) {
    if (notas.volverSeparar == 1) {
      mostrarAlerta(context, "Nota no puede cancelar nota re-separada !!");
      return;
    }

    MensajeConfirmacion(context, "Aviso",
            "Cancelar Separacion de Nota Nro. ${notas.nroReg}?")
        .then((value) async {
      if (value != null) {
        if (value) {
          try {
            int exitTrans = await _verificaExisteTransferencia(notas);

            if (exitTrans > 0) {
              await _verificaExisteSeparacion(notas);
            } else {
              _cancelaNota(notas);
            }
          } catch (error) {
            EasyLoading.dismiss();
            Navigator.pop(context);
            Fluttertoast.showToast(
                msg: "Problemas de Conexion, vuelva a intentar",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 2);
          }
        }
      }
    });
  }

  void _cancelaNota(NotaPendienteModel notas) async {
    NotasPendientesProviders _notasPendientesProvider =
        new NotasPendientesProviders();
    EasyLoading.show(status: "Cargando..");
    try {
      Map info = await _notasPendientesProvider.cancelaSeparacion(
          context, "0", "0", notas.nroReg.toString());

      EasyLoading.dismiss();

      if (!info['ok']) {
        Navigator.pop(context);
        mostrarAlerta(
            context, 'Nota ya no se se encuentra disponible para separar!!');
      } else {
        Navigator.pop(context);
      }
    } catch (error) {
      EasyLoading.dismiss();
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "Problemas de Conexion, vuelva a intentar",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2);
    }
  }

  void _confirmarSeparacion(NotaPendienteModel notas) async {
    Navigator.pushNamed(context, "ingresar_estante",
        arguments: widget._notas.nroReg.toString());
  }

  void _capturaCodigo(DetalleNotaModel producto) async {
    String barcodeScanRes = "";

   /* final bar = await BarcodeScanner.scan();

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

    if (barcodeScanRes.length > 0) {
      DetallesNotaProviders _notasPendientesProvider =
          new DetallesNotaProviders();

      EasyLoading.show(status: "Cargando..");

      try {
        Map info = await _notasPendientesProvider.validaCodigoAlternativo(
            producto.codigo, barcodeScanRes);

        EasyLoading.dismiss();

        if (info['encontrado'] > 0) {
          if (producto.cantidad == "1") {
            _separarProductoCantidad(producto, "1", true);
          } else {
            showDialog<void>(
                context: context,
                builder: (context) => _creaDialogoCantidadSeparada(producto));
          }
          //_separarProducto(producto);
        } else {
          mostrarAlerta(context, 'Producto no corresponde !!');
        }
      } catch (error) {
        EasyLoading.dismiss();
        Fluttertoast.showToast(
            msg: "Problemas de Conexion, vuelva a intentar",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2);
      }
    }
  }

  void _cargaDepositosTransferencias() async {
    DepositosProviders provider = new DepositosProviders();

    _listaDepositos =
        await provider.getListaDepositos(widget._notas.nroReg.toString());
  }

  Widget _creaDialogoDepositos() {
    final SimpleDialog dialog = SimpleDialog(
      title: InkWell(
        onTap: () {
          //  _separarProducto(producto);
          //Navigator.pop(context);
          List<DepositosModel> selectDeposito =
              _listaDepositos.where((i) => i.seleccionado).toList();
          //print(jsonEncode(selectDeposito));
          // if(selectDeposito.length > 0) {

          String jsonDep = jsonEncode(selectDeposito);
          DepositosProviders provider = new DepositosProviders();
          provider.insertDepositoTransferencia(
              widget._notas.nroReg.toString(), jsonDep);

          //}

          Navigator.pop(context);
        },
        child: Row(
          children: [
            Text("Deposito Transferencia"),
            Expanded(child: SizedBox()),
            Center(
                // child: producto.separado == 1 ?
                child: Icon(
              Icons.check,
              color: Colors.blue,
              size: 40,
            )
                //  Icon(Icons.check_box_outline_blank, color: Colors.deepOrange,size: 40,),
                ),
          ],
        ),
      ),
      children: _listaDepositos.map<Widget>((DepositosModel deposito) {
        return StatefulBuilder(
          builder: (_, StateSetter setState) => CheckboxListTile(
            key: Key(deposito.codDeposito.toString()),
            title: Text(deposito.deposito), // Displays the option
            value: deposito.seleccionado, // Displays checked or unchecked value
            controlAffinity: ListTileControlAffinity.platform,
            onChanged: (value) => {
              setState(() {
                DepositosModel d = deposito;
                d.seleccionado = !d.seleccionado;
                _listaDepositos[_listaDepositos.indexWhere(
                    (element) => element.codDeposito == d.codDeposito)] = d;
              })
            },
          ),
        );
      }).toList(),
    );

    return dialog;
  }

  Future<void> _verificaExisteSeparacion(NotaPendienteModel nota) async {
    NotasPendientesProviders _notasPendientesProvider =
        new NotasPendientesProviders();

    EasyLoading.show(status: "Cargando..");
    try {
      Map info = await _notasPendientesProvider
          .varificaExisteSeparacion(nota.nroReg.toString());

      EasyLoading.dismiss();

      if (info['ok']) {
        String existeSeparacion = info['existe_separacion'];

        if (int.parse(existeSeparacion) > 0) {
          DetallesNotaProviders _notasPendientesProvider =
              new DetallesNotaProviders();
          String v_estante = '0';

          Map info = await _notasPendientesProvider
              .obtieneEstanteSugerido(nota.nroReg.toString());

          EasyLoading.dismiss();

          if (info['ok']) {
            v_estante = info['estante'];

            showDialog<void>(
                context: context,
                builder: (context) => _creaDialogoEstante(nota, v_estante));
          }
        } else {
          _cancelaNota(nota);
        }
      }
    } catch (error) {
      EasyLoading.dismiss();
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "Problemas de Conexion, vuelva a intentar",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2);
    }
  }

  Future<int> _verificaExisteTransferencia(NotaPendienteModel nota) async {
    NotasPendientesProviders _notasPendientesProvider =
        new NotasPendientesProviders();

    EasyLoading.show(status: "Cargando..");
    try {
      Map info = await _notasPendientesProvider
          .verificaExisteTransferencia(nota.nroReg.toString());

      EasyLoading.dismiss();

      if (info['ok']) {
        String existeTransferencia = info['existe_separacion'];

        if (int.parse(existeTransferencia) > 0) {
          return int.parse(existeTransferencia);
        }
      }
      return 0;
    } catch (error) {
      EasyLoading.dismiss();
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "Problemas de Conexion, vuelva a intentar",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2);
    }
  }

  Future<bool> _validaEstante(String estante) async {
    bool retorno = false;
    EasyLoading.show(status: "Cargando..");
    try {
      Map info = await _detallesNotaProvider.validaEstante(estante);

      EasyLoading.dismiss();

      if (info['ok']) {
        retorno = true;
      }
    } catch (error) {
      EasyLoading.dismiss();
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "Problemas de Conexion, vuelva a intentar",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2);
    }
    return retorno;
  }

  Widget _creaDialogoCantidadSeparada(DetalleNotaModel producto) {
    final _controller = TextEditingController(text: "0");

    _controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: 1,
    );

    final SimpleDialog dialog = SimpleDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Cantidad Separada \n      Cod. ${producto.codigo}"),
        ],
      ),
      children: [
        SizedBox(
          height: 5,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
              autofocus: true,
              controller: _controller,
              //onTap: () => _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.value.text.length),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.deepOrangeAccent,
                ),
              ),
              onSubmitted: (String str) {
                setState(() {
                  Navigator.pop(context);
                  _separarProductoCantidad(producto, _controller.text, false);
                });
              }),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );

    return dialog;
  }

  Widget _creaDialogoEstante(NotaPendienteModel nota, String estante) {
    if (estante.length <= 0 || estante == "--") {
      estante = '';

      final _controller = TextEditingController(text: estante);

      _controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: estante.length,
      );

      final SimpleDialog dialog = SimpleDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Agregue estante: "),
          ],
        ),
        children: [
          SizedBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
                autofocus: true,
                controller: _controller,
                //onTap: () => _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.value.text.length),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.deepOrangeAccent,
                  ),
                ),
                onSubmitted: (String str) {
                  setState(() {
                    _validaAgregaEstanteNota(
                        nota, nota.nroReg.toString(), _controller.text);
                  });
                }),
          ),
          SizedBox(
            height: 20,
          )
        ],
      );

      return dialog;
    } else {
      final AlertDialog alertDialog = AlertDialog(
        title: const Text('Estante Asignado: '),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                estante,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(primary: Colors.green),
            child: const Text('Aceptar',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            onPressed: () {
              Navigator.of(context).pop();
              _agregaEstanteNota(nota.nroReg.toString(), estante);
              _cancelaNota(nota);
            },
          ),
        ],
      );

      return alertDialog;
    }
  }

  void _close() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    cancelarTimer = true;
    super.dispose();
  }
}
