

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pegasus_flt/src/blocs/provider.dart';
import 'package:pegasus_flt/src/model/argument_2parametros.dart';
import 'package:pegasus_flt/src/model/nota_pendiente_model.dart';
import 'package:pegasus_flt/src/providers/notas_pendientes_providers.dart';
import 'package:pegasus_flt/src/utils/preferencias_usuario.dart';
import 'package:pegasus_flt/src/utils/utils.dart';

class TesteInicioPage extends StatefulWidget {

  @override
  _TesteInicioPageState createState()=> _TesteInicioPageState();

}

class _TesteInicioPageState extends State<TesteInicioPage> {
  final prefs = new PreferenciasUsuario();
  final _txtCliente = TextEditingController();
  int _radioValue1 = 2;

  @override
  Widget build(BuildContext context) {

    final bloc = Provider.nroRegBloc(context);
    bloc.clear();
    return Scaffold(
        appBar: appBar(),
        body:SingleChildScrollView(
          child:  Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                    child: Column(
                      children: [
                        Text("Buscar Notas", style: TextStyle(fontSize: 23.0),),
                      ],
                    )
                ),
                Container(
                  padding: EdgeInsets.only(left: 25),
                  alignment: Alignment.centerLeft,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Radio(
                        value: 2,
                        groupValue: _radioValue1,
                        onChanged: (value){
                          setState(() {
                            FocusScope.of(context).requestFocus(new FocusNode());
                            _radioValue1 = value;
                            _txtCliente.text = "";
                          });
                        },
                      ),
                      new Text(
                        'Nro. Nota',
                        style: new TextStyle(fontSize: 14.0),
                      ),
                      new Radio(
                        value: 0,
                        groupValue: _radioValue1,
                        onChanged: (value){
                          setState(() {
                            FocusScope.of(context).requestFocus(new FocusNode());
                            _radioValue1 = value;
                            _txtCliente.text = "";
                          });
                        },
                      ),
                      new Text(
                        'Nro. Factura',
                        style: new TextStyle(fontSize: 14.0),
                      ),
                      new Radio(
                        value: 1,
                        groupValue: _radioValue1,
                        onChanged: (value){
                          setState(() {
                            FocusScope.of(context).requestFocus(new FocusNode());
                            _radioValue1 = value;
                            _txtCliente.text = "";
                          });
                        },
                      ),
                      new Text(
                        'Cliente',
                        style: new TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: _creaTextFieldCliente(),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: _crearBotonBuscar(),
                )
              ],
            ),
          ),
        )
      );
  }

  Widget appBar () {
    return AppBar(
      centerTitle: false,
      title: Text('${prefs.nombreUsuario}'),
      actions: [
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

    prefs.nombreUsuario = '';
    prefs.separador = '';
    prefs.idUsuario = '0';
    Navigator.pushReplacementNamed(c, 'login');

  }


  Widget _creaTextFieldCliente(){
    return TextField(
      controller: _txtCliente,
      keyboardType: (_radioValue1 == 0 || _radioValue1 == 2) ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Buscar',
        labelStyle: TextStyle(color: Colors.black),
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

            _txtCliente.text = barcodeScanRes;
          },
          icon: Icon(Icons.settings_overscan),
        ),
      ),
    );
  }

  Widget _crearBotonBuscar(){

    return ElevatedButton(
      child: Row (
        children: [
          Expanded(flex: 8, child: SizedBox()),
          Expanded(
              flex: 1,
              child: SizedBox()
          ),
          Container(

            child: Text('BUSCAR'),
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

        if(_radioValue1==2){
          NotasPendientesProviders _notasPendientesProvider = new NotasPendientesProviders();

          EasyLoading.show(status: "Cargando..");

          try {
            Map info = await _notasPendientesProvider.validaNotaEnSistema(_txtCliente.text);

            EasyLoading.dismiss();

            if (!info['ok']) {
              mostrarAlerta(context, 'Nota no encontrada!');
            } else {
              NotaPendienteModel notas = info['nota'];

              await Navigator.pushNamed(context, 'teste_nota_seleccionada', arguments: notas.nroReg.toString());

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
        }else{

          Parameters2Arguments param = new Parameters2Arguments(_radioValue1, _txtCliente.text);
          Navigator.pushNamed(context, 'teste_notas_encontradas', arguments: param);

        }



      },
    );

  }

}
