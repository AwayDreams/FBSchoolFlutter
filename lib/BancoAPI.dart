import 'dart:convert';
import 'package:fbsproject/CreateComentario.dart';
import 'package:http/http.dart' as http;

class BancoAPI{

  static String endereco = "http://127.0.0.1:3000/";
  //static String endereco = "http://192.168.100.2:3000/";

  //CreateUsuario(POST)
  static Future<http.Response> CreateUsuario(String nome, String usuario, String senha) {
    return http.post(
      "${endereco}usuario/",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nome': nome,
        'usuario': usuario,
        'senha': senha
      }),
    );
  }
  //SelecaoAeP-Aluno(POST)
  static Future<http.Response> CreateAluno(String usuario, String ra) {
    return http.post(
      "${endereco}aluno/",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'usuario': usuario,
        'ra': ra
      }),
    );
  }
  //SelecaoAeP-Professor(POST)
  static Future<http.Response> CreateProf(String usuario, String cargahoraria, String sobre) {
    return http.post(
      "${endereco}professor/",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'usuario': usuario,
        'cargahoraria': cargahoraria,
        'sobre': sobre
      }),
    );
  }
  //CreateTurma(POST)
  static Future<http.Response> CreateTurma(String id, String turno, String ano) {
    return http.post(
      "${endereco}turma/",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id': id,
        'turno': turno,
        'ano': ano
      }),
    );
  }

  static Future<http.Response> CreateDisciplina(String nome, String cargahoraria) {
    return http.post(
      "${endereco}disciplina/",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nome': nome,
        'cargahoraria': cargahoraria,
      }),
    );
  }
  //Relatorio(POST)
  static Future<http.Response> CreateRelatorio(String qualidade, String descricao, String aula, String usuario) {
    return http.post(
      "${endereco}relatorio/",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'qualidade': qualidade,
        'descricao': descricao,
        'aula': aula,
        'usuario': usuario,
      }),
    );
  }
  //CreateAula(POST)
  static Future<http.Response> CreateAula(String turma, String disciplina, String professor) {
    return http.post(
      "${endereco}aula/",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'turma': turma,
        'disciplina': disciplina,
        'professor': professor,
      }),
    );
  }

  //CreateComentario
  static Future<http.Response> CreateComentario(String usuario, String conteudo, String relatorio) {
    return http.post(
      "${endereco}comentario/",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'creator': usuario,
        'conteudo': conteudo,
        'relatorio': relatorio,
      }),
    );
  }

  static Future<http.Response> SelectTurma([String id]) {
    if(id == null){
      return http.get(
        "${endereco}turma/",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    }
    else{
      return http.get(
        "${endereco}turma/${id}",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    }
  }

  //EditUserAluno(search one) / showUserAluno(search one)
  static Future<http.Response> SelectUsuarioJoinAluno([String usuario]) {
    if(usuario == null){
      return http.get(
        "${endereco}usuariojoinaluno/",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    }
    else{
      return http.get(
        "${endereco}usuariojoinaluno/${usuario}",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    }
  }

  //Login
  static Future<http.Response> Login(String usuario, String senha) {
      return http.post(
        "${endereco}login/",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'usuario': usuario,
          'senha': senha,
        }),
      );
  }

  //EditUserProfessor(search one) / showUserProfessor(search one)
  static Future<http.Response> SelectUsuarioJoinProf([String usuario]) {
    if(usuario == null){
      return http.get(
        "${endereco}usuariojoinprofessor/",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    }
    else{
      return http.get(
        "${endereco}usuariojoinprofessor/${usuario}",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    }
  }

  static Future<http.Response> SelectProf([String usuario]) {
    if(usuario == null){
      return http.get(
        "${endereco}professor/",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    }
    else{
      return http.get(
        "${endereco}professor/${usuario}",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    }
  }

  //CreateAula(search one)
  static Future<http.Response> SelectProfJoinUser([String usuario]) {
    if(usuario == null){
      return http.get(
        "${endereco}professorjoinuser/",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    }
    else{
      return http.get(
        "${endereco}professorjoinuser/${usuario}",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    }
  }

  //showAulas(search one / all)
  static Future<http.Response> SelectAulaWhereProf([String usuario]) {
    if(usuario == null){
      return http.get(
        "${endereco}aula/",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    }
    else{
      return http.get(
        "${endereco}aula/${usuario}",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    }
  }

  //RelatorioAluno(search one)
  static Future<http.Response> SelectAlunoJoinAulaJoinUsuarioWhereAluno([String usuario]) {
    if(usuario == null){
      return http.get(
        "${endereco}alunojoinaulajoinusuariowherealuno/",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    }
    else{
      return http.get(
        "${endereco}alunojoinaulajoinusuariowherealuno/${usuario}",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    }
  }

  //RelatorioProfessor(search one)
  static Future<http.Response> SelectAulaJoinProfessorWhereProfessor([String usuario]) {
    if(usuario == null){
      return http.get(
        "${endereco}aulajoinprofessorwhereprofessor/",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    }
    else{
      return http.get(
        "${endereco}aulajoinprofessorwhereprofessor/${usuario}",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    }
  }

  //HomeAluno(search one)
  static Future<http.Response> SelectRelatorioFilterTurma([String usuario]) {
    if(usuario == null){
      return http.get(
        "${endereco}selectrelatoriofilterturma/",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    }
    else{
      return http.get(
        "${endereco}selectrelatoriofilterturma/${usuario}",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    }
  }

  //HomeProfessor(search one)
  static Future<http.Response> SelectRelatorioFilterProf([String usuario]) {
    if(usuario == null){
      return http.get(
        "${endereco}selectrelatoriofilterprof/",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    }
    else{
      return http.get(
        "${endereco}selectrelatoriofilterprof/${usuario}",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    }
  }


  //CreateComentario(search one)
  static Future<http.Response> SelectComentario([String relatorio]) {
    if(relatorio == null){
      return http.get(
        "${endereco}comentario/",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    }
    else{
      return http.get(
        "${endereco}comentario/${relatorio}",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    }
  }


  //CreateAula(search all)
  static Future<http.Response> SelectDisciplina([String nome]) {
    if(nome == null){
      return http.get(
        "${endereco}disciplina/",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    }
    else{
      return http.get(
        "${endereco}disciplina/${nome}",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    }
  }


  static Future<http.Response> SelectAulaWhereTurma([String turma]) {
    if(turma == null){
      return http.get(
        "${endereco}aulawhereturma/",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    }
    else{
      return http.get(
        "${endereco}aulawhereturma/${turma}",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    }
  }

  //EditUser(UPDATE)
  static Future<http.Response> UpdateUser(String usuario, String nome, String senha) {
    return http.post(
      "${endereco}updateuser/",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'usuario': usuario,
        'nome': nome,
        'senha': senha,
      }),
    );
  }

  //SelecaoTurmaAluno(UPDATE)
  static Future<http.Response> UpdateAluno(String usuario, String turma) {
    return http.post(
      "${endereco}updatealuno/",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'usuario': usuario,
        'turma': turma,
      }),
    );
  }

  static Future<http.Response> DeleteRelatorio([String id]) {
    if(id == null){
      return http.get(
        "${endereco}deleterelatorio/",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    }
    else{
      return http.get(
        "${endereco}deleterelatorio/${id}",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    }
  }

}