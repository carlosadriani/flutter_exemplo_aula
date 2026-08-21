/// Client IDs do OAuth 2.0 usados no login com Google.
///
/// Onde obter: console.cloud.google.com > APIs e Serviços > Credenciais >
/// Criar credenciais > ID do cliente OAuth. É preciso criar um cliente para
/// cada tipo de plataforma que você for demonstrar.
///
/// Enquanto os valores forem null o botão do Google aparece, mas o fluxo
/// falha com uma mensagem explicando qual ID está faltando.
class GoogleConfig {
  GoogleConfig._();

  /// Cliente OAuth do tipo **iOS**. Vale para iOS e macOS.
  /// Formato: 000000000000-xxxxxxxx.apps.googleusercontent.com
  static const String? iosClientId = null; // TODO: preencher

  /// Cliente OAuth do tipo **Aplicativo Web**. Usado no Flutter Web.
  /// Lembre de cadastrar http://localhost em "Origens JavaScript autorizadas".
  static const String? webClientId = null; // TODO: preencher

  /// Também é o cliente OAuth do tipo **Aplicativo Web**, mas informado ao
  /// Android como serverClientId — é ele que faz o Google devolver o idToken.
  /// No Android é preciso ainda cadastrar um cliente do tipo Android com o
  /// SHA-1 da sua chave de debug (./gradlew signingReport).
  static const String? serverClientId = null; // TODO: preencher
}
