import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import semua halaman
import 'package:manejemen_surat/views/home.dart';
import 'package:manejemen_surat/views/suratmasuk.dart';
import 'package:manejemen_surat/views/disposisi.dart';
import 'package:manejemen_surat/views/suratkeluar.dart';
import 'package:manejemen_surat/views/pengaturan/akun.dart'; // nanti bisa ganti ke PengaturanPage()

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // daftar halaman
  final List<Widget> _pages = [
    const HomePage(),
    const SuratMasuk(),
    const DisposisiSuratMasuk(),
    const SuratKeluar(),
    const Akun(), // bisa diganti ke PengaturanPage()
  ];

  // judul tiap halaman
  final List<String> _titles = [
    "Beranda",
    "Surat Masuk",
    "Disposisi Masuk",
    "Surat Keluar",
    "Pengaturan",
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // tutup drawer otomatis
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex], // judul dinamis
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              currentAccountPicture: const CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 28, color: Colors.blue),
              ),
              accountName: Text(
                "Rizky Pratama, S.IP",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              accountEmail: Text(
                "Staf Bagian Umum DPRD\nAkses: Admin",
                style: GoogleFonts.poppins(fontSize: 13),
              ),
            ),
            _buildDrawerItem(
              icon: Icons.home,
              text: "Beranda",
              index: 0,
            ),
            _buildDrawerItem(
              icon: Icons.mail,
              text: "Surat Masuk",
              index: 1,
            ),
            _buildDrawerItem(
              icon: Icons.assignment,
              text: "Disposisi Masuk",
              index: 2,
            ),
            _buildDrawerItem(
              icon: Icons.send,
              text: "Surat Keluar",
              index: 3,
            ),
            const Divider(),
            _buildDrawerItem(
              icon: Icons.settings,
              text: "Pengaturan",
              index: 4, // ubah index sesuai urutan halaman _pages
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }

  // Widget drawer item dengan kotak biru aktif
  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required int index,
  }) {
    bool isActive = _selectedIndex == index;

    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue.shade100 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: isActive ? Colors.blue : Colors.grey[700]),
            const SizedBox(width: 10),
            Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? Colors.blue : Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
