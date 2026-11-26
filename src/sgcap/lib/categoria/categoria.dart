class Categoria{
  int? _idCategoria;
  String _nomeCategoria = "";

  Categoria({int? idCategoria, required String nomeCategoria})
  {_idCategoria = idCategoria; this.nomeCategoria = nomeCategoria;}

  int? get idCategoria => _idCategoria;
  String get nomeCategoria => _nomeCategoria;

  set nomeCategoria(String novoNome) {
    if (novoNome.isNotEmpty) {
        _nomeCategoria = novoNome;
      } else {
        print("O nome não pode estar vazio!");
        }
      }
  @override
  String toString() {
    return "[$idCategoria] Nome: $nomeCategoria";
   }
}