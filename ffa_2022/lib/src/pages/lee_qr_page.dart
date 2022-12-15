import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../model/funcionario_model.dart';
import '../providers/funcionarios_providers.dart';
import '../widgets/app_bar_widget.dart';

class LeeQrPage extends StatefulWidget {
  @override
  State<LeeQrPage> createState() => _LeeQrPageState();
}

class _LeeQrPageState extends State<LeeQrPage> {

  FuncionariosProviders _funcionariosProvider = new FuncionariosProviders();


  @override
  Widget build(BuildContext context) {



    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
        },
        child: Scaffold(
            appBar: AppBar(
                title: const Text(
                  'FFA 2022',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)
                ),
                centerTitle: true,
                titleTextStyle: TextStyle(
                      color: Colors.white,
                ),
                backgroundColor: Color.fromRGBO(255, 0, 0, 1),
              actions: [
                IconButton(
                  icon: Icon(Icons.list_outlined, size: 30.0,),
                  color: Colors.white,
                  onPressed: () {
                    obtenerFuncionarios();
                  },
                ),
              ],
            ),
            body: Center(child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/img/Logo-FFA.png"),
                  fit: BoxFit.contain,
                ),
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(

                    margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    child: SizedBox(
                      width: 200,
                      child:_crearBotonLeerQr(),
                    )
                  ),
                ],
              ),
            ))));
  }

  Widget _crearBotonLeerQr(){

    return ElevatedButton(
      onPressed: () async {

        String barcodeScanRes = "";
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
        //barcodeScanRes = "2364";

        if(barcodeScanRes.length > 0){

          EasyLoading.show(status: "Cargando..");
          try {


            FuncionarioModel funcionario = await _funcionariosProvider.actualizaMuestraFuncionario2(context, barcodeScanRes);
            if(funcionario.id > 0) {
              mostrarMensaje(context, "FFA 2022", "BIENVENIDO..",
                  funcionario.nombreFuncionario);
            }
            EasyLoading.dismiss();


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
      child: const Icon(Icons.qr_code_2_sharp, color: Colors.white,),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        backgroundColor:
        MaterialStateProperty.all<Color>(Color.fromRGBO(255, 0, 0, 1)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );

  }

  obtenerFuncionarios(){
    Navigator.pushNamed(context, 'lista-funcionarios');
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
}

