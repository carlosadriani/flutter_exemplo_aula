import 'package:aplicacao_aula/service/google_auth_service.dart';
import 'package:flutter/material.dart';

/// Botão de login com Google para Android, iOS e macOS.
class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key, required this.aoFalhar});

  final void Function(Object erro) aoFalhar;

  @override
  Widget build(BuildContext context) {
    if (!GoogleAuthService.suportaBotaoProprio) {
      return const Text("Login com Google indisponível nesta plataforma.");
    }
    return OutlinedButton.icon(
      onPressed: () async {
        try {
          // O sucesso não volta por aqui: chega no stream de eventos que a
          // LoginPage escuta.
          await GoogleAuthService.entrar();
        } catch (e) {
          aoFalhar(e);
        }
      },
      icon: const Icon(Icons.account_circle_outlined),
      label: const Text("Entrar com Google"),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
