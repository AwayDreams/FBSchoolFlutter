import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fbsproject/BancoAPI.dart';
import 'package:fbsproject/Alertas.dart';
import 'package:fbsproject/User.dart';
import 'package:fbsproject/selecaoAeP.dart';
import 'dart:convert';

class CreateRelatorio extends StatefulWidget {
  @override
  _CreateRelatorioState createState() => _CreateRelatorioState();
}

class _CreateRelatorioState extends State<CreateRelatorio> {
  int botaoselecionado = 0;
  int materiaselecionada = -1;
  TextEditingController controleText = new TextEditingController();
  ScrollController scrollcontroller;
  List lista;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(mainAxisSize: MainAxisSize.max, children: [
                  for (int i = 0; i < 5; i++)
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Ink(
                        decoration: ShapeDecoration(
                          color: botaoselecionado == i
                              ? Colors.grey
                              : Colors.transparent,
                          shape: CircleBorder(
                              side: BorderSide(
                                  color: Colors.deepPurple, width: 1.0)),
                        ),
                        width: 100.0,
                        height: 100.0,
                        child: IconButton(
                          icon: Image.asset(
                            "images/${i}.png",
                            fit: BoxFit.fill,
                          ),
                          color: Colors.white,
                          onPressed: () {
                            setState(() {
                              botaoselecionado == i
                                  ? botaoselecionado = null
                                  : botaoselecionado = i;
                            });
                          },
                        ),
                      ),
                    ),
                ])),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Container(
                  width: 400,
                  height: 150,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.5,
                      )),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: FutureBuilder(
                        future: User.alunoprofessor == 1
                            ? BancoAPI.SelectAlunoJoinAulaJoinUsuarioWhereAluno(User.user)
                            : BancoAPI.SelectAulaJoinProfessorWhereProfessor(User.user),
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
                              return GridView.builder(
                                shrinkWrap: true,
                                itemCount: _getListandLength(snapshot),
                                scrollDirection: Axis.horizontal,
                                controller: scrollcontroller,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1,
                                    crossAxisSpacing: 1.0,
                                    mainAxisSpacing: 1.0
                                ),
                                itemBuilder: (contexto, index) {
                                  return Card(
                                      elevation: 5,
                                      child: User.alunoprofessor == 1 ? ListTile(
                                        title: Text('${lista[index]["disciplina"]}', style: TextStyle(fontSize: 14)),
                                        tileColor: materiaselecionada ==  index ? Colors.grey : null,
                                        subtitle: Text(
                                            'Turma: ${lista[index]["turma"]} Professor: ${lista[index]["nome"]}', style: TextStyle(fontSize: 12)),
                                        onTap: () {
                                          setState(() {
                                            materiaselecionada == index ? materiaselecionada = -1 : materiaselecionada = index;
                                          });
                                        },
                                      ) : ListTile(
                                        title: Text('${lista[index]["disciplina"]}', style: TextStyle(fontSize: 14)),
                                        tileColor: materiaselecionada ==  index ? Colors.grey : null,
                                        subtitle: Text(
                                            'Turma: ${lista[index]["turma"]} Professor: ${lista[index]["usuario"]}', style: TextStyle(fontSize: 12)),
                                        onTap: () {
                                          setState(() {
                                            materiaselecionada == index ? materiaselecionada = -1 : materiaselecionada = index;
                                          });
                                        },
                                      )
                                  );
                                },
                              );
                          }
                        }),
                  )),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30,30,30,10),
              child: TextField(
                controller: controleText,
                decoration: InputDecoration(
                  hintText: "Adicionar algum pensamento?",
                  labelStyle: TextStyle(color: Colors.blueAccent, fontSize: 25),
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                minLines: 5,
                selectionHeightStyle: BoxHeightStyle.max,
              ),
            ),
            RaisedButton(
                onPressed: () async {

                  http.Response info = await BancoAPI.CreateRelatorio(
                      botaoselecionado.toString(),controleText.text,
                      lista[materiaselecionada]["id"].toString(), User.user);
                  //verifica se há error
                  if (info.body.contains("errno")) {
                    Map<String, dynamic> body = json.decode(info.body);
                    Alertas.showAlertDialog(
                          context, "code: ${body["errno"]}");
                    }
                  else{
                    Navigator.pop(context);
                  }
                },
                textColor: Colors.white,
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Color(0xFF0D47A1),
                        Color(0xFF1976D2),
                        Color(0xFF42A5F5),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child:
                  const Text('Enviar', style: TextStyle(fontSize: 20)),
                )),
          ],
        ),
      ),
    );
  }

  int _getListandLength(AsyncSnapshot snapshot) {
    http.Response info = snapshot.data;
    this.lista = json.decode(info.body);
    return lista.length;
  }
}
