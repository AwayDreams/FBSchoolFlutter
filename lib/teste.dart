import 'package:fbsproject/Home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fbsproject/BancoAPI.dart';
import 'package:fbsproject/Alertas.dart';
import 'package:fbsproject/User.dart';
import 'package:fbsproject/selecaoAeP.dart';
import 'dart:convert';


class teste extends StatefulWidget {
  @override
  _testeState createState() => _testeState();
}

class _testeState extends State<teste> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Text("teste")
          ],
        ),
      )
    );
  }
}
