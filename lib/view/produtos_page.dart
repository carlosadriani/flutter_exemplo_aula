import 'package:aplicacao_aula/model/produto.dart';
import 'package:flutter/material.dart';
import 'package:aplicacao_aula/controller/produtos_controller.dart';

class ProdutosPage extends StatefulWidget {
  const ProdutosPage({super.key});

  @override
  State<ProdutosPage> createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage> {
  final ProdutosController _controller = ProdutosController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  void _adicionarProduto() {
    if (_nomeController.text.isEmpty ||
        _precoController.text.isEmpty ||
        _descricaoController.text.isEmpty) {
      return;
    }

    final novoProduto = Produto(
      id: DateTime.now().millisecondsSinceEpoch,
      title: _nomeController.text,
      description: _descricaoController.text,
      price: double.tryParse(_precoController.text) ?? 0.0,
    );

    setState(() {
      _controller.adicionarProduto(novoProduto);
    });

    _nomeController.clear();
    _descricaoController.clear();
    _precoController.clear();
    Navigator.pop(context);
  }

  void _abrirDialogo() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Adicionar Produto"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: "Nome"),
            ),
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: "Descrição"),
            ),
            TextField(
              controller: _precoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Preço"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: _adicionarProduto,
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
    final produtos = _controller.produtos;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: const Text("Cadastro de Produtos"),
      ),
      body: produtos.isEmpty
          ? const Center(child: Text("Nenhum produto cadastrado."))
          : ListView.builder(
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                final produto = produtos[index];
                return ListTile(
                  leading: const Icon(Icons.shopping_cart),
                  title: Text("${produto.title}\n${produto.description}"),
                  subtitle: Text(
                    "Preço: R\$ ${produto.price.toStringAsFixed(2)}",
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _controller.removerProduto(produto.id);
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
