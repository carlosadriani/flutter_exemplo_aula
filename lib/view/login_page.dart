import 'dart:convert';
import 'dart:developer';

import 'package:aplicacao_aula/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Comentar estas linhas para não preencher automaticamente
    _usernameController.text = 'emilys';
    _passwordController.text = 'emilyspass';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_usernameController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Informe usuário e senha.');
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('https://dummyjson.com/auth/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": _usernameController.text.trim(),
          "password": _passwordController.text.trim(),
        }),
      );

      switch (response.statusCode) {
        case 200:
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          log('token:[${data['accessToken']}]');

          await AuthStorage.saveUserData(data);

          // Sem esta guarda o Navigator pode ser usado com um context morto.
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        case 400:
          setState(() => _errorMessage = 'Login inválido!');
        case 401:
          throw Exception('Não autorizado (401)');
        case 403:
          throw Exception('Proibido (403)');
        case 404:
          throw Exception('Não encontrado (404)');
        case 500:
          throw Exception('Erro interno do servidor (500)');
        default:
          throw Exception('Erro desconhecido (${response.statusCode})');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = "$e";
      });
    } finally {
      // No código anterior o _loading ficava preso em true quando a
      // requisição falhava (por exemplo, sem internet).
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          elevation: 20,
          child: Container(
            width: 400,
            height: 500,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage('assets/images/logoUPF.png'),
                  width: 150,
                ),
                const Text("Login", style: TextStyle(fontSize: 28)),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: "Usuário"),
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Senha"),
                ),
                const SizedBox(height: 20),
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 20),
                _loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Entrar"),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
