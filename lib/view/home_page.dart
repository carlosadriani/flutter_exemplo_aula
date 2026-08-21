import 'package:aplicacao_aula/controller/auth_controller.dart';
import 'package:aplicacao_aula/view/login_page.dart';
import 'package:aplicacao_aula/view/pessoas_page.dart';
import 'package:aplicacao_aula/view/produtos_page.dart';
import 'package:aplicacao_aula/view/relatorios_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _indiceAtual = 0;
  Map<String, dynamic>? _usuario;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarUsuario();
  }

  Future<void> _carregarUsuario() async {
    final usuario = await AuthStorage.getUserData();
    // Depois de um await o widget pode ja ter sido removido da arvore.
    if (!mounted) return;
    setState(() {
      _usuario = usuario;
      _carregando = false;
    });
  }

  Future<void> _sair() async {
    await AuthStorage.clearUserData();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  void _abrirPagina(int index) {
    Widget pagina;
    switch (index) {
      case 0:
        pagina = const PessoasPage();
        break;
      case 1:
        pagina = const ProdutosPage();
        break;
      case 2:
        pagina = const RelatoriosPage();
        break;
      default:
        pagina = const HomePage();
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => pagina));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: const Text("Home Page", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: _sair,
            tooltip: "Sair",
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _corpo(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        onTap: (index) {
          setState(() {
            _indiceAtual = index;
          });
          _abrirPagina(index);
        },
        items: const [
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

  Widget _corpo() {
    // O campo correto para a saudacao e "gender", nao "username".
    final saudacao = _usuario?['gender'] == 'male' ? "Bem-vindo, " : "Bem-vinda, ";
    final nome = [
      _usuario?['firstName'],
      _usuario?['lastName'],
    ].where((p) => p != null && p.toString().isNotEmpty).join(' ');
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
            Image(image: NetworkImage(imagem), width: 150),
        ],
      ),
    );
  }
}
