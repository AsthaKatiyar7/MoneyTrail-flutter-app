import 'package:flutter/material.dart';
import '../analytics/analytics_screen.dart';
import '../expenses/form_screen.dart';
import '../expenses/scan_screen.dart';
import '../expenses/voice_note_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const AnalyticsScreen(),
    const FormScreen(),
    const VoiceNoteScreen(),
    const ScanScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        backgroundColor: Colors.white,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Form'),
          BottomNavigationBarItem(icon: Icon(Icons.mic), label: 'Voice Note'),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'Scan'),
        ],
      ),
    );
  }
}
