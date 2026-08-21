import 'package:flutter/material.dart';
import 'package:google_sign_in_web/web_only.dart' as web;

/// Na web o Google exige o botão desenhado pelo próprio SDK.
/// O clique dele dispara o login e o resultado chega pelo stream de eventos.
class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key, required this.aoFalhar});

  final void Function(Object erro) aoFalhar;

  @override
  Widget build(BuildContext context) => web.renderButton();
}
