import 'package:aplicacao_aula/utils/google_config.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Camada fina sobre o pacote google_sign_in (API 7.x).
///
/// Na versão 7 o pacote virou um singleton: existe um único
/// [GoogleSignIn.instance], que precisa de [initialize] uma vez antes de
/// qualquer outra chamada, e o resultado do login chega pelo stream
/// [authenticationEvents] — não como retorno de um método.
class GoogleAuthService {
  GoogleAuthService._();

  static final GoogleSignIn _google = GoogleSignIn.instance;
  static bool _iniciado = false;

  /// Stream de eventos de login/logout. Quem escuta é a LoginPage.
  static Stream<GoogleSignInAuthenticationEvent> get eventos =>
      _google.authenticationEvents;

  /// Em iOS e macOS vale o cliente OAuth do tipo iOS; na web, o do tipo web.
  /// No Android o clientId não é informado aqui (vem do SHA-1 cadastrado).
  static String? get _clientId {
    if (kIsWeb) return GoogleConfig.webClientId;
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return GoogleConfig.iosClientId;
      default:
        return null;
    }
  }

  /// serverClientId só se aplica ao Android; na web o pacote não aceita.
  static String? get _serverClientId {
    if (kIsWeb) return null;
    return defaultTargetPlatform == TargetPlatform.android
        ? GoogleConfig.serverClientId
        : null;
  }

  static Future<void> initialize() async {
    if (_iniciado) return;
    await _google.initialize(
      clientId: _clientId,
      serverClientId: _serverClientId,
    );
    _iniciado = true;
  }

  /// Tenta reaproveitar uma sessão anterior sem abrir nenhuma tela.
  static Future<void> tentarLoginSilencioso() async {
    await initialize();
    await _google.attemptLightweightAuthentication();
  }

  /// Android, iOS e macOS abrem a tela do Google por conta própria.
  /// A web não: lá o botão precisa ser o widget oficial do Google.
  static bool get suportaBotaoProprio => _google.supportsAuthenticate();

  static Future<void> entrar() async {
    await initialize();
    await _google.authenticate();
  }

  static Future<void> sair() async {
    if (!_iniciado) return;
    await _google.signOut();
  }

  /// Converte a conta do Google no mesmo formato de Map que a API do
  /// dummyjson devolve, para que a HomePage não precise saber por qual
  /// caminho o usuário entrou.
  static Map<String, dynamic> paraMapaDeUsuario(GoogleSignInAccount conta) {
    final partes = (conta.displayName ?? '').trim().split(RegExp(r'\s+'));
    return {
      'id': conta.id,
      'email': conta.email,
      'firstName': partes.isEmpty ? '' : partes.first,
      'lastName': partes.length > 1 ? partes.sublist(1).join(' ') : '',
      'image': conta.photoUrl,
      'accessToken': conta.authentication.idToken,
      'provider': 'google',
    };
  }
}
