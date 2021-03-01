import 'package:flutter/material.dart';

class Creditos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("\"Se estiverem esperando que eu desista,\n é bom esperarem sentados.\" -Poppy" ,style: TextStyle(fontStyle: FontStyle.italic, ))
      )
    );
  }
}
