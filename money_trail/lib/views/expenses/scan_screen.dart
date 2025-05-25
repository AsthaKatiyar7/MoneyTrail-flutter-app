import 'package:flutter/material.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Receipt')),
      body: const Center(child: Text('Scan Receipt - Coming Soon')),
    );
  }
}
