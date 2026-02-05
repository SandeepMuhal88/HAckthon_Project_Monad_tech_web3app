import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../services/wallet_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<WalletService>(
        builder: (context, wallet, _) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildSection(
                title: 'Wallet',
                children: [
                  if (wallet.hasWallet) ...[
                    _buildListTile(
                      icon: Icons.account_balance_wallet,
                      title: 'Wallet Address',
                      subtitle: '${wallet.addressString.substring(0, 10)}...${wallet.addressString.substring(wallet.addressString.length - 8)}',
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: wallet.addressString));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Address copied!')),
                        );
                      },
                    ),
                    _buildListTile(
                      icon: Icons.key,
                      title: 'Export Private Key',
                      subtitle: 'View your private key',
                      onTap: () => _showPrivateKey(context, wallet),
                    ),
                    _buildListTile(
                      icon: Icons.delete_outline,
                      title: 'Delete Wallet',
                      subtitle: 'Remove wallet from device',
                      textColor: const Color(0xFFFF6B6B),
                      onTap: () => _confirmDeleteWallet(context, wallet),
                    ),
                  ] else ...[
                    _buildListTile(
                      icon: Icons.add_circle_outline,
                      title: 'Create Wallet',
                      subtitle: 'Generate a new wallet',
                      onTap: () async {
                        await wallet.createWallet();
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Wallet created!')),
                        );
                      },
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 24),
              _buildSection(
                title: 'Network',
                children: [
                  _buildListTile(
                    icon: Icons.language,
                    title: 'Network',
                    subtitle: 'Monad Testnet',
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF51CF66).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, size: 8, color: Color(0xFF51CF66)),
                          SizedBox(width: 6),
                          Text(
                            'Connected',
                            style: TextStyle(
                              color: Color(0xFF51CF66),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSection(
                title: 'About',
                children: [
                  _buildListTile(
                    icon: Icons.info_outline,
                    title: 'Version',
                    subtitle: '1.0.0',
                  ),
                  _buildListTile(
                    icon: Icons.description_outlined,
                    title: 'Terms of Service',
                    onTap: () {},
                  ),
                  _buildListTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    onTap: () {},
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
  
  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6C5CE7),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1F3A),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
  
  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Widget? trailing,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? const Color(0xFF6C5CE7)),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12,
              ),
            )
          : null,
      trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right, color: Colors.white54) : null),
      onTap: onTap,
    );
  }
  
  void _showPrivateKey(BuildContext context, WalletService wallet) async {
    final privateKey = await wallet.getPrivateKey();
    
    if (!context.mounted) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F3A),
        title: const Row(
          children: [
            Icon(Icons.warning_amber, color: Color(0xFFFF6B6B)),
            SizedBox(width: 8),
            Text('Private Key', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '⚠️ Never share your private key with anyone!',
              style: TextStyle(
                color: Color(0xFFFF6B6B),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              child: SelectableText(
                privateKey ?? '',
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
              Clipboard.setData(ClipboardData(text: privateKey ?? ''));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Private key copied!')),
              );
            },
            child: const Text('Copy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
  
  void _confirmDeleteWallet(BuildContext context, WalletService wallet) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F3A),
        title: const Text('Delete Wallet?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'This will remove your wallet from this device. Make sure you have backed up your private key!',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await wallet.deleteWallet();
              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Wallet deleted')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
