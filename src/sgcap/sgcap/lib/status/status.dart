class Status {
  int? _id;
  String _nome;

  Status({int? id, required String nome})
  :_id = id, _nome = nome;

  int? get id => _id;
  String get nome => _nome;
  
  
}