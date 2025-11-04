import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ✅ Import halaman tujuan
import 'package:manejemen_surat/views/suratmasuk.dart';
import 'package:manejemen_surat/views/disposisi.dart';
import 'package:manejemen_surat/views/suratkeluar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream<int> getJumlahSuratMasuk() {
    return FirebaseFirestore.instance
        .collection('surat_masuk')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<int> getJumlahDisposisi() {
    return FirebaseFirestore.instance
        .collection('disposisi')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<int> getJumlahSuratKeluar() {
    return FirebaseFirestore.instance
        .collection('surat_keluar')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔹 Banner modern
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade800, Colors.blue.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade200.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const Icon(
                      Icons.emoji_events,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Selamat Datang di Aplikasi e-Surat DPRD!",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 🔹 Menu Surat Masuk
            StreamBuilder<int>(
              stream: getJumlahSuratMasuk(),
              builder: (context, snapshot) {
                final count = snapshot.data ?? 0;
                return _menuCard(
                  icon: Icons.mail_outline,
                  title: "$count Surat Masuk",
                  subtitle: "Total surat diterima",
                  badgeValue: count,
                  buttonText: "Lihat Sekarang",
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade600, Colors.blue.shade400],
                  ),
                  badgeColor: Colors.redAccent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SuratMasuk(),
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 16),

            // 🔹 Menu Disposisi
            StreamBuilder<int>(
              stream: getJumlahDisposisi(),
              builder: (context, snapshot) {
                final count = snapshot.data ?? 0;
                return _menuCard(
                  icon: Icons.assignment_outlined,
                  title: "$count Disposisi",
                  subtitle: "Surat telah didisposisikan",
                  badgeValue: count,
                  buttonText: "Lihat Sekarang",
                  gradient: LinearGradient(
                    colors: [
                      Colors.deepPurple.shade600,
                      Colors.deepPurple.shade400,
                    ],
                  ),
                  badgeColor: Colors.orangeAccent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DisposisiSuratMasuk(),
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 16),

            // 🔹 Menu Surat Keluar
            StreamBuilder<int>(
              stream: getJumlahSuratKeluar(),
              builder: (context, snapshot) {
                final count = snapshot.data ?? 0;
                return _menuCard(
                  icon: Icons.send_outlined,
                  title: "$count Surat Keluar",
                  subtitle: "Surat tersimpan",
                  badgeValue: count,
                  buttonText: "Lihat Sekarang",
                  gradient: LinearGradient(
                    colors: [Colors.green.shade600, Colors.green.shade400],
                  ),
                  badgeColor: Colors.teal,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SuratKeluar(),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonText,
    required int badgeValue,
    required LinearGradient gradient,
    required Color badgeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, size: 36, color: Colors.white),
                ),
                if (badgeValue > 0)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        "$badgeValue",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    alignment: Alignment.center,
                    child: Text(
                      buttonText,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
