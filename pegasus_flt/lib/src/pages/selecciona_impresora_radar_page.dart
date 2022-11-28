
import 'package:flutter/material.dart';
import 'package:pegasus_flt/src/blocs/nro_reg_bloc.dart';
import 'package:pegasus_flt/src/blocs/provider.dart';
import 'package:pegasus_flt/src/model/impresora_radar_model.dart';
import 'package:pegasus_flt/src/providers/impresora_radar_providers.dart';
import 'package:pegasus_flt/src/utils/preferencias_usuario.dart';
import 'package:pegasus_flt/src/widgets/app_bar_widget.dart';

class SeleccionarImpresoraRadarPage extends StatefulWidget {



  @override
  _SeleccionarImpresoraRadarPageState createState()=> _SeleccionarImpresoraRadarPageState();

}

class _SeleccionarImpresoraRadarPageState extends State<SeleccionarImpresoraRadarPage> {

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
        appBar: CustomAppBarSec("Seleccionar Radar"),
        body: Center(
          child: Container(

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _crearComboBox(),
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


  Widget _crearComboBox(){

    return FutureBuilder(
        future: getDropDownMenuItems(),
        builder: (BuildContext context, AsyncSnapshot<List<DropdownMenuItem<String>>> snapshot) {
            if(snapshot.hasData){

              _dropDownMenuItems = snapshot.data;

              if(_seleccionado.length == 0){
                _seleccionado = _dropDownMenuItems[0].value;
              }

              return DropdownButton<String>(
                value: _seleccionado,
                onChanged: (String newValue) {
                  setState(() {
                    _seleccionado = newValue;
                  });
                },
                items: _dropDownMenuItems,
              );

            }else{
              return Center( child: CircularProgressIndicator());
            }
        }
    );

  }

  Widget _crearComboBoxback(){

    return FutureBuilder(
        future: getDropDownMenuItems(),
        builder: (BuildContext context, AsyncSnapshot<List<DropdownMenuItem<String>>> snapshot) {
          if(snapshot.hasData){

            _dropDownMenuItems = snapshot.data;

            _seleccionado = _dropDownMenuItems[0].value;
            return DropdownButton(
              value: _seleccionado,
              items: _dropDownMenuItems,
              onChanged: changedDropDownItem,
            );

          }else{
            return Center( child: CircularProgressIndicator());
          }
        }
    );

  }

  void changedDropDownItem(String selectedCity) {
    setState(() {
      _seleccionado = selectedCity;
    });
  }


  Widget _crearBoton(BuildContext context,  NroRegBloc bloc){


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

                child: Text('Seleccionar'),
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

              final prefs = new PreferenciasUsuario();
              prefs.radar = _seleccionado;
              Navigator.pushReplacementNamed(context, 'login');

          },
        );

  }



  Future<List<DropdownMenuItem<String>>> getDropDownMenuItems() async {
    List<DropdownMenuItem<String>> items = new List();

    ImpresoraRadarProviders pro = new ImpresoraRadarProviders();

    List<ImpresoraRadarModel> _radares = await pro.getListaImpresorasRadar("");

    for (ImpresoraRadarModel radar in _radares) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(new DropdownMenuItem(
          value: radar.idPrinter.toString(),
          child: new Text(radar.nombre)
      ));
    }
    return items;
  }

}
