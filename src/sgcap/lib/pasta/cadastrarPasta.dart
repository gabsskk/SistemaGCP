import 'package:mysql_client/mysql_client.dart';
import 'package:sgcap/database.dart';
import 'package:sgcap/funcoes.dart';
import 'package:sgcap/empresa/empresa.dart';
import 'package:sgcap/status/status.dart';
import 'package:sgcap/categoria/categoria.dart';
import 'pasta.dart';


class CadastrarPasta extends Funcoes {

  //---INSERIR PASTA---
  Future<void>SalvarPasta(String nome, String categoria) async{
    MySQLConnection? conn;
    try{
      conn = await Database.abrirConexao();

      var sqlEmpresa = 'SELECT * FROM empresa WHERE nome = :nome';
      var result = await conn.execute(sqlEmpresa,
      {"nome": nome,});

      if(result.rows.isEmpty){
        print('Empresa não encontrada !');
        return;
      }
        print('Empresa encontrada com sucesso');

        var empresaLinha = result.rows.first;
        var idEmpresa = empresaLinha.assoc()['idEmpresa'];
        var cnpjEmpresa = empresaLinha.assoc()['cnpj'];
        print("==============================");
        print("ID: $idEmpresa Nome: $nome CNPJ: $cnpjEmpresa");
        print("==============================");
      

      var sqlCategoria = 'SELECT * FROM categoria WHERE nome = :nome';
      var resultCategoria = await conn.execute(sqlCategoria,
      {"nome": categoria,});
      if(resultCategoria.rows.isEmpty){
        print('Categoria não encontrada !');
        return;
      }
        print('Categoria encontrada com sucesso');

        var categoriaLinha = resultCategoria.rows.first;
        var idCategoria = categoriaLinha.assoc()['idCategoria'];
        print("==============================");
        print("ID: $idCategoria Categoria: $categoria");
        print("==============================");

      var sqlInsert = 'INSERT INTO pasta (Empresa_idEmpresa, Categoria_idCategoria) VALUES (:idEmpresa,:idCategoria)';
        await conn.execute(
        sqlInsert,
        {"idEmpresa": idEmpresa, "idCategoria": idCategoria});

        print("Pasta criada com Sucesso !");
      
      
    } catch (e) {
      print("Erro: $e");
    } finally {
      if (conn != null && conn.connected) {
        await conn.close();
      }
    }
  }
  //---DELETAR PASTA---

  Future<void> DeletarPasta(int idPasta) async {
    
    var sql = 'DELETE FROM pasta WHERE idPasta = :idPasta';

    await executarComando(
      sql, 
      {"idPasta" :idPasta}, 
      'Empresa deletada com sucesso !');
  }
  //---BUSCAR PASTA---
  Future<List<Pasta>> buscarPasta({String? nomeEmpresa}) async {
  List<Pasta> lista = [];
  MySQLConnection? conn;

  try {
    conn = await Database.abrirConexao();

    // só filtra se o usuário digitou alguma coisa
    bool filtrar = nomeEmpresa != null && nomeEmpresa.trim().isNotEmpty;

    var result = await conn.execute('''
      SELECT 
        p.idPasta,
        e.nome AS empresaNome, 
        e.cnpj AS empresaCnpj, 
        c.nome AS categoriaNome, 
        s.nome AS statusNome, 
        DATE_FORMAT(p.dataAbertura, '%Y-%m-%d %H:%i:%s') AS dataAbertura, 
        DATE_FORMAT(p.dataArquivoMorto, '%Y-%m-%d %H:%i:%s') AS dataArquivoMorto, 
        DATE_FORMAT(p.dataValidade, '%Y-%m-%d %H:%i:%s') AS dataValidade,
        DATE_FORMAT(p.dataEntrega, '%Y-%m-%d %H:%i:%s') AS dataEntrega
      FROM pasta p
      INNER JOIN empresa e ON p.Empresa_idEmpresa = e.idEmpresa
      INNER JOIN categoria c ON p.Categoria_idCategoria = c.idCategoria
      INNER JOIN status s ON p.Status_idStatus = s.idStatus
      ${filtrar ? 'WHERE LOWER(e.nome) LIKE LOWER(:busca)' : ''}
      ORDER BY e.nome
    ''', filtrar ? {'busca': '${nomeEmpresa!.trim()}%'} : null);

    DateTime? converterData(String? dataStr) {
      if (dataStr == null || dataStr == 'null' || dataStr.isEmpty) return null;
      return DateTime.tryParse(dataStr);
    }

    for (var linha in result.rows) {
      Empresa empresa = Empresa(
        nome: linha.colByName("empresaNome").toString(),
        cnpj: linha.colByName("empresaCnpj").toString(),
      );

      Categoria categoria = Categoria(
        nomeCategoria: linha.colByName("categoriaNome").toString(),
      );

      Status status = Status(
        nome: linha.colByName("statusNome").toString(),
      );

      lista.add(Pasta(
        id: int.tryParse(linha.colByName("idPasta").toString()),
        empresa: empresa,
        categoria: categoria,
        status: status,
        dataAbertura: converterData(linha.colByName("dataAbertura").toString()),
        dataAquivoMorto: converterData(linha.colByName("dataArquivoMorto").toString()),
        dataValidade: converterData(linha.colByName("dataValidade").toString()),
        dataEntrega: converterData(linha.colByName("dataEntrega").toString()),
      ));
    }
  } catch (e) {
    print("Erro ao buscar as empresas: $e");
  } finally {
    if (conn != null && conn.connected) {
      await conn.close();
    }
  }
  
  return lista;
}
}