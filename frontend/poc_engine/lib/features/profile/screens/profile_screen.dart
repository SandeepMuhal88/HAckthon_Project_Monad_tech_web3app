import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../services/storage_service.dart';
import '../../../routes/app_routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<dynamic> proofsFuture;
  String? userName;
  String? userEmail;
  String? userAddress;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final name = await StorageService.getUserName();
    final email = await StorageService.getUserEmail();
    final address = await StorageService.getUserAddress();
    
    setState(() {
      userName = name;
      userEmail = email;
      userAddress = address;
      if (address != null) {
        proofsFuture = ApiService.getUserProofs(address);
      }
    });
  }

  void _logout() async {
    await StorageService.logout();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.indigo.shade400, Colors.indigo.shade600],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        size: 32,
                        color: Colors.indigo.shade600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      userName ?? 'User',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userEmail ?? 'email@example.com',
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Account Information
              Text(
                'Account Information',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              _InfoCard(
                icon: Icons.account_balance_wallet,
                label: 'Wallet Address',
                value: userAddress != null 
                    ? '${userAddress!.substring(0, 6)}...${userAddress!.substring(userAddress!.length - 6)}'
                    : 'Not set',
                fullValue: userAddress ?? '',
              ),
              const SizedBox(height: 12),
              _InfoCard(
                icon: Icons.email,
                label: 'Email',
                value: userEmail ?? 'Not set',
              ),
              const SizedBox(height: 24),
              
              // My Proofs Section
              Text(
                'My Proofs',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              
              if (userAddress != null)
                FutureBuilder<dynamic>(
                  future: proofsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error loading proofs: ${snapshot.error}'),
                      );
                    }

                    final data = snapshot.data ?? {};
                    final proofs = data['proofs'] ?? [];
                    final proofCount = data['proof_count'] ?? 0;

                    if (proofCount == 0) {
                      return Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.card_membership,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            const Text('No proofs yet'),
                            const SizedBox(height: 8),
                            const Text(
                              'Attend events and verify your attendance to earn proofs',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    }

                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            border: Border.all(color: Colors.green.shade200),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green.shade600),
                              const SizedBox(width: 8),
                              Text(
                                'You have $proofCount proof${proofCount > 1 ? 's' : ''}',
                                style: TextStyle(color: Colors.green.shade700),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...proofs.map((proof) => ProofCard(proof: proof)).toList(),
                      ],
                    );
                  },
                )
              else
                const Text('Please log in to view proofs'),
              
              const SizedBox(height: 24),
              
              // Logout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String fullValue;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    this.fullValue = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.indigo),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (fullValue.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.copy, size: 18),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copied to clipboard')),
                );
              },
            ),
        ],
      ),
    );
  }
}

class ProofCard extends StatelessWidget {
  final dynamic proof;

  const ProofCard({Key? key, required this.proof}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.card_membership, color: Colors.indigo.shade600),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Event ${proof['event_id']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        proof['timestamp'] ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'TX: ${proof['tx_hash']?.substring(0, 16) ?? 'N/A'}...',
                      style: const TextStyle(
                        fontSize: 11,
                        fontFamily: 'monospace',
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const Icon(Icons.check_circle, size: 16, color: Colors.green),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
