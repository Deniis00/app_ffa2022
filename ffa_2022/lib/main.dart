
import 'package:ffa_2022/src/pages/inicio_page.dart';
import 'package:ffa_2022/src/pages/lee_qr_page.dart';
import 'package:ffa_2022/src/pages/lista_funcionarios.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:ffa_2022/src/blocs/provider.dart';
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
        initialRoute: 'inicio',
        onGenerateRoute: (RouteSettings settings) {
            var routes = <String, WidgetBuilder>{
              'lee_qr'                    : (ctx) => LeeQrPage(),
              'inicio'                    : (ctx) => InicioPage(),
              'lista-funcionarios'        : (ctx) => ListaFuncionariosPage(),
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