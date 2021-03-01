const express = require('express');
const app = express();         
const bodyParser = require('body-parser');
const port = 3000; //porta padrão
const mysql = require('mysql');


//configurando o body parser para pegar POSTS mais tarde
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

//definindo as rotas
const router = express.Router();
router.get('/', (req, res) => res.json({ message: 'Funcionando!' }));
app.use('/', router);

//inicia o servidor
app.listen(port);
console.log('API funcionando!');


function execSQLQuery(sqlQry, res){
    const connection = mysql.createConnection({
        host     : 'localhost',
        port     : 3306,
        user     : 'root',
        password : '37501',
        database : 'projeto'
    });
   
    connection.query(sqlQry, function(error, results, fields){
        if(error) {
          console.log(error);
          res.json(error);
        }
        else{
          console.log(results);
          res.json(results);
        }  
        connection.end();
        console.log('------FIM DO PROCESSO-------!');
    });
  }


  function ExecLogin(usuario, senha, res){
    const connection = mysql.createConnection({
        host     : 'localhost',
        port     : 3306,
        user     : 'root',
        password : '37501',
        database : 'projeto'
    });

    var  sqlQry = `SELECT usuario.usuario, usuario.senha, usuario.nome, aluno.turma FROM usuario LEFT JOIN professor ON professor.usuario = usuario.usuario LEFT JOIN aluno ON aluno.usuario = usuario.usuario where usuario.usuario = "${usuario}"; `;
   
    connection.query(sqlQry, function(error, results, fields){
        if(error) {
          console.log("ERRO DURANTE LOGIN");
          res.json("3"); //a busca falhou
        }
        else{
          if(results[0] != null){
            if(results[0]['usuario'] ==  usuario && results[0]['senha'] == senha){
              if(results[0]['turma'] != null){
                console.log("ACESSO LIBERADO - ALUNO");
                res.json("1"); //ACEITO, É UM ALUNO
              }
              else{
                console.log("ACESSO LIBERADO - PROFESSOR");
                res.json("2"); //ACEITO, É UM PROFESSOR
              }
            }
            else{
              console.log(results);
              console.log(results[0]['usuario']);
              console.log(usuario);
              console.log(results[0]['senha']);
              console.log(senha);
              res.json("0");  //NEGADO
            }
        }else{
          console.log("ACESSO NEGADO");
          res.json("0");
        }
          
        }
        connection.end();
    });
  }

//req informação que chega ao servidor  --input
//res informação que sai do servidor    --output


router.post('/login', (req, res) =>{
  const usuario = req.body.usuario;
  const senha = req.body.senha;
  ExecLogin(usuario, senha, res);
})

router.post('/usuario', (req, res) =>{
    const nome = req.body.nome.substring(0,30);
    const usuario = req.body.usuario.substring(0,30);
    const senha = req.body.senha.substring(0,30);
    execSQLQuery(`INSERT INTO usuario(nome, usuario, senha) VALUES('${nome}','${usuario}','${senha}')`, res);
})

router.post('/aluno', (req, res) =>{
    const usuario = req.body.usuario.substring(0,30);
    const ra = req.body.ra.substring(0,10);
    execSQLQuery(`INSERT INTO aluno(usuario, ra) VALUES('${usuario}','${ra}')`, res);
})

router.post('/professor', (req, res) =>{
  const usuario = req.body.usuario.substring(0,30);
  const cargahoraria = req.body.cargahoraria.substring(0,10);
  const sobre = req.body.sobre;
  execSQLQuery(`INSERT INTO professor(usuario, cargahoraria, sobre) VALUES('${usuario}','${cargahoraria}', '${sobre}')`, res);
})

router.post('/disciplina', (req, res) =>{
  const nome = req.body.nome.substring(0,30);
  const cargahoraria = req.body.cargahoraria.substring(0,10);
  execSQLQuery(`INSERT INTO disciplina (nome, cargahoraria) VALUES('${nome}','${cargahoraria}')`, res);
})


router.post('/turma', (req, res) =>{
  const id = req.body.id.substring(0,30);
  const turno = req.body.turno.substring(0,30);
  const ano = req.body.ano.substring(0,10);
  execSQLQuery(`INSERT INTO turma (id, turno, ano) VALUES('${id}','${turno}','${ano}')`, res);
})



router.post('/relatorio', (req, res) =>{
  const qualidade = req.body.qualidade;
  const descricao = req.body.descricao;
  const aula = req.body.aula;
  const usuario = req.body.usuario;
  execSQLQuery(`INSERT INTO relatorio(qualidade, descricao, aula, usuario) VALUES('${qualidade}','${descricao}','${aula}','${usuario}')`, res);
})

router.post('/aula', (req, res) =>{
  const turma = req.body.turma;
  const disciplina = req.body.disciplina;
  const professor = req.body.professor;
  execSQLQuery(`INSERT INTO aula (turma, disciplina, professor) VALUES('${turma}','${disciplina}', '${professor}')`, res);
})


router.post('/comentario', (req, res) =>{
  const creator = req.body.creator;
  const conteudo = req.body.conteudo;
  const relatorio = req.body.relatorio;
  execSQLQuery(`INSERT INTO comentario(creator, conteudo, relatorio) VALUES('${creator}','${conteudo}','${relatorio}')`, res);
})



router.post('/testereq', (req, res) =>{
  const nome = req.body.nome.substring(0,30);
  console.log(nome);
})



router.get('/turma/:id?', (req, res) =>  {
  let filter = '';
  if(req.params.id) filter = ` WHERE id= '${req.params.id}'`;
  execSQLQuery('SELECT * FROM turma' + filter, res);
})

