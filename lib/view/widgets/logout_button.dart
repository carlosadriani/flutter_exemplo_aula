import 'package:aplicacao_aula/controller/auth_controller.dart';
import 'package:aplicacao_aula/view/login_page.dart';
import 'package:flutter/material.dart';

/// Botão de sair reaproveitado na AppBar de todas as abas.
class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: "Sair",
      icon: const Icon(Icons.logout),
      onPressed: () async {
        await AuthStorage.clearUserData();
        if (!context.mounted) return;
        // pushAndRemoveUntil descarta toda a pilha: depois do logout o
        // usuário não consegue voltar para dentro do app pelo botão voltar.
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      },
    );
  }
}
