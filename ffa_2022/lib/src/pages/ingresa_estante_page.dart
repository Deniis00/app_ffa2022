
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ffa_2022/src/blocs/estante_bloc.dart';
import 'package:ffa_2022/src/blocs/provider.dart';
import 'package:ffa_2022/src/pages/notas_pendientes_page.dart';
import 'package:ffa_2022/src/providers/detalles_nota_providers.dart';
import 'package:ffa_2022/src/providers/notas_pendientes_providers.dart';
import 'package:ffa_2022/src/utils/utils.dart';

class IngresaEstantePage extends StatefulWidget {
  String _nroReg;

  IngresaEstantePage(this._nroReg);

  @override
  _IngresaEstantePageState createState() => _IngresaEstantePageState();
}

class _IngresaEstantePageState extends State<IngresaEstantePage> {
  final _txtEstante = TextEditingController();
  bool _estanteHabilitado = false;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.estanteBloc(context);

    _asignaEstanteSugerido(bloc);

    return WillPopScope(
      onWillPop: () {
        bloc.clear();
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text("Ingresar Estante"),
          actions: [
            IconButton(
              icon: Icon(
                Icons.settings_overscan,
                size: 30.0,
              ),
              color: Colors.white,
              onPressed: () {
                // _finalizaSeparacion(context, bloc);
                _obtenerEstanteScanner(bloc);
              },
            )
          ],
        ),
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _crearEstante(bloc),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: _crearBoton(context, bloc),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearEstante(EstanteBloc bloc) {
    return StreamBuilder(
      stream: bloc.estanteStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            //autofocus: true,
            enabled: _estanteHabilitado,
            keyboardType: TextInputType.number,
            controller: _txtEstante,
            decoration: InputDecoration(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.deepOrangeAccent,
              ),
              //hintText: 'Usuario',
              labelText: 'Codigo de Estante',
              counterText: (snapshot.data != null)
                  ? 'Caracteres: ${snapshot.data.toString().length}'
                  : 'Caracteres: 0',
              errorText: snapshot.error,
            ),
            onChanged: bloc.changeEstante,
          ),
        );
      },
    ); // unreachable}, )
  }

  Widget _crearBoton(BuildContext context, EstanteBloc bloc) {
    return ElevatedButton(
      child: Row(
        children: [
          Expanded(flex: 8, child: SizedBox()),
          Icon(
            Icons.check,
            color: Colors.white,
          ),
          Expanded(flex: 1, child: SizedBox()),
          Container(
            child: Text('Confirmar'),
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
          backgroundColor: Colors.lightBlue,
          textStyle: TextStyle(color: Colors.white)),
      onPressed: () async {
       // _obtenerEstanteScanner(bloc);
       _finalizaSeparacion(context, bloc);
      },
    );
  }

  void _finalizaSeparacion(BuildContext context, EstanteBloc bloc) async {
    if (_txtEstante.text.length == 0) {
      mostrarAlerta(context, 'Debe Ingresar Estante.');
    } else if (await _validaEstanteSugerido(bloc) == false) {
    } else {
      NotasPendientesProviders _notasPendientesProvider =
          new NotasPendientesProviders();

      EasyLoading.show(status: "Cargando..");

      try {
        Map info = await _notasPendientesProvider.finalizaSeparacion(
          widget._nroReg,
          _txtEstante.text,
        );

        EasyLoading.dismiss();

        if (!info['ok']) {
          mostrarAlerta(context, 'Problemas al finalizar Separacion.');
          _validaEstanteSugerido(bloc);
        } else {
          await mostrarConfirmarcion(
              context, "Nota Nro. ${widget._nroReg}, Separada..!");
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => NotasPendientesPage()),
            (Route<dynamic> route) => false,
          );
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

  void _asignaEstanteSugerido(EstanteBloc bloc) async {
    DetallesNotaProviders _notasPendientesProvider =
        new DetallesNotaProviders();

    _estanteHabilitado = false;

    EasyLoading.show(status: "Cargando..");

    try {
      Map info =
          await _notasPendientesProvider.obtieneEstanteSugerido(widget._nroReg);

      EasyLoading.dismiss();

      if (info['ok']) {
        final String lvEstante = info['estante'];
        _txtEstante.text = lvEstante;
        if (lvEstante.length > 0) {
          _estanteHabilitado = false;
        } else {
          _estanteHabilitado = true;
        }
        bloc.setEstante(lvEstante);
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

  void _obtenerEstanteScanner(EstanteBloc bloc) async {
    if (_estanteHabilitado) {
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

      _txtEstante.text = barcodeScanRes;
      bloc.setEstante(barcodeScanRes);
      _finalizaSeparacion(context, bloc);
    } else {
      Fluttertoast.showToast(
          msg: "Ya posee estante sugerido",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2);
    }
  }

  Future<bool> _validaEstanteSugerido(EstanteBloc bloc) async {
    DetallesNotaProviders _notasPendientesProvider =
        new DetallesNotaProviders();

    bool resp = false;

    EasyLoading.show(status: "Cargando..");

    try {
      Map info =
          await _notasPendientesProvider.obtieneEstanteSugerido(widget._nroReg);

      EasyLoading.dismiss();

      if (info['ok']) {
        final String lvEstante = info['estante'];

        if (lvEstante.length > 0) {
          if (lvEstante != _txtEstante.text) {
            _txtEstante.text = lvEstante;
            bloc.setEstante(lvEstante);
            resp = false;
            mostrarAlerta(context,
                'Estante Sugerido Actualizado, Verificar y Volver a Confirmar !!');
          } else {
            resp = true;
          }
          _estanteHabilitado = false;
        } else {
          resp = true;
        }
      }
    } catch (error) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: "Problemas de Conexion, vuelva a intentar",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2);
    }

    return resp;
  }
}
