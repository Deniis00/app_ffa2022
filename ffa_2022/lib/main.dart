
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:ffa_2022/src/blocs/provider.dart';
import 'package:ffa_2022/src/pages/asignar_estante_pages.dart';
import 'package:ffa_2022/src/pages/busca_notas_separadas.dart';
import 'package:ffa_2022/src/pages/consulta_detalles_nota_page.dart';
import 'package:ffa_2022/src/pages/detalles_nota_page.dart';
import 'package:ffa_2022/src/pages/ingresa_estante_page.dart';
import 'package:ffa_2022/src/pages/login_page.dart';
import 'package:ffa_2022/src/pages/notas_pendientes_page.dart';
import 'package:ffa_2022/src/pages/selecciona_impresora_radar_page.dart';
import 'package:ffa_2022/src/pages/selecciona_sistema_page.dart';
import 'package:ffa_2022/src/pages/separacion_por_nota_page.dart';
import 'package:ffa_2022/src/pages/teste_inicio_page.dart';
import 'package:ffa_2022/src/pages/teste_nota_selecionada_page.dart';
import 'package:ffa_2022/src/pages/teste_notas_encontradas_page.dart';
import 'package:ffa_2022/src/utils/preferencias_usuario.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

  runApp(MyApp());
  customEasy();

}


void customEasy(){
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.dualRing
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 15.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.grey
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.black38.withOpacity(0.6)
    ..userInteractions = false
    ..dismissOnTap = false
    ..maskType = EasyLoadingMaskType.custom;
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();

}

class _MyAppState extends State<MyApp>{

  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  @override
  void initState(){

    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    final prefs = new PreferenciasUsuario();

    return Provider(
      child:  MaterialApp(
        builder:   EasyLoading.init(),
        title: 'FFA_2022',
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        initialRoute: (prefs.opcionSistema.toString().length == 0)
                ? 'selecciona_sistema'
                : (prefs.opcionSistema == "1")
                  ? (prefs.radar.toString().length == 0)
                    ? 'selecciona_radar'
                    : (prefs.nombreUsuario.toString().length == 0)
                      ? 'login'
                      : 'selecciona_radar'
                  : (prefs.nombreUsuario.toString().length == 0)
                    ? 'login'
                    : 'teste_inicio',
        onGenerateRoute: (RouteSettings settings) {
            var routes = <String, WidgetBuilder>{
              'login'                     : (ctx) => LoginsPage(),
              'notas_pendientes'          : (ctx) => NotasPendientesPage(),
              'detalles_nota'             : (ctx) => DetallesNotaPage(settings.arguments),
              'ingresar_estante'          : (ctx) => IngresaEstantePage(settings.arguments),
              'busca_notas_separadas'     : (ctx) => BuscaNotasSeparadasPage(),
              'consulta_detalles_nota'    : (ctx) => ConsultaDetallesNotaPage(settings.arguments),
              'selecciona_radar'          : (ctx) => SeleccionarImpresoraRadarPage(),
              'asigna_estante'            : (ctx) => AsignaEstantePage(),
              'selecciona_sistema'        : (ctx) => SeleccionarSistemaPage(),
              'teste_inicio'              : (ctx) => TesteInicioPage(),
              'teste_notas_encontradas'   : (ctx) => TesteNotasEncontradasPage(settings.arguments),
              'teste_nota_seleccionada'   : (ctx) => TesteNotaSeleccionadaPage(settings.arguments),
              'separar_por_nota'          : (ctx) => SepararPorNotaPage(),
            };

            WidgetBuilder builder = routes[settings.name];
            return MaterialPageRoute(builder: (ctx) => builder(ctx));
        },
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          primaryColor: Colors.blue,
          primaryIconTheme: IconThemeData(color: Colors.white),
          primaryTextTheme: TextTheme(
              headline6: TextStyle(
                  color: Colors.white
              )
          ),
        ),
      ),
    );

  }

}