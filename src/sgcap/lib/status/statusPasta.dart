import 'package:sgcap/funcoes.dart';

class StatusPasta extends Funcoes{
  Future<void>ArquivoMorto(int idPasta) async{

    DateTime agora = DateTime.now();
    String dataFormatada = "${agora.year}-${agora.month.toString().padLeft(2, '0')}-${agora.day.toString().padLeft(2, '0')}";

    var sql = 'UPDATE pasta SET Status_idStatus = 2, dataArquivoMorto = CURRENT_TIMESTAMP, dataValidade = CURRENT_DATE + INTERVAL 1 YEAR WHERE idPasta = :idPasta';

    await executarComando(
      sql, 
      {"idPasta": idPasta,
       "dataAtual": dataFormatada}, 
      'Status alterado como sucesso');
  }
  Future<void>EntregarPasta(int idPasta) async{
    DateTime agora = DateTime.now();
    String dataFormatada = "${agora.year}-${agora.month.toString().padLeft(2, '0')}-${agora.day.toString().padLeft(2, '0')}";

    var sql = 'UPDATE pasta SET Status_idStatus = 4, dataEntrega = CURRENT_TIMESTAMP WHERE idPasta = :idPasta';

    await executarComando(
      sql,
      {"idPasta": idPasta,
      "dataAtual": dataFormatada}, 
      'Status alterado como sucesso');
  }

}