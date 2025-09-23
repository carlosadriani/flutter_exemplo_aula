import 'package:aplicacao_aula/controller/auth_controller.dart';
import 'package:aplicacao_aula/view/login_page.dart';
import 'package:aplicacao_aula/view/pessoas_page.dart';
import 'package:aplicacao_aula/view/produtos_page.dart';
import 'package:aplicacao_aula/view/relatorios_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _indiceAtual = 0;
  String? _savedToken;
  Map<String, dynamic>? savedUser;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  @override
  void dispose() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("auth_token");
    super.dispose();
  }

  Future<void> _loadToken() async {
    savedUser = await AuthStorage.getUserData();
    setState(() {
      _savedToken = savedUser?['accessToken'];
    });
  }

  void _abrirPagina(int index) {
    Widget pagina = PessoasPage();
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
        pagina = HomePage();
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
            onPressed: () {
              // Limpar os dados do usuário ao fazer logout
              AuthStorage.clearUserData();
              // Carregar a tela de login
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
              );
            },
            icon: Icon(Icons.logout),
          ),
          // SizedBox(width: 10),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              savedUser?['username'] == "Male" ? "Bem-vindo, " : "Bem-vinda, ",
            ),
            Text(
              "${savedUser?['firstName']} ${savedUser?['lastName']}",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            if (savedUser?['image'] != null)
              Image(image: NetworkImage(savedUser?['image']), width: 150),
          ],
        ),
      ),
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
}
