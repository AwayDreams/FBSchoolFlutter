import 'package:fbsproject/Home.dart';
import 'package:fbsproject/showUser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fbsproject/BancoAPI.dart';
import 'package:fbsproject/Alertas.dart';
import 'package:fbsproject/User.dart';
import 'package:fbsproject/selecaoAeP.dart';
import 'dart:convert';

class EditUser extends StatefulWidget {
  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  TextEditingController controleNome = new TextEditingController();
  TextEditingController controleUsuario = new TextEditingController();
  TextEditingController controleSenha = new TextEditingController();

  List lista;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: FutureBuilder(
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
                    _getList(snapshot);
                    controleNome.text = lista[0]["nome"];
                    controleUsuario.text = lista[0]["usuario"];
                    controleSenha.text = lista[0]["senha"];
                    return Column(
                      children: [
                        Icon(Icons.account_circle, size: 140),
                        Padding(
                            padding: EdgeInsets.fromLTRB(10,0,10,0),
                            child: Row(
                              children: [
                                Text("Nome:", style: TextStyle(fontSize: 25)),
                                Expanded(
                                    child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: TextField(
                                            controller: controleNome,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                            ))))
                              ],
                            )),

                        /*Padding(
                            padding: EdgeInsets.fromLTRB(10,0,10,0),
                            child: Row(
                              children: [
                                Text("Usuario:", style: TextStyle(fontSize: 20)),
                                Expanded(
                                    child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: TextField(
                                            controller: controleUsuario,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                            ))))
                              ],
                            )), */

                        Padding(
                            padding: EdgeInsets.fromLTRB(10,0,10,0),
                            child: Row(
                              children: [
                                Text("Senha:", style: TextStyle(fontSize: 24)),
                                Expanded(
                                  child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: TextField(
                                              controller: controleSenha,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                              ))
                                  ),
                                )
                              ],
                            )),

                        RaisedButton(
                            onPressed: () async {

                                  http.Response info = await BancoAPI.UpdateUser(User.user, controleNome.text, controleSenha.text);
                                  if (info.body.contains("errno")) {
                                    Map<String, dynamic> body = json.decode(info.body);
                                    Alertas.showAlertDialog(context, "code: ${body["errno"]}");
                                    }
                                  else{
                                    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => showUser()));
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
                              child: const Text('Concluir', style: TextStyle(fontSize: 20)),
                            )),


                      ],
                    );
                }
              }),
        ));
  }

  List _getList(AsyncSnapshot snapshot) {
    http.Response info = snapshot.data;
    this.lista = json.decode(info.body);
    print(lista);
    return lista;
  }


}
