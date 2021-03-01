import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fbsproject/BancoAPI.dart';
import 'package:fbsproject/Alertas.dart';
import 'package:fbsproject/User.dart';
import 'package:fbsproject/selecaoAeP.dart';
import 'dart:convert';

class CreateConta extends StatefulWidget {
  @override
  _CreateContaState createState() => _CreateContaState();
}

class _CreateContaState extends State<CreateConta> {

  TextEditingController controleNome = new TextEditingController();
  TextEditingController controleUsuario = new TextEditingController();
  TextEditingController controleSenha = new TextEditingController();


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
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Digite seu nome (visivel para todos):",
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: TextField(
                              controller: controleNome,
                              obscureText: false,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              )),
                        )
                      ],
                    )
                  ),
                  Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Digite seu usuario: ",
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: TextField(
                                controller: controleUsuario,
                                obscureText: false,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                )),
                          )
                        ],
                      )
                  ),
                  Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Digite sua senha:",
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: TextField(
                                controller: controleSenha,
                                obscureText: false,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                )),
                          )
                        ],
                      )
                  ),

                  RaisedButton(
                      onPressed: () async {
                        http.Response info = await BancoAPI.CreateUsuario(controleNome.text, controleUsuario.text, controleSenha.text);
                        //verifica se há error
                        if(info.body.contains("errno")) {
                          Map<String, dynamic> body = json.decode(info.body);
                          if (body["errno"].toString() == "1062") {
                            Alertas.showAlertDialog(context,
                                "Usuario ja existente code: ${body["errno"]}");
                          }
                          else{
                            Alertas.showAlertDialog(context, "code: ${body["errno"]}");
                          }

                        }
                        else{
                          User.user =  controleUsuario.text;
                          User.nome = controleNome.text;
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => selecaoAeP()));
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
                        const Text('Continuar', style: TextStyle(fontSize: 20)),
                      )),
                ]))));
  }

}

