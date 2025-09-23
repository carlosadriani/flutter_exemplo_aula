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
  String? _savedToken;

  @override
  void initState() {
    // Comentar estas linhas para não preencher automaticamente
    _usernameController.text = 'emilys';
    _passwordController.text = 'emilyspass';
    //
    _loadToken();
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadToken() async {
    final savedUser = await AuthStorage.getUserData();
    _savedToken = savedUser?['accessToken'];
    setState(() {
      if (_savedToken != null) {
        _usernameController.text = 'emilys';
      }
    });
  }

  Future<void> _login() async {
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
      setState(() {
        _loading = false;
      });
      switch (response.statusCode) {
        case 200:
          final data = jsonDecode(response.body);
          String token = data['accessToken'];
          log('token:[$token]');

          await AuthStorage.saveUserData(jsonDecode(response.body));
          // final prefs = await SharedPreferences.getInstance();
          // await prefs.setString("auth_token", token);
          // await prefs.setString("username", _usernameController.text.trim());
          // await prefs.setString("id", data['id'].toString());
          // await prefs.setString("firstName", data['firstName'] ?? '');
          // await prefs.setString("lastName", data['lastName'] ?? '');
          // await prefs.setString("email", data['email'] ?? '');
          // await prefs.setString("image", data['image'] ?? '');
          // await prefs.setString("gender", data['gender'] ?? '');

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomePage()),
          );
          break;
        case 400:
          setState(() {
            // _usernameController.clear();
            // _passwordController.clear();
            _errorMessage = 'Login inválido!';
          });
        // throw Exception('Login inválido!');
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
      setState(() {
        _errorMessage = "$e";
      });
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
