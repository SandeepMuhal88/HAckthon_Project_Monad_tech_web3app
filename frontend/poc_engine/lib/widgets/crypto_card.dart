import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/crypto_service.dart';

class CryptoCard extends StatelessWidget {
  final CryptoCoin coin;

  const CryptoCard({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final percentageColor = coin.isPriceUp ? const Color(0xFF51CF66) : const Color(0xFFFF6B6B);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Coin Icon & Symbol
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF6C5CE7).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                coin.symbol.substring(0, coin.symbol.length > 3 ? 3 : coin.symbol.length),
                style: const TextStyle(
                  color: Color(0xFF6C5CE7),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Coin Name & Symbol
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coin.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  coin.symbol,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Mini Chart Placeholder
          Container(
            width: 60,
            height: 30,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: CustomPaint(
              painter: MiniChartPainter(
                isUp: coin.isPriceUp,
                color: percentageColor,
              ),
            ),
          ),
          
          // Price & Change
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatter.format(coin.currentPrice),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: percentageColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${coin.isPriceUp ? '+' : ''}${coin.priceChangePercentage24h.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: percentageColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MiniChartPainter extends CustomPainter {
  final bool isUp;
  final Color color;

  MiniChartPainter({required this.isUp, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    // Simple trending line
    if (isUp) {
      path.moveTo(0, size.height);
      path.lineTo(size.width * 0.3, size.height * 0.6);
      path.lineTo(size.width * 0.6, size.height * 0.4);
      path.lineTo(size.width, 0);
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width * 0.3, size.height * 0.4);
      path.lineTo(size.width * 0.6, size.height * 0.6);
      path.lineTo(size.width, size.height);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
