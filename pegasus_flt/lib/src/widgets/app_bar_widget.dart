import 'package:flutter/material.dart';
import 'package:pegasus_flt/src/utils/preferencias_usuario.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBar({Key key}) : preferredSize = Size.fromHeight(kToolbarHeight), super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar>{

  final prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    return appBarC(context);
  }


  Widget appBarC(BuildContext context){
    return AppBar(
      centerTitle: false,
      title: Text('${prefs.nombreUsuario} - Radar ${prefs.radar}'),
      actions: [
        IconButton(
          icon: Icon(Icons.archive, size: 30.0,),
          color: Colors.white,
          onPressed: (){
            _asignaEstante();
          },
        ),
        IconButton(
          icon: Icon(Icons.search, size: 30.0,),
          color: Colors.white,
          onPressed: (){
            _buscaNotasSeparadas();
          },
        ),
        IconButton(
          icon: Icon(Icons.logout, size: 30.0,),
          color: Colors.white,
          onPressed: (){
            _logOut(context);
          },
        )
      ],
    );
  }

  _logOut(BuildContext c) async {
    //final usuarioProvider = new UsuarioProvider();
    //Map info = await usuarioProvider.desactivarTokenMensaje(c, prefs.usuario, prefs.password, prefs.token);
    //if(!info['ok']){
    //mostrarAlerta(c, 'Error al desconectar!!');
    //}else {

    prefs.nombreUsuario = '';
    prefs.separador = '';
    prefs.idUsuario = '0';
    Navigator.pushReplacementNamed(c, 'login');

    //}

  }

  _buscaNotasSeparadas(){
      Navigator.pushNamed(context, 'busca_notas_separadas');
  }

  _asignaEstante(){
    Navigator.pushNamed(context, 'asigna_estante');
  }

}

class CustomAppBarSec extends StatefulWidget implements PreferredSizeWidget {

 // CustomAppBarSec({Key key, this.titulo}) : preferredSize = Size.fromHeight(kToolbarHeight), super(key: key);

  @override
  final Size preferredSize = Size.fromHeight(kToolbarHeight); // default is 56.0
  String titulo;

  CustomAppBarSec(String titulo){
    this.titulo = titulo;
  }

  @override
  _CustomAppBarSecState createState() => _CustomAppBarSecState();
}

class _CustomAppBarSecState extends State<CustomAppBarSec>{

  final prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    return appBarC(context);
  }


  Widget appBarC(BuildContext context){
    return AppBar(
      centerTitle: false,
      title: Text(widget.titulo),
      actions: [
      ],
    );
  }

}