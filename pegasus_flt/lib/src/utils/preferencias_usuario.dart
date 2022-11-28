

import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario{

  static final PreferenciasUsuario _instancia = new PreferenciasUsuario._internal();

  factory PreferenciasUsuario(){
    return  _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences _prefs;

  initPrefs() async {

    this._prefs = await SharedPreferences.getInstance();

  }

  get password {
    return _prefs.getString('password') ?? '';
  }

  get usuario {
    return _prefs.getString('usuario') ?? '';
  }

  get opcionSistema {
    return _prefs.getString('opcionSistema') ?? '';
  }

  get radar {
    return _prefs.getString('radar') ?? '';
  }

  get separador {
    return _prefs.getString('separador') ?? '';
  }

  get nombreUsuario {
    return _prefs.getString('nombreUsuario') ?? '';
  }

  get idUsuario {
    return _prefs.getString('idUsuario') ?? '0';
  }

  get token {
    return _prefs.getString('token') ?? '';
  }

  set separador(String valor){
    _prefs.setString('separador', valor);
  }

  set nombreUsuario(String valor){
    _prefs.setString('nombreUsuario', valor);
  }

  set idUsuario(String valor){
    _prefs.setString('idUsuario', valor);
  }

  set token(String valor){
    _prefs.setString('token', valor);
  }

  set radar(String valor){
    _prefs.setString('radar', valor);
  }

  set opcionSistema(String valor){
    _prefs.setString('opcionSistema', valor);
  }

  set usuario(String valor){
    _prefs.setString('usuario', valor);
  }

  set password(String valor){
    _prefs.setString('password', valor);
  }

}