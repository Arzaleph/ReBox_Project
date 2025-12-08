class ApiConfig {
  /// Base URL for the backend API, e.g. "http://10.17.38.206:8000"
  /// If empty, the app will use local/mock implementations.
  static String baseUrl = '';

  /// Helper to set base URL at runtime (for example from a settings screen or debug flag)
  static void setBaseUrl(String url) => baseUrl = url;
}
