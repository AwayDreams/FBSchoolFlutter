import 'package:fbsproject/Home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fbsproject/BancoAPI.dart';
import 'package:fbsproject/Alertas.dart';
import 'package:fbsproject/User.dart';
import 'package:fbsproject/selecaoAeP.dart';
import 'dart:convert';

class CreateAula extends StatefulWidget {
  List turma;
  int index;
  CreateAula(List turma, int index){
    this.turma = turma;
    this.index = index;
  }

  @override
  _CreateAulaState createState() => _CreateAulaState(turma, index);
}

class _CreateAulaState extends State<CreateAula> {
  List turma;
  int index;
  List lista;

  _CreateAulaState(List turma, int index) {
    print("index: ${index}");
    this.turma = turma;
    this.index = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            children: [
              Text("Professor"),
              FutureBuilder(
                  future: BancoAPI.SelectProfJoinUser(User.user),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Container(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.blue),
                            strokeWidth: 5.0,
                          ),
                        );
                      default:
                        return Card(
                            elevation: 5,
                            child: ListTile(
                              leading: Icon(Icons.school),
                              title: Text('${_getList(snapshot)[0]["nome"]}'),
                              subtitle: Text(
                                  'Carga Horaria: ${_getList(snapshot)[0]["cargahoraria"]}, Usuario: ${_getList(snapshot)[0]["usuario"]}'),
                            )
                        );
                    }
                  }),
              Text("Sala selecionada:"),
              Card(
                  elevation: 5,
                  child: ListTile(
                    leading: Icon(Icons.school),
                    title: Text('${turma[index]["id"]}'),
                    subtitle: Text(
                        'Turno: ${turma[index]["turno"]} Ano: ${turma[index]["ano"]}'),
                  )),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text("Selecione a Disciplina:"),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      )
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20,10,20,10),
                    child:
                    FutureBuilder(
                        future: BancoAPI.SelectDisciplina(),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                            case ConnectionState.none:
                              return Container(
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                  strokeWidth: 5.0,
                                ),
                              );
                            default:
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: _getListandLength(snapshot),
                                itemBuilder: (contexto, index2) {
                                  return Card(
                                      elevation: 5,
                                      child: ListTile(
                                        leading: Icon(Icons.school),
                                        title: Text('${lista[index2]["nome"]}'),
                                        subtitle: Text(
                                            'Carga Horaria: ${lista[index2]["cargahoraria"]}'),
                                        onTap: () async {
                                          print(turma[index]["id"].toString());
                                          print(lista[index2]["nome"].toString());
                                          print(User.user);
                                          http.Response info = await BancoAPI.CreateAula(turma[index]["id"].toString(), lista[index2]["nome"].toString(), User.user);
                                          //verifica se há error
                                          if (info.body.contains("errno")) {
                                            Map<String, dynamic> body = json.decode(info.body);
                                            if (body["errno"].toString() == "1062") {
                                              Alertas.showAlertDialog(context,
                                                  "Turma ja existente code: ${body["errno"]}");
                                            } else {
                                              Alertas.showAlertDialog(context,
                                                  "code: ${body["errno"]}");
                                            }
                                          }else{
                                            Alertas.showAulaAlert(
                                                context, "Turma: ${turma[index]["id"]} \n Disciplina: ${lista[index2]["nome"]} \n Professor: ${User.user}");

                                          }
                                        },
                                      ));
                                },
                              );
                          }
                        }),
                  )),)

            ],
          ),
      ),
    );
  }

  List _getList(AsyncSnapshot snapshot) {
    http.Response info = snapshot.data;
    List lista = json.decode(info.body);
    print(lista);
    return lista;
  }

  int _getListandLength(AsyncSnapshot snapshot) {
    http.Response info = snapshot.data;
    this.lista = json.decode(info.body);
    return lista.length;
  }

}
