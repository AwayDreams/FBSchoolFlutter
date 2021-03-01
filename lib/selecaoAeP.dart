import 'dart:convert';

import 'package:fbsproject/Alertas.dart';
import 'package:fbsproject/BancoAPI.dart';
import 'package:fbsproject/SelecaoTurma.dart';
import 'package:fbsproject/User.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class selecaoAeP extends StatefulWidget {
  @override
  _selecaoAePState createState() => _selecaoAePState();
}

class _selecaoAePState extends State<selecaoAeP> {
  TextEditingController controleHoras = new TextEditingController();
  TextEditingController controleSobre = new TextEditingController();

  int indexselect = 0; // 0 - IDLE / 1 - ALUNO / 2 - PROFESSOR

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Text("Bem-vindo ao FBSProject",
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(50.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 10),
                            child: ChoiceChip(
                              label: Text("Aluno"),
                              avatar: Icon(Icons.school),
                              selected: indexselect == 1 ? true : false,
                              onSelected: (value) {
                                setState(() {
                                  indexselect == value
                                      ? indexselect = 0
                                      : indexselect = 1;
                                });
                              },
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 10),
                              child: ChoiceChip(
                                label: Text("Professor"),
                                avatar: Icon(Icons.directions_walk),
                                selected: indexselect == 2 ? true : false,
                                onSelected: (value) {
                                  setState(() {
                                    indexselect == value
                                        ? indexselect = 0
                                        : indexselect = 2;
                                  });
                                },
                              )),
                        ],
                      ),
                      if (indexselect == 1)
                        FormularioAluno()
                      else if (indexselect == 2)
                        FormularioProf()
                      else
                        FormularioNull()
                    ]))));
  }

  Widget FormularioProf() {
    return Column(children: [
      Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Digite sua Carga Horaria: (em Horas)",
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: TextField(
                    controller: controleHoras,
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    )),
              )
            ],
          )),
      Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sobre você:",
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: TextField(
                    controller: controleSobre,
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    )),
              )
            ],
          )),
      RaisedButton(
          onPressed: () async {
            http.Response info =
                await BancoAPI.CreateProf(User.user, controleHoras.text, controleSobre.text);

            //verifica se há error
            if (info.body.contains("errno")) {
              Map<String, dynamic> body = json.decode(info.body);
              if (body["errno"].toString() == "1062") {
                Alertas.showAlertDialog(
                    context, "Usuario ja existente code: ${body["errno"]}");
              } else {
                Alertas.showAlertDialog(context, "code: ${body["errno"]}");
              }
            }

            else{
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SelecaoTurma()));
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
            child: const Text('Continuar', style: TextStyle(fontSize: 20)),
          )),
    ]);
  }

  Widget FormularioAluno() {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Digite seu RA: ",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: TextField(
                      controller: controleHoras,
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      )),
                )
              ],
            )),
        RaisedButton(
            onPressed: () async {
              http.Response info =
                  await BancoAPI.CreateAluno(User.user, controleHoras.text);

              //verifica se há error
              if (info.body.contains("errno")) {
                Map<String, dynamic> body = json.decode(info.body);
                if (body["errno"].toString() == "1062") {
                  Alertas.showAlertDialog(
                      context, "Usuario ja existente code: ${body["errno"]}");
                } else {
                  Alertas.showAlertDialog(context, "code: ${body["errno"]}");
                }
              }

              else{
                User.alunoprofessor = indexselect;
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SelecaoTurma()));
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
              child: const Text('Continuar', style: TextStyle(fontSize: 20)),
            )),
      ],
    );
  }

  Widget FormularioNull() {
    return Center(
      child: Text(
        "Escolha uma opção acima",
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
