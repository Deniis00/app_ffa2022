

import 'package:ffa_2022/src/utils/preferencias_usuario.dart';
import 'package:flutter/material.dart';

import '../blocs/provider.dart';
import '../widgets/app_bar_widget.dart';

class InicioPage extends StatefulWidget {
  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {

  final _txtEstante = TextEditingController();
  final pref = new PreferenciasUsuario();


  @override
  Widget build(BuildContext context) {
    final bloc = Provider.nroRegBloc(context);
    bloc.clear();
    if(pref.apiUrl == "" || pref.apiUrl == null) {
      _txtEstante.text = "http://";
    }else{
      _txtEstante.text = pref.apiUrl;

    }

    return WillPopScope(
      onWillPop: () {
        bloc.clear();
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
            backgroundColor: Colors.red,
        ),
        body: Center(
          child: Container(

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    autofocus: true,
                    controller: _txtEstante,
                    decoration: InputDecoration(
                      icon: Icon(Icons.exit_to_app, color: Colors.deepOrangeAccent,),
                      labelText: 'Ingrese url api',

                    ),
                    onChanged: bloc.changeEstante,
                    onSubmitted: (text){

                      pref.apiUrl = text;
                      Navigator.pushReplacementNamed(context, 'lee_qr');

                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}


