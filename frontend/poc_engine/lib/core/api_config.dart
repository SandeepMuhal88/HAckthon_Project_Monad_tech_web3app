// API Configuration
// This file manages API endpoints based on environment

class ApiConfig {
  // Environment detection
  static const String _defaultBaseUrl = 'http://localhost:8000/api';
  
  // This will be replaced during build by the deployment script
  static const String _productionBaseUrl = 'http://localhost:8000/api';
  
  // Determine which URL to use
  static String get baseUrl {
    // Check if running in release mode
    const bool isProduction = bool.fromEnvironment('dart.vm.product');
    
    if (isProduction) {
      return _productionBaseUrl;
    }
    return _defaultBaseUrl;
  }
  
  // API Endpoints
  static String get eventsEndpoint => '$baseUrl/events';
  static String get qrEndpoint => '$baseUrl/qr';
  static String get proofEndpoint => '$baseUrl/proof';
  
  // Configuration
  static const int connectionTimeout = 30; // seconds
  static const int receiveTimeout = 30; // seconds
  
  // Feature flags
  static const bool enableLogging = true;
  static const bool enableCaching = true;
  
  // QR Configuration
  static const int qrExpirySeconds = 300;
  
  // Display configuration for debugging
  static void printConfig() {
    print('═══════════════════════════════════════');
    print('API Configuration');
    print('═══════════════════════════════════════');
    print('Base URL: $baseUrl');
    print('Events: $eventsEndpoint');
    print('QR: $qrEndpoint');
    print('Proof: $proofEndpoint');
    print('Production Mode: ${bool.fromEnvironment('dart.vm.product')}');
    print('═══════════════════════════════════════');
  }
}
