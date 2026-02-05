import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class CryptoCoin {
  final String id;
  final String symbol;
  final String name;
  final double currentPrice;
  final double priceChange24h;
  final double priceChangePercentage24h;
  final double marketCap;
  final double volume24h;
  final String? image;
  
  CryptoCoin({
    required this.id,
    required this.symbol,
    required this.name,
    required this.currentPrice,
    required this.priceChange24h,
    required this.priceChangePercentage24h,
    required this.marketCap,
    required this.volume24h,
    this.image,
  });
  
  factory CryptoCoin.fromJson(Map<String, dynamic> json) {
    return CryptoCoin(
      id: json['id'] ?? '',
      symbol: json['symbol']?.toString().toUpperCase() ?? '',
      name: json['name'] ?? '',
      currentPrice: (json['current_price'] ?? 0).toDouble(),
      priceChange24h: (json['price_change_24h'] ?? 0).toDouble(),
      priceChangePercentage24h: (json['price_change_percentage_24h'] ?? 0).toDouble(),
      marketCap: (json['market_cap'] ?? 0).toDouble(),
      volume24h: (json['total_volume'] ?? 0).toDouble(),
      image: json['image'],
    );
  }
  
  bool get isPriceUp => priceChangePercentage24h >= 0;
}

class CryptoService extends ChangeNotifier {
  List<CryptoCoin> _coins = [];
  List<CryptoCoin> _trendingCoins = [];
  bool _isLoading = false;
  String? _error;
  Timer? _refreshTimer;
  
  // Getters
  List<CryptoCoin> get coins => _coins;
  List<CryptoCoin> get trendingCoins => _trendingCoins;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  CryptoService() {
    _startAutoRefresh();
  }
  
  void _startAutoRefresh() {
    // Refresh prices every 30 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      fetchCryptoData();
    });
    
    // Initial fetch
    fetchCryptoData();
  }
  
  Future<void> fetchCryptoData() async {
    _setLoading(true);
    _clearError();
    
    try {
      // Fetch top cryptocurrencies from CoinGecko API
      final response = await http.get(
        Uri.parse(
          'https://api.coingecko.com/api/v3/coins/markets'
          '?vs_currency=usd'
          '&order=market_cap_desc'
          '&per_page=50'
          '&page=1'
          '&sparkline=false'
          '&price_change_percentage=24h',
        ),
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _coins = data.map((json) => CryptoCoin.fromJson(json)).toList();
        
        // Get trending coins (top 5 with highest positive price change)
        _trendingCoins = List.from(_coins)
          ..sort((a, b) => b.priceChangePercentage24h.compareTo(a.priceChangePercentage24h))
          ..take(5).toList();
        
        notifyListeners();
      } else {
        _setError('Failed to load crypto data: ${response.statusCode}');
      }
    } catch (e) {
      _setError('Network error: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  CryptoCoin? getCoinBySymbol(String symbol) {
    try {
      return _coins.firstWhere(
        (coin) => coin.symbol.toLowerCase() == symbol.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }
  
  Future<List<Map<String, dynamic>>> getCoinHistory(String coinId, int days) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.coingecko.com/api/v3/coins/$coinId/market_chart'
          '?vs_currency=usd'
          '&days=$days'
          '&interval=daily',
        ),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> prices = data['prices'];
        
        return prices.map((point) => {
          'timestamp': point[0],
          'price': point[1],
        }).toList();
      }
    } catch (e) {
      debugPrint('Error fetching history: $e');
    }
    
    return [];
  }
  
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  
  void _setError(String message) {
    _error = message;
    notifyListeners();
  }
  
  void _clearError() {
    _error = null;
  }
  
  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
}
