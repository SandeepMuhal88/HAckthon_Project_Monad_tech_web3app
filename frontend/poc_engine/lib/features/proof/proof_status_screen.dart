import 'package:flutter/material.dart';
import '../../core/api_client.dart';

class ProofStatusScreen extends StatefulWidget {
  const ProofStatusScreen({super.key});

  @override
  State<ProofStatusScreen> createState() => _ProofStatusScreenState();
}

class _ProofStatusScreenState extends State<ProofStatusScreen> {
  String status = 'Verifying proof...';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final qr = ModalRoute.of(context)!.settings.arguments as String;
    _verifyProof(qr);
  }

  Future<void> _verifyProof(String qr) async {
    final res = await ApiClient.post('/proof/verify', {'qr': qr});
    setState(() {
      status = res['success']
          ? 'Proof minted on Monad 🎉'
          : 'Verification failed';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Proof Status')),
      body: Center(
        child: Text(
          status,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
