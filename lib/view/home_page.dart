import 'package:aplicacao_aula/controller/auth_controller.dart';
import 'package:aplicacao_aula/view/pessoas_page.dart';
import 'package:aplicacao_aula/view/produtos_page.dart';
import 'package:aplicacao_aula/view/relatorios_page.dart';
import 'package:aplicacao_aula/view/widgets/logout_button.dart';
import 'package:flutter/material.dart';

/// Casca da aplicação: é ela quem tem a BottomNavigationBar.
///
/// Antes cada toque na barra fazia Navigator.push de uma página nova, o que
/// empilhava telas indefinidamente e fazia o índice selecionado nunca
/// corresponder à tela visível. Com IndexedStack as quatro abas são
/// construídas uma única vez e apenas trocam de visibilidade, preservando o
/// estado de cada uma (a lista de produtos não some mais ao trocar de aba).
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _indiceAtual = 0;

  static const List<Widget> _abas = [
    InicioTab(),
    PessoasPage(),
    ProdutosPage(),
    RelatoriosPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _indiceAtual, children: _abas),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        onTap: (index) => setState(() => _indiceAtual = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Início"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Pessoas"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Produtos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Relatórios",
          ),
        ],
      ),
    );
  }
}

/// Aba inicial: mostra os dados do usuário autenticado.
class InicioTab extends StatefulWidget {
  const InicioTab({super.key});

  @override
  State<InicioTab> createState() => _InicioTabState();
}

class _InicioTabState extends State<InicioTab> {
  Map<String, dynamic>? _usuario;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarUsuario();
  }

  Future<void> _carregarUsuario() async {
    final usuario = await AuthStorage.getUserData();
    // Depois de um await o widget pode já ter sido removido da árvore.
    if (!mounted) return;
    setState(() {
      _usuario = usuario;
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: const Text("Home Page"),
        actions: const [LogoutButton()],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _corpo(),
    );
  }

  Widget _corpo() {
    // O campo correto para a saudação é "gender", não "username".
    final saudacao = _usuario?['gender'] == 'male'
        ? "Bem-vindo, "
        : "Bem-vinda, ";
    final nome = [_usuario?['firstName'], _usuario?['lastName']]
        .where((p) => p != null && p.toString().isNotEmpty)
        .join(' ');
    final imagem = _usuario?['image'] as String?;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(saudacao),
          Text(
            nome.isEmpty ? "Usuário" : nome,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          if (imagem != null && imagem.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Image(image: NetworkImage(imagem), width: 150),
            ),
        ],
      ),
    );
  }
}
