class ApiConfig {
  /// Base URL for the backend API, e.g. "http://10.17.38.206:8000"
  /// If empty, the app will use local/mock implementations.
  /// For Android emulator use: http://10.0.2.2:8000 (maps to localhost on host machine)
  /// For real device use: http://YOUR_IP:8000
  static String baseUrl = 'http://10.0.2.2:8000';

  /// Helper to set base URL at runtime (for example from a settings screen or debug flag)
  static void setBaseUrl(String url) => baseUrl = url;
}
