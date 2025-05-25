import 'package:flutter/material.dart';

class VoiceNoteScreen extends StatelessWidget {
  const VoiceNoteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voice Note')),
      body: const Center(child: Text('Voice Note - Coming Soon')),
    );
  }
}
