import 'package:flutter/material.dart';

String baseUrl() {
  return "http://pgs.casanissei.com:180/pegasusflt";
}

String version() {
  return "27";
}

//////FILTRO ESTANTE/////
String _gvFiltro  = "";

String getGvFiltro(){
  return _gvFiltro;
}

void setGvFiltro(String v){
  _gvFiltro = v;
}

bool isNumeric(String s) {
  if (s.isEmpty) return false;

  final n = num.tryParse(s);

  return (n == null) ? false : true;
}

String retornaOrden(String v) {
  if (v == "ID") {
    return "0";
  }

  if (v == "Inactivos") {
    return "1";
  }

  if (v == "Activos") {
    return "2";
  }

  if (v == "Personalizado") {
    return "3";
  }
}

void mostrarAlerta(BuildContext context, String mensaje) {
  showDialog<void>(
    context: context,
    barrierDismissible: true,
    // false = user must tap button, true = tap outside dialog
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Center(
          child: Text('Alerta'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.error,
              size: 100.0,
              color: Colors.deepOrangeAccent,
            ),
            Text(mensaje),
            //CircularProgressIndicator(),
          ],
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              child: Text('Aceptar'),
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

Future mostrarConfirmarcion(BuildContext context, String mensaje) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    // false = user must tap button, true = tap outside dialog
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Center(
          child: Text('Aviso'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.check_circle,
              size: 100.0,
              color: Colors.green,
            ),
            Text(mensaje),
            //CircularProgressIndicator(),
          ],
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              child: Text('Aceptar'),
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

void mostrarMensaje(BuildContext context, String titulo, String mensaje) {
  showDialog<void>(
    context: context,
    barrierDismissible: true,
    // false = user must tap button, true = tap outside dialog
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Center(
          child: Text(titulo),
        ),
        content: new SingleChildScrollView(
          scrollDirection: Axis.vertical, //.horizontal
          child: Text(mensaje),
        ),
//        Column(
//          mainAxisSize: MainAxisSize.min,
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            Text(mensaje),
//            //CircularProgressIndicator(),
//          ],
//        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              child: Text('Aceptar'),
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

Future<bool> MensajeConfirmacion(
    BuildContext context, String titulo, String mensaje) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    // false = user must tap button, true = tap outside dialog
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Center(
          child: Text(titulo),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(mensaje),
            //CircularProgressIndicator(),
          ],
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context, false); // Dismiss alert dialog
              },
            ),
          ),
          Center(
            child: TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.pop(context, true); // Dismiss alert dialog
              },
            ),
          ),
        ],
      );
    },
  ).then((value) {
    if (value != null) {
      return value;
    } else {
      return false;
    }
  });
}

Future<bool> MensajeSiNo(BuildContext context, String titulo, String mensaje) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    // false = user must tap button, true = tap outside dialog
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Center(
          child: Text(titulo),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(mensaje),
            //CircularProgressIndicator(),
          ],
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.pop(context, false); // Dismiss alert dialog
              },
            ),
          ),
          Center(
            child: TextButton(
              child: Text('Si'),
              onPressed: () {
                Navigator.pop(context, true); // Dismiss alert dialog
              },
            ),
          ),
        ],
      );
    },
  ).then((value) {
    if (value != null) {
      return value;
    } else {
      return false;
    }
  });
}
