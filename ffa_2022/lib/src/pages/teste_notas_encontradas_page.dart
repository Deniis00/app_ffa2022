
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ffa_2022/src/model/argument_2parametros.dart';
import 'package:ffa_2022/src/model/teste_notas_encontradas_model.dart';
import 'package:ffa_2022/src/providers/teste_notas_encontradas_provider.dart';
import 'package:ffa_2022/src/widgets/DividerC.dart';



class TesteNotasEncontradasPage extends StatefulWidget{



  Parameters2Arguments _parametros;

  TesteNotasEncontradasPage(this._parametros);

  @override
  _TesteNotasEncontradasPageState createState()=> _TesteNotasEncontradasPageState();


}

class _TesteNotasEncontradasPageState extends State<TesteNotasEncontradasPage> with TickerProviderStateMixin {

  List<TesteNotasEncontradasModel> _listaTesteNotasEncontradas;

  Size _size ;

  @override
  Widget build(BuildContext context) {

    _size = MediaQuery.of(context).size;

    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
        },
        child:Scaffold(
          appBar: AppBar(
            title: Text("Notas Encontradas"),
          ),
          body: Column(
            children: [
              Expanded(
                child: _cargaTransferencias()
              ),
            ],
          ),
        )
    );

  }


  Widget _cargaTransferencias(){

    String filtro1 = "";
    String filtro2 = "";

    if(widget._parametros.getTipo == 0 ||widget._parametros.getTipo == 2){
       filtro1 = widget._parametros.getFiltro;
    }else{
      filtro2 = widget._parametros.getFiltro;
    }

    return FutureBuilder(
        future: new TesteNotasEncontradasProvider().getListaTesteNotasEncontradas(filtro1, filtro2),
        builder: (BuildContext context, AsyncSnapshot<List<TesteNotasEncontradasModel>> snapshot) {
          if(snapshot.hasData){

            _listaTesteNotasEncontradas = snapshot.data;

//            return Container();
            return   ListView.builder(

              itemCount: _listaTesteNotasEncontradas.length,
              itemBuilder: (context, i) =>  Column(
                children: [
                  itemTransferencias(_listaTesteNotasEncontradas[i]),
                  DividerC()
                ],
              ),
            );


          }else{
            return Center( child: CircularProgressIndicator());
          }
        }
    );

  }


  Widget itemTransferencias(TesteNotasEncontradasModel notas){
    return InkWell(
      onTap: () async {
        Navigator.pushNamed(context, 'teste_nota_seleccionada', arguments: notas.nroReg);
      },
      child:Container(

        padding: EdgeInsets.all(5),
        child:  Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Container(
                        width: _size.width * 0.40,
                        alignment: Alignment.centerLeft,
                        child: Text("Nro. Reg.: ${notas.nroReg}", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                      ),
                      Container(
                          width: _size.width * 0.5,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Text("Nro. Factura: ", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                              Container(
                                alignment: Alignment.centerLeft,
                                width: _size.width * 0.2,
                                child: Text("${notas.nroFactura}", style: TextStyle(color: Colors.black, fontSize: 15),textAlign: TextAlign.center,),
                              )
                            ],
                          )
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text("Cliente: ", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                      ),
                      Expanded(
                        child:Container(
                          alignment: Alignment.centerLeft,
                          child: Text("${notas.cliente}",overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black, fontSize: 15),textAlign: TextAlign.center,),
                        ),
                      ),

                    ],
                  ),
                )
              ]
          ),
        ),

      ),
    );

  }





}