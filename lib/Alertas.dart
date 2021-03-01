import 'package:fbsproject/BancoAPI.dart';
import 'package:fbsproject/Home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Alertas{


  static showAlertDialog(BuildContext context, String message) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () { Navigator.pop(context); },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Oh não! Algo saiu errado"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  static showAulaAlert(BuildContext context, String message) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AULA CRIADA!"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }



  static showRelatorioAlert(BuildContext context, String id) {

    // set up the button
    Widget simButton = FlatButton(
      child: Text("sim"),
      onPressed: () async {

        http.Response info = await BancoAPI.DeleteRelatorio(id);
        //verifica se há error
        if (info.body.contains("errno")) {
          Map<String, dynamic> body = json.decode(info.body);
            Alertas.showAlertDialog(
                context, "code: ${body["errno"]}");
        }else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
        }
        },
    );

    Widget naoButton = FlatButton(
      child: Text("não"),
      onPressed: () { Navigator.pop(context);},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("ALERTA!"),
      content: Text("Tem certeza que deseja apagar esta mensagem?"),
      actions: [
        simButton,
        naoButton
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}