import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:convert/convert.dart';

class WalletService extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  
  EthereumAddress? _address;
  EthPrivateKey? _privateKey;
  EtherAmount? _balance;
  bool _isLoading = false;
  String? _error;
  
  // Monad Testnet Configuration
  final String rpcUrl = 'https://testnet-rpc.monad.xyz/';
  final int chainId = 41454; // Monad Testnet Chain ID
  late Web3Client _client;
  
  // Getters
  EthereumAddress? get address => _address;
  EtherAmount? get balance => _balance;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasWallet => _address != null;
  
  String get addressString => _address?.hexEip55 ?? '';
  String get balanceString => _balance != null 
      ? '${(_balance!.getValueInUnit(EtherUnit.ether)).toStringAsFixed(4)} MON'
      : '0.0000 MON';
  
  Future<void> initialize() async {
    _client = Web3Client(rpcUrl, http.Client());
    await _loadWallet();
  }
  
  Future<void> _loadWallet() async {
    _setLoading(true);
    try {
      final privateKeyHex = await _storage.read(key: 'wallet_private_key');
      
      if (privateKeyHex != null) {
        _privateKey = EthPrivateKey.fromHex(privateKeyHex);
        _address = _privateKey!.address;
        await refreshBalance();
      }
    } catch (e) {
      _setError('Failed to load wallet: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> createWallet() async {
    _setLoading(true);
    _clearError();
    
    try {
      // Generate new random private key
      final random = Random.secure();
      _privateKey = EthPrivateKey.createRandom(random);
      _address = _privateKey!.address;
      
      // Save to secure storage
      await _storage.write(
        key: 'wallet_private_key',
        value: hex.encode(_privateKey!.privateKey),
      );
      
      await refreshBalance();
    } catch (e) {
      _setError('Failed to create wallet: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> importWallet(String privateKeyHex) async {
    _setLoading(true);
    _clearError();
    
    try {
      // Remove '0x' prefix if present
      if (privateKeyHex.startsWith('0x')) {
        privateKeyHex = privateKeyHex.substring(2);
      }
      
      _privateKey = EthPrivateKey.fromHex(privateKeyHex);
      _address = _privateKey!.address;
      
      // Save to secure storage
      await _storage.write(
        key: 'wallet_private_key',
        value: privateKeyHex,
      );
      
      await refreshBalance();
    } catch (e) {
      _setError('Invalid private key: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> refreshBalance() async {
    if (_address == null) return;
    
    try {
      _balance = await _client.getBalance(_address!);
      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch balance: $e');
    }
  }
  
  Future<String?> sendTransaction({
    required String toAddress,
    required double amount,
  }) async {
    if (_privateKey == null || _address == null) {
      _setError('No wallet available');
      return null;
    }
    
    _setLoading(true);
    _clearError();
    
    try {
      final recipient = EthereumAddress.fromHex(toAddress);
      final amountInWei = EtherAmount.fromUnitAndValue(
        EtherUnit.ether,
        (amount * 1e18).toInt(),
      );
      
      final transaction = Transaction(
        to: recipient,
        value: amountInWei,
        gasPrice: EtherAmount.inWei(BigInt.from(20000000000)), // 20 Gwei
      );
      
      final txHash = await _client.sendTransaction(
        _privateKey!,
        transaction,
        chainId: chainId,
      );
      
      await refreshBalance();
      return txHash;
    } catch (e) {
      _setError('Transaction failed: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<String?> getPrivateKey() async {
    return await _storage.read(key: 'wallet_private_key');
  }
  
  Future<void> deleteWallet() async {
    await _storage.delete(key: 'wallet_private_key');
    _privateKey = null;
    _address = null;
    _balance = null;
    notifyListeners();
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
    _client.dispose();
    super.dispose();
  }
}
