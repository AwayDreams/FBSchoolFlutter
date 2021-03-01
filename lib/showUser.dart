import 'package:fbsproject/Home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fbsproject/BancoAPI.dart';
import 'package:fbsproject/Alertas.dart';
import 'package:fbsproject/User.dart';
import 'package:fbsproject/selecaoAeP.dart';
import 'dart:convert';

import 'EditUser.dart';

class showUser extends StatefulWidget {
  @override
  _showUserState createState() => _showUserState();
}

class _showUserState extends State<showUser> {
  List lista;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
          future: User.alunoprofessor == 1 ? BancoAPI.SelectUsuarioJoinAluno(User.user) : BancoAPI.SelectUsuarioJoinProf(User.user),
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
                    child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.account_circle, size: 140),
                            ContainerInfo("Usuario:", "${_getList(snapshot)[0]["usuario"]}"),
                            ContainerInfo("Nome:", "${_getList(snapshot)[0]["nome"]}"),
                            User.alunoprofessor == 1 ? ContainerInfo("Turma:", "${_getList(snapshot)[0]["turma"]}") : ContainerInfo("Sobre:", "${_getList(snapshot)[0]["sobre"]}"),
                            RaisedButton(
                                onPressed: () async {
                                  await Navigator.push(context, MaterialPageRoute(builder: (context) => EditUser()));
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
                                  padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: const Text('Editar',
                                      style: TextStyle(fontSize: 20)),
                                )),
                          ],
                        ))));
            }
          }),
    );
  }

  Widget ContainerInfo(String chave, String valor) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 2,
            )),
        child: Row(
          children: [
            Text("${chave} ", style: TextStyle(fontSize: 28)),
            Expanded(
              child:
              Text(valor, style: TextStyle(fontSize: 28)),
            )
          ],
        ),
      ),
    );
  }


  List _getList(AsyncSnapshot snapshot) {
    http.Response info = snapshot.data;
    this.lista = json.decode(info.body);
    print(lista);
    return lista;
  }


}
