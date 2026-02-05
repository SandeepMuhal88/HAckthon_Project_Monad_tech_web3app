import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/crypto_service.dart';
import 'package:intl/intl.dart';

class TradingScreen extends StatefulWidget {
  const TradingScreen({super.key});

  @override
  State<TradingScreen> createState() => _TradingScreenState();
}

class _TradingScreenState extends State<TradingScreen> {
  CryptoCoin? _selectedFromCoin;
  CryptoCoin? _selectedToCoin;
  final _amountController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swap Tokens'),
      ),
      body: Consumer<CryptoService>(
        builder: (context, crypto, _) {
          if (crypto.coins.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildSwapCard(
                  title: 'From',
                  coin: _selectedFromCoin,
                  coins: crypto.coins,
                  onCoinSelected: (coin) {
                    setState(() => _selectedFromCoin = coin);
                  },
                  controller: _amountController,
                ),
                const SizedBox(height: 20),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C5CE7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.swap_vert, color: Colors.white),
                ),
                const SizedBox(height: 20),
                _buildSwapCard(
                  title: 'To',
                  coin: _selectedToCoin,
                  coins: crypto.coins,
                  onCoinSelected: (coin) {
                    setState(() => _selectedToCoin = coin);
                  },
                  readOnly: true,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _selectedFromCoin != null && _selectedToCoin != null
                        ? () => _showSwapConfirmation()
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C5CE7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Swap',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildSwapCard({
    required String title,
    required CryptoCoin? coin,
    required List<CryptoCoin> coins,
    required Function(CryptoCoin) onCoinSelected,
    TextEditingController? controller,
    bool readOnly = false,
  }) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  readOnly: readOnly,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: '0.0',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _showCoinSelector(coins, onCoinSelected),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C5CE7).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      if (coin != null) ...[
                        Text(
                          coin.symbol,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ] else ...[
                        const Text(
                          'Select',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      const Icon(Icons.arrow_drop_down, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (coin != null) ...[
            const SizedBox(height: 8),
            Text(
              '≈ ${formatter.format(coin.currentPrice)}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  void _showCoinSelector(List<CryptoCoin> coins, Function(CryptoCoin) onSelected) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1F3A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Select Token',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: coins.length,
              itemBuilder: (context, index) {
                final coin = coins[index];
                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C5CE7).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        coin.symbol.substring(0, coin.symbol.length > 2 ? 2 : coin.symbol.length),
                        style: const TextStyle(
                          color: Color(0xFF6C5CE7),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    coin.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    coin.symbol,
                    style: TextStyle(color: Colors.white.withOpacity(0.5)),
                  ),
                  onTap: () {
                    onSelected(coin);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  void _showSwapConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F3A),
        title: const Text('Confirm Swap', style: TextStyle(color: Colors.white)),
        content: const Text(
          'This is a demo. Actual swap functionality requires DEX integration.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Swap simulation completed!')),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
