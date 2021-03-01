import 'dart:convert';

import 'package:fbsproject/Alertas.dart';
import 'package:fbsproject/BancoAPI.dart';
import 'package:fbsproject/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class CreateTurma extends StatefulWidget {
  @override
  _CreateTurmaState createState() => _CreateTurmaState();
}

class _CreateTurmaState extends State<CreateTurma> {
  TextEditingController controleID = new TextEditingController();
  TextEditingController controleTurno = new TextEditingController();
  TextEditingController controleAno = new TextEditingController();

  int indexselect = 0; // 0 - IDLE 1-MANHA 2-TARDE 3-NOITE

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
            padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
            child: Column(children: [
              Text("Selecione o Turno:"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                    child: ChoiceChip(
                      label: Text("Manha"),
                      avatar: Icon(Icons.wb_sunny),
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
                    padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                    child: ChoiceChip(
                      label: Text("Tarde"),
                      avatar: Icon(Icons.wb_cloudy),
                      selected: indexselect == 2 ? true : false,
                      onSelected: (value) {
                        setState(() {
                          indexselect == value
                              ? indexselect = 0
                              : indexselect = 2;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                    child: ChoiceChip(
                      label: Text("Noite"),
                      avatar: Icon(Icons.brightness_2),
                      selected: indexselect == 3 ? true : false,
                      onSelected: (value) {
                        setState(() {
                          indexselect == value
                              ? indexselect = 0
                              : indexselect = 3;
                        });
                      },
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Column(
                  children: [
                    Text("Digite a ID: "),
                    TextField(
                        controller: controleID,
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
                    Text("Digite o Ano: "),
                    TextField(
                        controller: controleAno,
                        obscureText: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        )),
                  ],
                ),
              ),
              RaisedButton(
                  onPressed: () async {
                    if(indexselect != 0) {
                      String turno;
                      switch (indexselect) {
                        case 1:
                          turno = "Manha";
                          break;
                        case 2:
                          turno = "Tarde";
                          break;
                        case 3:
                          turno = "Noite";
                          break;
                      }
                      http.Response info = await BancoAPI.CreateTurma(
                      controleID.text,
                      turno, controleAno.text);
                      //verifica se há error
                      if (info.body.contains("errno")) {
                        Map<String, dynamic> body = json.decode(info.body);
                        if (body["errno"].toString() == "1062") {
                          Alertas.showAlertDialog(context,
                              "Turma ja existente code: ${body["errno"]}");
                        } else {
                          Alertas.showAlertDialog(
                              context, "code: ${body["errno"]}");
                        }
                      }else{
                        Navigator.pop(context);
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
                    child: const Text('Criar', style: TextStyle(fontSize: 20)),
                  )),
            ]),
          ),
        ));
  }
}
