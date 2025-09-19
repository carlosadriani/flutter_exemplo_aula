import 'package:aplicacao_aula/model/relatorio.dart';

class RelatoriosController {
  final List<Relatorio> _relatorios = [];

  List<Relatorio> get relatorios => List.unmodifiable(_relatorios);

  void adicionarRelatorio(Relatorio relatorio) {
    _relatorios.add(relatorio);
  }

  void removerRelatorio(int id) {
    _relatorios.removeWhere((r) => r.id == id);
  }
}
