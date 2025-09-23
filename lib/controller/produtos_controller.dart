import 'package:aplicacao_aula/model/produto.dart';

class ProdutosController {
  final List<Produto> _produtos = [];

  List<Produto> get produtos => List.unmodifiable(_produtos);

  void adicionarProduto(Produto produto) {
    _produtos.add(produto);
  }

  void removerProduto(int id) {
    _produtos.removeWhere((p) => p.id == id);
  }
}
