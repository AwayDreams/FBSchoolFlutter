import 'dart:convert';

import 'package:fbsproject/Alertas.dart';
import 'package:fbsproject/BancoAPI.dart';
import 'package:fbsproject/CreateTurma.dart';
import 'package:fbsproject/Home.dart';
import 'package:fbsproject/User.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fbsproject/CreateAula.dart';

class SelecaoTurma extends StatefulWidget {
  @override
  _SelecaoTurmaState createState() => _SelecaoTurmaState();
}

class _SelecaoTurmaState extends State<SelecaoTurma> {
  List lista;
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
        body: Padding(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
                child: Column(
              children: [
                Text("Selecione uma Turma:", style: TextStyle(fontSize: 24)),
                Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.5,
                      )
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20,10,20,10),
                      child: 
                      FutureBuilder(
                        future: BancoAPI.SelectTurma(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return Container(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.blue),
                              strokeWidth: 5.0,
                            ),
                          );
                        default:
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: _getListandLength(snapshot),
                            itemBuilder: (contexto, index) {
                              return Card(
                                  elevation: 5,
                                  child: ListTile(
                                    leading: Icon(Icons.school),
                                    title: Text('${lista[index]["id"]}'),
                                    subtitle: Text(
                                        'Turno: ${lista[index]["turno"]} Ano: ${lista[index]["ano"]}'),
                                    onTap: () {
                                      User.alunoprofessor == 1 ? processaAluno(lista[index]["id"]) : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateAula(this.lista, index)));
                                    },
                                  ));
                            },
                          );
                      }
                    }),
                    )),
                if(User.alunoprofessor == 2)
                   RaisedButton(
                      onPressed: () async {
                        await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTurma()));
                        setState(() {

                        });
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
                        child: const Text('nova turma', style: TextStyle(fontSize: 20)),
                      )),
              ],
            ))));
  }

  int _getListandLength(AsyncSnapshot snapshot) {
    http.Response info = snapshot.data;
    this.lista = json.decode(info.body);
    return lista.length;
  }

  void processaAluno(String turma) async {
    http.Response info = await BancoAPI.UpdateAluno(User.user, turma);
    print(User.user);
    print(turma);
    //verifica se há error
    if (info.body.contains("errno")) {
      Map<String, dynamic> body = json.decode(info.body);
      Alertas.showAlertDialog(
            context, "code: ${body["errno"]}");
      }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
    } 
  }


}
