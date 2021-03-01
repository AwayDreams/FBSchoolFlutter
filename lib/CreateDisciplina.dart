import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fbsproject/BancoAPI.dart';
import 'package:fbsproject/Alertas.dart';
import 'package:fbsproject/User.dart';
import 'package:fbsproject/selecaoAeP.dart';
import 'dart:convert';

class CreateDisciplina extends StatefulWidget {
  @override
  _CreateDisciplinaState createState() => _CreateDisciplinaState();
}

class _CreateDisciplinaState extends State<CreateDisciplina> {
  TextEditingController controleNome = new TextEditingController();
  TextEditingController controleHoras = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.fromLTRB(50,30,50,30),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Column(
                        children: [
                          Text("Digite o Nome: "),
                          TextField(
                              controller: controleNome,
                              obscureText: false,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                      child: Column(
                        children: [
                          Text("Digite a Carga Horaria: (em Horas)"),
                          TextField(
                              controller: controleHoras,
                              obscureText: false,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              )),
                        ],
                      ),
                    ),
                    RaisedButton(
                        onPressed: () async {
                          http.Response info =
                          await BancoAPI.CreateDisciplina(
                              controleNome.text, controleHoras.text);
                          //verifica se há error
                          if (info.body.contains("errno")) {
                            Map<String, dynamic> body =
                            json.decode(info.body);
                            if (body["errno"].toString() == "1062") {
                              Alertas.showAlertDialog(context,
                                  "Turma ja existente code: ${body["errno"]}");
                            } else {
                              Alertas.showAlertDialog(
                                  context, "code: ${body["errno"]}");
                            }
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
                          child: const Text('Criar',
                              style: TextStyle(fontSize: 20)),
                        ))
                  ],
                ))));
  }
}
