import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../routes/app_routes.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({Key? key}) : super(key: key);

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final TextEditingController qrController = TextEditingController();
  bool isVerifying = false;

  void _verifyQr(Map<String, dynamic> args) async {
    if (qrController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please paste QR code data')),
      );
      return;
    }

    setState(() => isVerifying = true);

    try {
      final result = await ApiService.verifyAndMintProof(
        qrString: qrController.text,
        userAddress: args['userAddress'],
        eventId: args['eventId'],
      );

      if (mounted) {
        if (result['success']) {
          Navigator.of(context).pushNamed(
            AppRoutes.proofStatus,
            arguments: {
              'success': true,
              'txHash': result['tx_hash'],
              'message': result['message'],
              'eventId': args['eventId'],
              'eventName': args['eventName'],
            },
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? 'Verification failed')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => isVerifying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};

    return Scaffold(
      appBar: AppBar(
        title: Text(args['eventName'] ?? 'Verify Attendance'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Scan QR Code',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Paste the QR code data from the event',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.indigo.shade200),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.indigo.shade50,
                ),
                child: Column(
                  children: [
                    Icon(Icons.qr_code, size: 48, color: Colors.indigo),
                    const SizedBox(height: 16),
                    const Text(
                      'In a real app, this would scan the QR code',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'QR Code Data',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: qrController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Paste QR code data here or use default',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Set default QR for demo
                    qrController.text = '${args['eventId']}:${DateTime.now().millisecondsSinceEpoch ~/ 1000}:demo-nonce-12345';
                  },
                  child: const Text('Use Demo QR Code'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isVerifying ? null : () => _verifyQr(args),
                  icon: isVerifying ? null : const Icon(Icons.check_circle),
                  label: isVerifying
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Verify & Mint Proof'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    qrController.dispose();
    super.dispose();
  }
}
