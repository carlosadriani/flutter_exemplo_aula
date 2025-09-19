import 'package:aplicacao_aula/model/pessoa.dart';

class PessoasController {
  final List<Pessoa> _pessoas = [];

  List<Pessoa> get pessoas => List.unmodifiable(_pessoas);

  void adicionarPessoa(Pessoa pessoa) {
    _pessoas.add(pessoa);
  }

  void removerPessoa(int id) {
    _pessoas.removeWhere((p) => p.id == id);
  }
}
