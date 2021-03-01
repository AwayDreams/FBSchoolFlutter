import 'package:fbsproject/CreateAula.dart';
import 'package:fbsproject/CreateRelatorio.dart';
import 'package:fbsproject/CreateTurma.dart';
import 'package:fbsproject/SelecaoTurma.dart';
import 'package:fbsproject/User.dart';
import 'package:fbsproject/selecaoAeP.dart';
import 'package:flutter/material.dart';
import 'package:fbsproject/Login.dart';
import 'package:fbsproject/CreateConta.dart';
import 'package:fbsproject/selecaoAeP.dart';
import 'package:fbsproject/CreateDisciplina.dart';
import 'package:fbsproject/Home.dart';
import 'package:fbsproject/Creditos.dart';
import 'package:fbsproject/showAulas.dart';
import 'package:fbsproject/showUser.dart';
import 'package:fbsproject/teste.dart';
import 'package:fbsproject/CreateComentario.dart';
import 'package:fbsproject/EditUser.dart';
import 'package:flutter/services.dart';
void main() {

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.portraitDown
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Login()
    );
  }
}

