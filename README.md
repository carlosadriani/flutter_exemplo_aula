# aplicacao_aula

Um projeto feito em Flutter para desenvolvimento em sala de aula.

## Descrição

Este projeto foi desenvolvido em sala de aula para ensinar o básico de Flutter
com acesso a uma API de autenticação, cadastro de pessoas e de produtos.


## Arquitetura do projeto

lib/
├── main.dart
├── controller/
│   ├── auth_controller.dart
│   ├── pessoas_controller.dart
│   ├── produtos_controller.dart
│   └── relatorios_controller.dart
├── model/
│   ├── pessoa.dart
│   ├── produto.dart
│   └── relatorio.dart
├── repository/
│   ├── pessoa_repository.dart
│   └── produto_repository.dart
├── service/
│   └── google_auth_service.dart
├── utils/
│   ├── constants.dart
│   └── google_config.dart
└── view/
    ├── splash_screen.dart
    ├── login_page.dart
    ├── home_page.dart          <- casca com a BottomNavigationBar (IndexedStack)
    ├── pessoas_page.dart
    ├── produtos_page.dart
    ├── relatorios_page.dart
    └── widgets/
        ├── logout_button.dart
        └── google_sign_in_button.dart   (+ _io e _web)

## Login com Google

O app tem dois caminhos de login: usuário/senha contra a API do
[dummyjson](https://dummyjson.com) (`emilys` / `emilyspass`) e o botão
"Entrar com Google", feito com o pacote
[`google_sign_in`](https://pub.dev/packages/google_sign_in) 7.x.

Os dois caminhos gravam o usuário no mesmo `AuthStorage`, então a `HomePage`
não precisa saber por onde a pessoa entrou.

### Antes de rodar

```bash
flutter pub get
```

### Configurando os Client IDs

Sem os IDs preenchidos o botão aparece, mas o login falha com uma mensagem
dizendo o que está faltando. Todos vêm do **Google Cloud Console >
APIs e Serviços > Credenciais > Criar credenciais > ID do cliente OAuth**.

| Plataforma | Tipo de cliente OAuth | Onde colocar |
|---|---|---|
| Android | Android (com o SHA-1 da chave) + Aplicativo Web | `GoogleConfig.serverClientId` recebe o ID do cliente **web** |
| iOS / macOS | iOS | `GoogleConfig.iosClientId` e o `CFBundleURLTypes` do `Info.plist` |
| Web | Aplicativo Web | `GoogleConfig.webClientId` e a meta tag do `web/index.html` |

Passo a passo:

1. **Android** — pegue o SHA-1 com `cd android && ./gradlew signingReport`,
   crie um cliente OAuth do tipo Android com esse SHA-1 e o pacote
   `com.example.aplicacao_aula`. Crie também um cliente do tipo *Aplicativo
   Web* e coloque o ID dele em `GoogleConfig.serverClientId` — é ele que faz
   o Google devolver o `idToken`.
2. **iOS e macOS** — crie um cliente do tipo iOS, coloque o ID em
   `GoogleConfig.iosClientId` e o *reversed client ID* (o mesmo ID com os
   segmentos invertidos) no `CFBundleURLTypes` de `ios/Runner/Info.plist` e
   `macos/Runner/Info.plist`, no lugar do `TODO`.
3. **Web** — coloque o ID do cliente web em `GoogleConfig.webClientId` e na
   meta tag `google-signin-client_id` de `web/index.html`. Cadastre
   `http://localhost` em *Origens JavaScript autorizadas*.

### Detalhes que valem comentar em aula

- Na API 7 o `google_sign_in` virou um **singleton**: existe um único
  `GoogleSignIn.instance`, que precisa de `initialize()` antes de tudo.
- O resultado do login **não é o retorno do método**: ele chega pelo stream
  `authenticationEvents`. É por isso que a `LoginPage` mantém uma
  `StreamSubscription` e a cancela no `dispose()`.
- A web não permite um botão próprio: o Google exige o botão desenhado pelo
  SDK dele. Daí o *import condicional* em `google_sign_in_button.dart`, que
  escolhe entre a versão `_io` e a `_web` em tempo de compilação.
- O macOS roda em sandbox: sem a permissão `com.apple.security.network.client`
  nos `.entitlements`, nenhuma requisição HTTP sai do app.

## Testes

```bash
flutter test
```
