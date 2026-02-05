import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/wallet_service.dart';
import '../services/crypto_service.dart';
import '../widgets/crypto_card.dart';
import '../widgets/trending_coin_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _selectedIndex == 0 ? _buildHomeView() : _buildPortfolioView(),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }
  
  Widget _buildHomeView() {
    return RefreshIndicator(
      onRefresh: () async {
        await Provider.of<CryptoService>(context, listen: false).fetchCryptoData();
        await Provider.of<WalletService>(context, listen: false).refreshBalance();
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          _buildAppBar(),
          _buildWalletCard(),
          _buildQuickActions(),
          _buildTrendingSection(),
          _buildAllCoinsSection(),
        ],
      ),
    );
  }
  
  Widget _buildPortfolioView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pie_chart_outline,
            size: 80,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Portfolio',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coming Soon',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
  
  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 80,
      floating: true,
      pinned: false,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C5CE7), Color(0xFF00D4FF)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.currency_bitcoin, size: 24),
            ),
            const SizedBox(width: 12),
            const Text(
              'CryptoWallet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {
            Navigator.pushNamed(context, '/settings');
          },
        ),
      ],
    );
  }
  
  Widget _buildWalletCard() {
    return SliverToBoxAdapter(
      child: Consumer<WalletService>(
        builder: (context, wallet, _) {
          return Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF6C5CE7),
                  Color(0xFF4834D4),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C5CE7).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Balance',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.circle, size: 8, color: Colors.greenAccent),
                          SizedBox(width: 6),
                          Text(
                            'Monad Testnet',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (wallet.hasWallet) ...[
                  Text(
                    wallet.balanceString,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: wallet.addressString));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Address copied!')),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${wallet.addressString.substring(0, 8)}...${wallet.addressString.substring(wallet.addressString.length - 6)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                          const Icon(Icons.copy, size: 16, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  const Text(
                    '0.0000 MON',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showWalletSetup(context),
                    icon: const Icon(Icons.account_balance_wallet),
                    label: const Text('Create Wallet'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF6C5CE7),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildQuickActions() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: Icons.arrow_upward,
                label: 'Send',
                color: const Color(0xFFFF6B6B),
                onTap: () => _showSendDialog(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                icon: Icons.arrow_downward,
                label: 'Receive',
                color: const Color(0xFF51CF66),
                onTap: () => _showReceiveDialog(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                icon: Icons.swap_horiz,
                label: 'Swap',
                color: const Color(0xFF00D4FF),
                onTap: () => Navigator.pushNamed(context, '/trading'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1F3A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTrendingSection() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 32, 20, 16),
            child: Text(
              '🔥 Trending',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Consumer<CryptoService>(
            builder: (context, crypto, _) {
              if (crypto.isLoading && crypto.trendingCoins.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              
              return SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: crypto.trendingCoins.length,
                  itemBuilder: (context, index) {
                    return TrendingCoinCard(coin: crypto.trendingCoins[index]);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildAllCoinsSection() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Text(
              'All Cryptocurrencies',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Consumer<CryptoService>(
            builder: (context, crypto, _) {
              if (crypto.isLoading && crypto.coins.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              
              if (crypto.coins.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Text(
                      'No data available',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                );
              }
              
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: crypto.coins.length,
                itemBuilder: (context, index) {
                  return CryptoCard(coin: crypto.coins[index]);
                },
              );
            },
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
  
  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
          ),
        ],
      ),
      child: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.transparent,
        indicatorColor: const Color(0xFF6C5CE7).withOpacity(0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.pie_chart_outline),
            selectedIcon: Icon(Icons.pie_chart),
            label: 'Portfolio',
          ),
        ],
      ),
    );
  }
  
  void _showWalletSetup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1F3A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Setup Wallet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.add_circle_outline, color: Color(0xFF6C5CE7)),
              title: const Text('Create New Wallet', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Generate a new wallet', style: TextStyle(color: Colors.white60)),
              onTap: () async {
                Navigator.pop(context);
                await Provider.of<WalletService>(context, listen: false).createWallet();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Wallet created successfully!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.download, color: Color(0xFF00D4FF)),
              title: const Text('Import Wallet', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Import using private key', style: TextStyle(color: Colors.white60)),
              onTap: () {
                Navigator.pop(context);
                _showImportDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void _showImportDialog(BuildContext context) {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F3A),
        title: const Text('Import Wallet', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Private Key',
            hintText: '0x...',
            border: OutlineInputBorder(),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await Provider.of<WalletService>(context, listen: false)
                  .importWallet(controller.text);
            },
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }
  
  void _showSendDialog(BuildContext context) {
    final addressController = TextEditingController();
    final amountController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F3A),
        title: const Text('Send MON', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Recipient Address',
                hintText: '0x...',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                hintText: '0.0',
                border: OutlineInputBorder(),
                suffixText: 'MON',
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final wallet = Provider.of<WalletService>(context, listen: false);
              final txHash = await wallet.sendTransaction(
                toAddress: addressController.text,
                amount: double.tryParse(amountController.text) ?? 0,
              );
              
              if (!context.mounted) return;
              
              if (txHash != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Transaction sent: ${txHash.substring(0, 10)}...')),
                );
              }
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
  
  void _showReceiveDialog(BuildContext context) {
    final wallet = Provider.of<WalletService>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F3A),
        title: const Text('Receive MON', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.qr_code, size: 200, color: Colors.black),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SelectableText(
                wallet.addressString,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: wallet.addressString));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Address copied!')),
              );
            },
            child: const Text('Copy Address'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
