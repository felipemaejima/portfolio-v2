/// Configuração de build (`--dart-define`). Sem `.env` no app (APP.md §1).
abstract final class AppConfig {
  /// Origem da API, sem path: os paths gerados já incluem `/api/v1`.
  /// Web: vazio → mesma origem (Caddy). Android: `http://<ip>` ou `https://<domínio>`.
  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL');

  /// Caminhos que a API devolve (`/uploads/...`) viram URL completa com a
  /// origem da API; URLs já absolutas passam intactas.
  static String resolve(String pathOrUrl) =>
      pathOrUrl.startsWith('/') ? '$apiBaseUrl$pathOrUrl' : pathOrUrl;
}
