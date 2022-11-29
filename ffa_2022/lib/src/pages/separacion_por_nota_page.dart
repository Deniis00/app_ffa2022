

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ffa_2022/src/blocs/estante_bloc.dart';
import 'package:ffa_2022/src/blocs/provider.dart';
import 'package:ffa_2022/src/blocs/separa_por_nota_bloc.dart';
import 'package:ffa_2022/src/pages/notas_pendientes_page.dart';
import 'package:ffa_2022/src/providers/detalles_nota_providers.dart';
import 'package:ffa_2022/src/providers/notas_pendientes_providers.dart';
import 'package:ffa_2022/src/utils/preferencias_usuario.dart';
import 'package:ffa_2022/src/utils/utils.dart';

class SepararPorNotaPage extends StatefulWidget {

  @override
  _SepararPorNotaPageState createState()=> _SepararPorNotaPageState();

}

class _SepararPorNotaPageState extends State<SepararPorNotaPage> {

  final _txtEstante = TextEditingController();
  final _txtNota = TextEditingController();
  bool _estanteHabilitado = true;
  FocusNode _focusNroReg = new FocusNode();
  SeparaPorNotaBloc bloc;

  @override
  void initState(){
    super.initState();

    _focusNroReg.addListener(_onFocusChange);

  }

  @override
  Widget build(BuildContext context) {

    bloc = Provider.separaPorNotaBloc(context);

    //_asignaEstanteSugerido();

    return WillPopScope(
        onWillPop: () {
        bloc.clear();
        Navigator.pop(context);
    },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text("Separar Nota"),
         /* actions: [
            IconButton(
              icon: Icon(Icons.check, size: 30.0,),
              color: Colors.white,
              onPressed: (){
                  _finalizaSeparacion(context);
                 /* Fluttertoast.showToast(
                      msg: "Ya posee estante sugerido",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 2
                  );*/
              },
            )
          ],*/
        ),
        body: Center(
          child: Container(

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _crearNota(),
                _crearEstante(),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: _crearBoton(context),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onFocusChange(){
    debugPrint("Focus: ${_focusNroReg.hasFocus}");
    if(!_focusNroReg.hasFocus){
      //_validaEstanteSugerido();
    }
  }

  Widget _crearNota() {

    return StreamBuilder(stream: bloc.nroRegStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            focusNode: _focusNroReg,
            autofocus: true,
            //enabled: _estanteHabilitado,
            keyboardType: TextInputType.number,
            controller: _txtNota,
            decoration: InputDecoration(
              icon: Icon(Icons.exit_to_app, color: Colors.deepOrangeAccent,),
              //hintText: 'Usuario',
              labelText: 'Nro. Nota',
              suffixIcon: IconButton(
                onPressed: () async {
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

                  _txtNota.text = barcodeScanRes;
                },
                icon: Icon(Icons.settings_overscan),
              ),
              counterText: (snapshot.data != null)
                  ? 'Caracteres: ${ snapshot.data.toString().length }'
                  : 'Caracteres: 0',
              errorText: snapshot.error,
            ),
            onChanged: bloc.changeNroReg,

          ),
        );

      },
    );// unreachable}, )

  }

  Widget _crearEstante() {

    return StreamBuilder(stream: bloc.estanteStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            //autofocus: true,
            enabled: _estanteHabilitado,
            keyboardType: TextInputType.number,
            controller: _txtEstante,
            decoration: InputDecoration(
              icon: Icon(Icons.exit_to_app, color: Colors.deepOrangeAccent,),
              //hintText: 'Usuario',
              labelText: 'Codigo de Estante',
              counterText: (snapshot.data != null)
                  ? 'Caracteres: ${ snapshot.data.toString().length }'
                  : 'Caracteres: 0',
              errorText: snapshot.error,
            ),
            onChanged: bloc.changeEstante,
          ),
        );

      },
    );// unreachable}, )

  }

  Widget _crearBoton(BuildContext context){


        return ElevatedButton(
          child: Row (
            children: [
              Expanded(flex: 8, child: SizedBox()),
             /* Icon(
                Icons.settings_overscan,
                color: Colors.white,
              ),*/
              Expanded(
                flex: 1,
                  child: SizedBox()
              ),
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

            _finalizaSeparacion(context);
           // limpiar();


          },
        );

  }

  void _finalizaSeparacion(BuildContext context) async {

    if (_txtNota.text.length == 0) {
      mostrarAlerta(context, 'Debe Ingresar Nro. de nota');
    } else if (_txtEstante.text.length == 0) {
      mostrarAlerta(context, 'Debe Ingresar Estante.');
    } else {
        bool validaEstante = await _validaEstanteSugerido();
        if(!validaEstante){
          return;
        }else {
          NotasPendientesProviders _notasPendientesProvider = new NotasPendientesProviders();
          PreferenciasUsuario prefs = new PreferenciasUsuario();

          EasyLoading.show(status: "Cargando..");

          try {
            Map info = await _notasPendientesProvider.separacionPorNota(
                _txtNota.text, _txtEstante.text, prefs.usuario,
                prefs.nombreUsuario);

            EasyLoading.dismiss();

            if (!info['ok']) {
              mostrarAlerta(context, 'Problemas al finalizar Separacion.');
              _validaEstanteSugerido();
            } else {
              await mostrarConfirmarcion(
                  context, "Nota Nro. ${_txtNota.text}, Separada..!");
              /* Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => NotasPendientesPage()),
                  (Route<dynamic> route) => false,
            );*/
              limpiar();
            }
          } catch (error) {
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

  }

  void _asignaEstanteSugerido() async {

      DetallesNotaProviders _notasPendientesProvider = new DetallesNotaProviders();

      _estanteHabilitado = false;

      EasyLoading.show(status: "Cargando..");

      try {
        Map info = await _notasPendientesProvider.obtieneEstanteSugerido(
            _txtNota.text);

        EasyLoading.dismiss();

        if (info['ok']) {
          final String lvEstante = info['estante'];
          _txtEstante.text = lvEstante;
          if(lvEstante.length > 0){

              _estanteHabilitado = false;

          }else{

              _estanteHabilitado = true;

          }
          bloc.setEstante(lvEstante);
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


  Future<bool> _validaEstanteSugerido() async {

    DetallesNotaProviders _notasPendientesProvider = new DetallesNotaProviders();

    bool resp = false;

    EasyLoading.show(status: "Cargando..");

    try {
      Map info = await _notasPendientesProvider.obtieneEstanteSugerido(
          _txtNota.text);

      EasyLoading.dismiss();

      if (info['ok']) {
        final String lvEstante = info['estante'];

        if(lvEstante.length > 0){
          if(lvEstante != _txtEstante.text){
              _txtEstante.text = lvEstante;
              bloc.setEstante(lvEstante);
             resp = false;
              mostrarMensaje(context, 'Información', 'Estante sugerido asignado!!');
          }else{
            resp = true;
          }
          _estanteHabilitado = false;


        }else {
          resp = true;
        }
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

    return resp;

  }


  void limpiar(){

      bloc.setEstante("");
      bloc.setNroReg("");

      _txtNota.text = "";
      _txtEstante.text = "";

      FocusScope.of(context).requestFocus(_focusNroReg);

  }

}
