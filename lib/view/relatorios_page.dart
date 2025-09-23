import 'package:flutter/material.dart';
import 'package:aplicacao_aula/controller/relatorios_controller.dart';
import 'package:aplicacao_aula/model/relatorio.dart';

class RelatoriosPage extends StatefulWidget {
  const RelatoriosPage({super.key});

  @override
  State<RelatoriosPage> createState() => _RelatoriosPageState();
}

class _RelatoriosPageState extends State<RelatoriosPage> {
  final RelatoriosController _controller = RelatoriosController();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  void _adicionarRelatorio() {
    if (_tituloController.text.isEmpty || _descricaoController.text.isEmpty) {
      return;
    }

    final novoRelatorio = Relatorio(
      id: DateTime.now().millisecondsSinceEpoch,
      titulo: _tituloController.text,
      descricao: _descricaoController.text,
    );

    setState(() {
      _controller.adicionarRelatorio(novoRelatorio);
    });

    _tituloController.clear();
    _descricaoController.clear();
    Navigator.pop(context);
  }

  void _abrirDialogo() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Novo Relatório"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: "Título"),
            ),
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: "Descrição"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: _adicionarRelatorio,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final relatorios = _controller.relatorios;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: const Text("Relatórios"),
      ),
      body: relatorios.isEmpty
          ? const Center(child: Text("Nenhum relatório criado."))
          : ListView.builder(
              itemCount: relatorios.length,
              itemBuilder: (context, index) {
                final relatorio = relatorios[index];
                return ListTile(
                  leading: const Icon(Icons.bar_chart),
                  title: Text(relatorio.titulo),
                  subtitle: Text(relatorio.descricao),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _controller.removerRelatorio(relatorio.id);
                      });
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirDialogo,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }
}
