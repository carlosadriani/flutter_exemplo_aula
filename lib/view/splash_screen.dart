import 'dart:async';

import 'package:flutter/material.dart';

import 'login_page.dart';

/// Tela de abertura com o logotipo animado.
///
/// Usa animação **explícita**: um [AnimationController] governa o tempo e
/// dois [Animation] derivam dele o que cada propriedade vale a cada quadro.
/// O mixin [SingleTickerProviderStateMixin] fornece o `vsync`, que amarra a
/// animação ao ritmo de quadros da tela — sem ele o controller rodaria mesmo
/// com o app em segundo plano, gastando bateria à toa.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const Duration _duracaoAnimacao = Duration(milliseconds: 1200);
  static const Duration _tempoNaTela = Duration(milliseconds: 2200);

  late final AnimationController _controller;
  late final Animation<double> _opacidade;
  late final Animation<double> _escala;

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: _duracaoAnimacao);

    // O fade termina em 60% do tempo total: o logo já está visível enquanto
    // ainda cresce, o que dá a sensação de "chegar" em vez de "aparecer".
    _opacidade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    );

    // easeOutBack passa um pouco de 1.0 e volta: é o pequeno "quique" no fim.
    _escala = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    _timer = Timer(_tempoNaTela, () {
      // O timer pode disparar depois da tela ter sido descartada.
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    });
  }

  @override
  void dispose() {
    // Os dois precisam ser liberados: o controller segura um ticker e o
    // timer, um callback que tentaria usar um context já morto.
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        // FadeTransition e ScaleTransition escutam a animação e redesenham
        // só a si mesmos — bem mais barato que chamar setState a cada quadro.
        child: FadeTransition(
          key: const Key('splash-fade'),
          opacity: _opacidade,
          child: ScaleTransition(
            key: const Key('splash-escala'),
            scale: _escala,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logoUPF.png',
                  width: 180,
                  // Se o asset faltar, mostra um ícone em vez de estourar.
                  errorBuilder: (context, erro, pilha) => const Icon(
                    Icons.school,
                    size: 120,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Meu App",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
