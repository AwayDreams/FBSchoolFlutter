import 'package:fbsproject/CreateComentario.dart';
import 'package:fbsproject/CreateRelatorio.dart';
import 'package:fbsproject/CreateTurma.dart';
import 'package:fbsproject/Login.dart';
import 'package:fbsproject/SelecaoTurma.dart';
import 'package:fbsproject/showAulas.dart';
import 'package:fbsproject/showUser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fbsproject/BancoAPI.dart';
import 'package:fbsproject/Alertas.dart';
import 'package:fbsproject/User.dart';
import 'package:fbsproject/selecaoAeP.dart';
import 'package:fbsproject/Creditos.dart';
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List lista;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: NavDrawer(),
      appBar: AppBar(

      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.create),
        onPressed: () async{
          await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateRelatorio()));
          setState(() {

          });
        },
      ),
      body: Column(
          children: [
            FutureBuilder(
                future: User.alunoprofessor == 1 ? BancoAPI.SelectRelatorioFilterTurma(User.user) : BancoAPI.SelectRelatorioFilterProf(User.user),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white),
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
                                title: Text('${lista[index]["nome"]}'),
                                subtitle: Text(
                                    '${lista[index]["descricao"]}'),
                                onTap: () async {
                                  await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateComentario(this.lista, index)));
                                },
                              ));
                        },
                      );
                  }
                }),
          ],
        ),
    );
  }

  int _getListandLength(AsyncSnapshot snapshot) {
    http.Response info = snapshot.data;
    this.lista = json.decode(info.body);
    return lista.length;
  }
}

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: User.alunoprofessor == 1 ?  drawnerAluno(context) : drawnerProf(context)
      ),
    );
  }

  List<Widget> drawnerProf(context){
    return  [
      DrawerHeader(
        child: Text(
          'FBSProject',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        decoration: BoxDecoration(
            color: Colors.green,
            ),
      ),
      ListTile(
        leading: Icon(Icons.account_circle),
        title: Text('Perfil'),
        onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => showUser()))},
      ),
      ListTile(
        leading: Icon(Icons.people),
        title: Text('Criar Turma'),
        onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTurma()))},
      ),
      ListTile(
        leading: Icon(Icons.accessibility),
        title: Text('ver Aulas'),
        onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => showAulas()))},
      ),
      ListTile(
        leading: Icon(Icons.school),
        title: Text('Criar Disciplina'),
        onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => SelecaoTurma()))},
      ),
      ListTile(
        leading: Icon(Icons.feedback),
        title: Text('Creditos'),
        onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => Creditos()))},
      ),
      ListTile(
        leading: Icon(Icons.exit_to_app),
        title: Text('Logout'),
        onTap: () => {
          User.user = null,
          User.alunoprofessor = null,
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()))},
      ),
    ];
  }

  List<Widget> drawnerAluno(context){
    return  [
      DrawerHeader(
        child: Text(
          'FBSProject',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        decoration: BoxDecoration(
            color: Colors.green,
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/cover.jpg'))),
      ),
      ListTile(
        leading: Icon(Icons.account_circle),
        title: Text('Perfil'),
        onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => showUser()))},
      ),
      ListTile(
        leading: Icon(Icons.border_color),
        title: Text('Creditos'),
        onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => Creditos()))},
      ),
      ListTile(
        leading: Icon(Icons.exit_to_app),
        title: Text('Sair'),
        onTap: () => {
          User.user = null,
          User.alunoprofessor = null,
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()))
        },
      )
    ];
  }

}
