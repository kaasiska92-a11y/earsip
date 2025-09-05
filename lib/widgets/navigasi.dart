import 'package:flutter/material.dart';
import 'package:manejemen_surat/views/akun.dart';
import 'package:manejemen_surat/views/masuk/arsipkan.dart';
import 'package:manejemen_surat/views/home.dart';
import 'package:manejemen_surat/views/suratkeluar.dart';
import 'package:manejemen_surat/views/suratmasuk.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const SuratMasuk(),
    const SuratKeluar(),
    const Arsipkan(),
    const Akun(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mark_email_unread),
            label: "Masuk",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.outbox),
            label: "Keluar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive),
            label: "Arsipkan",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Akun",
          ),
        ],
      ),
    );
  }
}
