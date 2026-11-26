import '../empresa/empresa.dart';
import '../categoria/categoria.dart';
import '../status/status.dart';

class Pasta {
  int? _id;
  DateTime? _dataAbertura;
  DateTime? _dataAquivoMorto;
  DateTime? _dataEntrega;
  DateTime? _dataValidade;

  Empresa _empresa;
  Categoria _categoria;
  Status _status;

  Pasta({
    int? id, 
    required Empresa empresa,
    required Categoria categoria,
    required Status status,
    DateTime? dataAbertura,
    DateTime? dataAquivoMorto, 
    DateTime? dataEntrega, 
    DateTime? dataValidade})
  :_id = id, 
  _dataAbertura = dataAbertura, 
  _dataAquivoMorto = dataAquivoMorto, 
  _dataEntrega = dataEntrega,
  _dataValidade = dataValidade,
  _empresa = empresa,
  _categoria = categoria,
  _status = status;

  int? get id => _id;
  DateTime? get dataAbertura => _dataAbertura;
  DateTime? get dataAquivoMorto => _dataAquivoMorto;
  DateTime? get dataEntrega => _dataEntrega;
  DateTime? get dataValidade => _dataValidade;
  Empresa get empresa => _empresa;
  Categoria get categoria => _categoria;
  Status get status => _status;

  @override
  String toString(){
    return '''
    ==========================================
    [$id] Nome: ${empresa.nome} | CNPJ: ${empresa.cnpj}
    Categoria: ${categoria.nomeCategoria} | Status: ${status.nome}
    Data de Abertura: $dataAbertura
    Data Arquivo morto: $dataAquivoMorto
    Data de Validade: $dataValidade
    Data de Entrega: $dataEntrega
    ==========================================''';
  }
}