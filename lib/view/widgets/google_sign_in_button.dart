/// Escolhe a implementação do botão conforme a plataforma de compilação.
///
/// A web precisa do botão oficial renderizado pelo próprio Google (exigência
/// do Google Identity Services); as demais plataformas usam um botão comum
/// que chama authenticate().
export 'google_sign_in_button_io.dart'
    if (dart.library.js_interop) 'google_sign_in_button_web.dart';
