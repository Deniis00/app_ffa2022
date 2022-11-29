
import 'package:flutter/material.dart';
import 'package:ffa_2022/src/blocs/provider.dart';
import 'package:ffa_2022/src/utils/preferencias_usuario.dart';
import 'package:ffa_2022/src/widgets/app_bar_widget.dart';

class SeleccionarSistemaPage extends StatefulWidget {



  @override
  _SeleccionarSistemaPageState createState()=> _SeleccionarSistemaPageState();

}

class _SeleccionarSistemaPageState extends State<SeleccionarSistemaPage> {

  final _txtNroReg = TextEditingController();
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _seleccionado = "";

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
        appBar: CustomAppBarSec("Seleccionar Sistema"),
        body: Center(
          child: Container(

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: _crearBotonSeparacion(),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: _crearBotonTeste(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _crearBotonSeparacion(){

    return ElevatedButton(
      child: Row (
        children: [
          Expanded(flex: 8, child: SizedBox()),
          Icon(
            Icons.arrow_right,
            color: Colors.white,
          ),
          Expanded(
              flex: 1,
              child: SizedBox()
          ),
          Container(

            child: Text('SEPARACION'),
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
          backgroundColor: Colors.blueGrey,
          textStyle: TextStyle(color: Colors.white)),
      onPressed: () {

        final prefs = new PreferenciasUsuario();
        prefs.opcionSistema = "1";
        if(prefs.radar != ""){
          Navigator.pushReplacementNamed(context, 'login');
        }else{
          Navigator.pushReplacementNamed(context, 'selecciona_radar');
        }


      },
    );

  }

  Widget _crearBotonTeste(){

    return ElevatedButton(
      child: Row (
        children: [
          Expanded(flex: 8, child: SizedBox()),
          Icon(
            Icons.arrow_right,
            color: Colors.white,
          ),
          Expanded(
              flex: 1,
              child: SizedBox()
          ),
          Container(

            child: Text('TESTE'),
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
          backgroundColor: Colors.blueGrey,
          textStyle: TextStyle(color: Colors.white)),
      onPressed: () {

        final prefs = new PreferenciasUsuario();
        prefs.opcionSistema = "2";
        Navigator.pushReplacementNamed(context, 'login');

      },
    );

  }

}
