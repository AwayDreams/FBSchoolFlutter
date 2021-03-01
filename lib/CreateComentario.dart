import 'package:fbsproject/Home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fbsproject/BancoAPI.dart';
import 'package:fbsproject/Alertas.dart';
import 'package:fbsproject/User.dart';
import 'package:fbsproject/selecaoAeP.dart';
import 'dart:convert';

class CreateComentario extends StatefulWidget {
  List relatorio;
  int index;

  CreateComentario(List relatorio, int index) {
    this.relatorio = relatorio;
    this.index = index;
  }

  @override
  _CreateComentarioState createState() => _CreateComentarioState(relatorio, index);
}

class _CreateComentarioState extends State<CreateComentario> {
  List relatorio;
  int index;

  _CreateComentarioState(List relatorio, int index){
    this.relatorio = relatorio;
    this.index = index;
  }

  List lista;
  TextEditingController textcontroller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
           GestureDetector(
            child: Icon(Icons.delete),
            onTap: User.user ==  relatorio[index]["usuario"] ? (){
              Alertas.showRelatorioAlert(context, relatorio[index]["id"].toString());
            } : (){Alertas.showAlertDialog(context, "Somente é possivel apagar relatorios criados por você");}
          )
        ],
      ),
      body: FutureBuilder(
          future: BancoAPI.SelectComentario(relatorio[index]["id"].toString()),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    strokeWidth: 5.0,
                  ),
                );
              default:
                return SingleChildScrollView(
                    child: Column(
                  children: [
                    Corpo(relatorio[index]["qualidade"], relatorio[index]["descricao"], "${relatorio[index]["disciplina"]} - ${relatorio[index]["turma"]}"),
                    BarradeTexto(),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      reverse: true,
                      itemCount: _getListandLength(snapshot),
                      itemBuilder: (context, index) {
                        return Comentario(
                            lista[index]["creator"], lista[index]["conteudo"]);
                      },
                    )
                  ],
                ));
            }
          }),
    );
  }

  int _getListandLength(AsyncSnapshot snapshot) {
    http.Response info = snapshot.data;
    this.lista = json.decode(info.body);
    return lista.length;
  }


  Widget Corpo(int humor, String texto, String datestr) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Container(
            padding: EdgeInsets.all(10),
            width: 1000,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  child: Text(
                    texto,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Container(
                  height: 50,
                  child: Image.asset("images/${humor}.png", fit: BoxFit.fill),
                ),
                Container(
                    child: Text(
                  datestr,
                  style: TextStyle(fontSize: 10),
                )),
              ],
            )));
  }

  Widget Comentario(String usuario, String mensagem) {
    return Container(
        padding: EdgeInsets.all(1),
        width: 1000,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          color: Colors.black,
          width: 1,
        ))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(2),
              child: Text(
                usuario,
                style: TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(mensagem, style: TextStyle(fontSize: 15)),
            )
          ],
        ));
  }

  Widget BarradeTexto() {
    return Padding(
        padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
        child: Container(
            padding: EdgeInsets.fromLTRB(20, 1, 1, 1),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                  decoration: InputDecoration.collapsed(
                      hintText: "digitar um comentario",
                      fillColor: Colors.white),
                  controller: textcontroller,
                )),
                FlatButton(
                    child: Icon(Icons.send),
                    onPressed: () async{
                      if (textcontroller.text.length > 1) {
                          http.Response info = await BancoAPI.CreateComentario(User.user, textcontroller.text, relatorio[index]["id"].toString());
                          //verifica se há error
                          if (info.body.contains("errno")) {
                            Map<String, dynamic> body = json.decode(info.body);
                            Alertas.showAlertDialog(
                                  context, "code: ${body["errno"]}");
                            }
                          else{
                            setState(() {
                              textcontroller.clear();
                            });
                          }
                      }
                    })
              ],
            )));
  }
}
