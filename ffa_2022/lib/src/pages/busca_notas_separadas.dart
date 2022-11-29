

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ffa_2022/src/blocs/nro_reg_bloc.dart';
import 'package:ffa_2022/src/blocs/provider.dart';
import 'package:ffa_2022/src/model/nota_pendiente_model.dart';
import 'package:ffa_2022/src/providers/notas_pendientes_providers.dart';
import 'package:ffa_2022/src/utils/utils.dart';

class BuscaNotasSeparadasPage extends StatefulWidget {


  @override
  _BuscaNotasSeparadasPageState createState()=> _BuscaNotasSeparadasPageState();

}

class _BuscaNotasSeparadasPageState extends State<BuscaNotasSeparadasPage> {

  final _txtNroReg = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final bloc = Provider.nroRegBloc(context);
    bloc.clear();
    return WillPopScope(
        onWillPop: () {
        bloc.clear();
        Navigator.pop(context);
    },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text("Buscar Nota"),
          actions: [
            IconButton(
              icon: Icon(Icons.settings_overscan, size: 30.0,),
              color: Colors.white,
              onPressed: () async {

                String barcodeScanRes = "";

                /*notifications.initialize(init).then((done) {
              notifications.show(
                  0,
                  "New announcement",
                  "informacion",
                  NotificationDetails(
                      android: AndroidNotificationDetails(
                          "announcement_app_0",
                          "Announcement App",
                          ""
                      ),
                      iOS: IOSNotificationDetails()
                  )
              );
            });*/


                // final bar = await BarcodeScanner.scan();

               /* final bar = await BarcodeScanner.scan();

                //barcodeScanRes  = bar.rawContent;
                barcodeScanRes  = bar;*/
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

                _txtNroReg.text = barcodeScanRes;
                bloc.setEstante(barcodeScanRes);
                _buscaNota();


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


  Widget _crearEstante(NroRegBloc bloc){

    return StreamBuilder(stream: bloc.nroRegStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            //autofocus: true,
            keyboardType: TextInputType.number,
            controller: _txtNroReg,
            decoration: InputDecoration(
              icon: Icon(Icons.exit_to_app, color: Colors.deepOrangeAccent,),
              labelText: 'Nro. Registro',
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

  Widget _crearBoton(BuildContext context,  NroRegBloc bloc){


        return ElevatedButton(

          child: Row (
            children: [
              Expanded(flex: 8, child: SizedBox()),
              Icon(
                Icons.check,
                color: Colors.white,
              ),
              Expanded(
                flex: 1,
                  child: SizedBox()
              ),
              Container(

                child: Text('Buscar'),
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
          onPressed: () {
            _buscaNota();
          },
        );

  }

  void _buscaNota() async {

    if(_txtNroReg.text.length == 0){
      mostrarAlerta(context, 'Debe Ingresar Nro. de Registro.');
    }else {

       NotasPendientesProviders _notasPendientesProvider = new NotasPendientesProviders();

        EasyLoading.show(status: "Cargando..");

        try {
          Map info = await _notasPendientesProvider.validaNota(_txtNroReg.text);

          EasyLoading.dismiss();

          if (!info['ok']) {
            mostrarAlerta(context, 'Nota no encontrada!');
          } else {
            NotaPendienteModel notas = info['nota'];

            await Navigator.pushNamed(
                context, 'consulta_detalles_nota', arguments: notas);
            /*await mostrarConfirmarcion(context, "Nota Nro. ${widget._nroReg}, Separada..!");
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => NotasPendientesPage()),
                (Route<dynamic> route) => false,
          );*/
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

}
