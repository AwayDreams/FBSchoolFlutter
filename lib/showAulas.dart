import 'package:fbsproject/Home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:fbsproject/BancoAPI.dart';
import 'package:fbsproject/Alertas.dart';
import 'package:fbsproject/User.dart';
import 'package:fbsproject/selecaoAeP.dart';
import 'dart:convert';


class showAulas extends StatefulWidget {
  @override
  _showAulasState createState() => _showAulasState();
}

class _showAulasState extends State<showAulas> {
  List lista;
  bool indexselect = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

        ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
              Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Apenas suas aulas"),
                  Switch(
                  value: indexselect,
                  onChanged: (value) {
                    setState(() {
                      indexselect = value;
                    });
                  },
                ),
                ]),
                Container(
                  child: FutureBuilder(
                      future: indexselect == true ? BancoAPI.SelectAulaWhereProf(User.user) : BancoAPI.SelectAulaWhereProf(null),
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
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _getListandLength(snapshot),
                              itemBuilder: (contexto, index) {
                                return Card(
                                    elevation: 5,
                                    child: ListTile(
                                      leading: Icon(Icons.school),
                                      title: Text('${lista[index]["turma"]}'),
                                      subtitle: Text(
                                          'Disciplina: ${lista[index]["disciplina"]} Professor: ${lista[index]["nome"]}'),
                                      onTap: () {

                                      },
                                    ));
                              },
                            );
                        }
                      }),
                )
              ],
            ),
          )
    );
  }


  int _getListandLength(AsyncSnapshot snapshot) {
    http.Response info = snapshot.data;
    this.lista = json.decode(info.body);
    return lista.length;
  }


}
