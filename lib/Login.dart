import 'package:fbsproject/BancoAPI.dart';
import 'package:fbsproject/Alertas.dart';
import 'package:fbsproject/CreateConta.dart';
import 'package:fbsproject/Home.dart';
import 'package:fbsproject/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController controleLogin = new TextEditingController();
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
                  Text("Debug IP: ${BancoAPI.endereco}"),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: TextField(
                        controller: controleLogin,
                        obscureText: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Usuario',
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: TextField(
                        controller: controleSenha,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Senha',
                        )),
                  ),
                  RaisedButton(
                      onPressed: () async {
                            http.Response info = await BancoAPI.Login(controleLogin.text, controleSenha.text);
                            print(info.body);
                            if(info.body == "\"0\"") {
                              Alertas.showAlertDialog(
                                  context, "usuario e senha não encontrados!");
                            }else if(info.body == "\"3\""){
                              Alertas.showAlertDialog(
                                  context, "Algo saiu deu errado!");
                            }else if(info.body == "\"1\""){
                              User.user = controleLogin.text;
                              User.alunoprofessor = 1;
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
                            }
                            else if(info.body == "\"2\""){
                              User.user = controleLogin.text;
                              User.alunoprofessor = 2;
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
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
                            const Text('Login', style: TextStyle(fontSize: 20)),
                      )),
                  FlatButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CreateConta()));
                    },
                    color: Colors.transparent,
                    splashColor: Colors.black26,
                    padding: const EdgeInsets.all(0.0),
                    child: const Text('Criar uma Conta',
                        style: TextStyle(fontSize: 20, color: Colors.blue)),
                  )
                ]))));
  }
}
