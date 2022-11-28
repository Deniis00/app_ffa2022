import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:pegasus_flt/src/blocs/provider.dart';
import 'package:pegasus_flt/src/providers/usuario_providers.dart';
import 'package:pegasus_flt/src/utils/preferencias_usuario.dart';
import 'package:pegasus_flt/src/utils/utils.dart';

import '../utils/utils.dart';

class LoginsPage extends StatelessWidget {

  Size _size ;
  final usuarioProvider = new UsuarioProvider();

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _crearFondo(),
          _loginForm(context)
        ],
      ),
    );
  }

  Widget _loginForm(BuildContext context) {

    final bloc = Provider.of(context);

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              height: _size.height * 0.23,
            ),
          ),
          Container(
            width: _size.width * 0.8,
            margin: EdgeInsets.symmetric(vertical: 30.0 ),
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3.0,
                    offset: Offset(0.0, 5.0),
                    spreadRadius: 3.0,
                  )
                ]
            ),
            child: Column(
              children: <Widget>[
                Text('Ingresar', style: TextStyle(fontSize: 20.0)),
                SizedBox(height: 40.0,),
                _crearUsuario(bloc),
                SizedBox(height: 30.0,),
                _crearBoton(bloc),
              ],
            ),
          ),
          Text("Ver. "+version(), style: TextStyle(fontWeight: FontWeight.bold),),
          _switchSistema(context)
        ],
      ),
    );


  }


  Widget _crearUsuario(LoginBloc bloc){

    return StreamBuilder(stream: bloc.usuarioStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            autofocus: true,
            //keyboardType: TextInputType.text,
            decoration: InputDecoration(
              icon: Icon(Icons.person, color: Colors.deepOrangeAccent,),
              //hintText: 'Usuario',
              labelText: 'Nro. Separador',
              counterText: (snapshot.data != null)
                  ? 'Caracteres: ${ snapshot.data.toString().length }'
                  : 'Caracteres: 0',
              errorText: snapshot.error,
            ),
            onChanged: bloc.changeUsuario,
          ),
        );

      },
    );// unreachable}, )

  }

  Widget _crearBoton(LoginBloc bloc){

    return StreamBuilder(stream: bloc.usuarioStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        return ElevatedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0),
            child: Text('Ingresar'),
          ),
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              elevation: 0.0,
              backgroundColor: Colors.lightBlue,
              textStyle: TextStyle(color: Colors.white)),

          onPressed: snapshot.hasData ? () => _login(context, bloc) : null,
        );

      },
    );

  }

  Widget _switchSistema(BuildContext context){

    return ElevatedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 1.0),
            margin: EdgeInsets.symmetric(horizontal: 1.0),
            child: Icon(Icons.swap_horiz),
          ),
      style: ElevatedButton.styleFrom(

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.green,
          textStyle: TextStyle(color: Colors.white)),
          onPressed: (){
                 Navigator.pushReplacementNamed(context, 'selecciona_sistema');
          },
        );

  }

  _login(BuildContext context, LoginBloc bloc) async {
    /*print('===============');
    print('Email   : ${bloc.usuario}');
    print('Password: ${bloc.password}');
    print('===============');
    Navigator.pushReplacementNamed(context, 'home');*/
    final prefs = new PreferenciasUsuario();

    EasyLoading.show(status: "Cargando..");

    Map info = await usuarioProvider.loginSeparador(context, bloc.usuario);

    EasyLoading.dismiss();

//    print(info);
    if(!info['ok']){
      mostrarAlerta(context, 'Usuario Incorrecto');
    }else {

      prefs.separador = bloc.usuario;
      prefs.nombreUsuario = info['nombreUsuario'];
      prefs.idUsuario = info['idUsuario'].toString();
      bloc.clearUsuario();
      if(prefs.opcionSistema == "1") {
        Navigator.pushReplacementNamed(context, 'notas_pendientes');
      }else{
        Navigator.pushReplacementNamed(context, 'teste_inicio');
      }

    }

    /*return FutureBuilder(
        future: usuarioProvider.login(context, bloc.usuario, bloc.password),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          print('pasa');
          return Container();
        }
        );*/



  }

  Widget _crearFondo(){


    final fondoCabecera =  Container(
      height: _size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.deepOrangeAccent,
        /*gradient: LinearGradient(
            colors: <Color>[
              Colors.deepOrange,
              Colors.deepOrange
            ]
        ),*/
      ),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromRGBO(255, 255, 255, 0.08)
      ),
    );

    final logo = Container(
        padding: EdgeInsets.only(top: 80.0),
        child: Column(
          children: <Widget>[
            Image(
              width: _size.height * 0.40,
              image: AssetImage('assets/img/nissei.png'),
            ),
            SizedBox(width: double.infinity)
          ],
        )
    );

    return Stack(
      children: <Widget>[
        fondoCabecera,
        Positioned(top: 90.0, left: 30.0,child: circulo,),
        Positioned(top: -40.0, right: -30.0,child: circulo,),
        Positioned(bottom: -50.0, left: 30.0,child: circulo,),
        logo
      ],
    );

  }



}