//Usado no CreateComentario
router.get('/comentario/:id?', (req, res) =>  {
  let filter = '';
  if(req.params.id) filter = ` WHERE relatorio= '${req.params.id}'`;
  execSQLQuery('SELECT * FROM comentario' + filter, res);
})

//usado no showUser
router.get('/usuariojoinprofessor/:usuario?', (req, res) =>  {
  let filter = '';
  if(req.params.usuario) filter = ` WHERE usuario.usuario= '${req.params.usuario}'`;
  execSQLQuery('SELECT * FROM usuario INNER JOIN professor ON professor.usuario = usuario.usuario' + filter, res);
})

//usado no showUser
router.get('/usuariojoinaluno/:usuario?', (req, res) =>  {
  let filter = '';
  if(req.params.usuario) filter = ` WHERE usuario.usuario= '${req.params.usuario}'`;
  execSQLQuery('SELECT * FROM usuario INNER JOIN aluno ON aluno.usuario = usuario.usuario' + filter, res);
})

router.get('/professor/:usuario?', (req, res) =>  {
  let filter = '';
  if(req.params.usuario) filter = ` WHERE usuario= '${req.params.usuario}'`;
  execSQLQuery('SELECT * FROM usuario INNER JOIN professor ON professor.usuario = usuario.usuario' + filter, res);
})


router.get('/professorjoinuser/:usuario?', (req, res) =>  {
  let filter = '';
  if(req.params.usuario) filter = ` WHERE professor.usuario= '${req.params.usuario}'`;
  execSQLQuery('SELECT * FROM professor INNER JOIN usuario ON professor.usuario = usuario.usuario' + filter, res );
})


router.get('/aula/:usuario?', (req, res) =>  {
  let filter = '';
  if(req.params.usuario) filter = ` WHERE aula.professor= '${req.params.usuario}'`;
  execSQLQuery('SELECT * FROM aula INNER JOIN usuario ON aula.professor = usuario.usuario' + filter, res );
})




router.get('/disciplina/:nome?', (req, res) =>  {
  let filter = '';
  if(req.params.nome) filter = ` WHERE nome= '${req.params.nome}'`;
  execSQLQuery('SELECT * FROM disciplina' + filter, res);
})

//precisa ser revisto - revistado
router.get('/alunojoinaulajoinusuariowherealuno/:usuario?', (req, res) =>  {
  let filter = '';
  if(req.params.usuario) filter = ` WHERE aluno.usuario= '${req.params.usuario}'`;
  execSQLQuery('SELECT * FROM aluno INNER JOIN aula ON aluno.turma = aula.turma INNER JOIN usuario ON aula.professor = usuario.usuario' + filter, res);
})

router.get('/aulajoinprofessorwhereprofessor/:usuario?', (req, res) =>  {
  let filter = '';
  if(req.params.usuario) filter = ` WHERE professor.usuario= '${req.params.usuario}'`;
  execSQLQuery('SELECT * FROM aula INNER JOIN professor ON aula.professor = professor.usuario' + filter, res);
})

//Rota utilizada na Home
router.get('/selectrelatoriofilterturma/:usuario?', (req, res) =>  {
  let filter = '';

  if(req.params.usuario) filter = ` WHERE aluno.usuario= '${req.params.usuario}'`;
  execSQLQuery('SELECT relatorio.id, relatorio.qualidade, relatorio.descricao, relatorio.aula, usuario.usuario, usuario.nome, aula.turma, aula.disciplina, aula.professor  FROM relatorio INNER JOIN usuario ON relatorio.usuario = usuario.usuario INNER JOIN aula ON relatorio.aula = aula.id INNER JOIN aluno ON aluno.turma = aula.turma' + filter, res);
})

//Rota utilizada na Home
router.get('/selectrelatoriofilterprof/:usuario?', (req, res) =>  {
  let filter = '';
  if(req.params.usuario) filter = ` WHERE aula.professor = '${req.params.usuario}'`;
  execSQLQuery('SELECT relatorio.id, relatorio.qualidade, relatorio.descricao, relatorio.usuario, usuario.nome, aula.disciplina, aula.professor FROM relatorio INNER JOIN usuario ON relatorio.usuario = usuario.usuario INNER JOIN aula ON relatorio.aula = aula.id' + filter, res);
})



router.get('/turmajoinaula/:turma?', (req, res) =>  {
  let filter = '';
  if(req.params.turma) filter = ` WHERE turma.id= '${req.params.turma}'`;
  execSQLQuery('SELECT * FROM turma INNER JOIN aula ON turma.id = aula.turma ' + filter, res);
})


router.get('/deleterelatorio/:id?', (req, res) =>  {
  let filter = '';
  if(req.params.id) filter =  ` WHERE id = ${req.params.id}`;
  execSQLQuery('DELETE FROM relatorio' + filter, res);
})




router.post('/updateuser', (req, res) =>{
  const nome = req.body.nome.substring(0,30);
  const senha = req.body.senha.substring(0,30);
  const usuario = req.body.usuario.substring(0,30);
  execSQLQuery(`UPDATE usuario SET nome='${nome}', senha='${senha}' WHERE usuario = '${usuario}'`, res);
})


router.post('/updatealuno', (req, res) =>{
  const usuario = req.body.usuario.substring(0,30);
  const turma = req.body.turma.substring(0,30);
  execSQLQuery(`UPDATE aluno SET turma='${turma}' WHERE usuario = '${usuario}'`, res);
})




