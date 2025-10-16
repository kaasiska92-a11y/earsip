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
  // 🔹 Ambil jumlah surat masuk yang belum dibaca
  Stream<int> getJumlahSuratMasuk() {
    return FirebaseFirestore.instance
        .collection('surat_masuk') // ✅ ganti ke nama koleksi yang benar
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // 🔹 Ambil jumlah disposisi
  Stream<int> getJumlahDisposisi() {
    return FirebaseFirestore.instance
        .collection('disposisi') // pastikan sesuai di Firestore
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // 🔹 Ambil jumlah surat keluar
  Stream<int> getJumlahSuratKeluar() {
    return FirebaseFirestore.instance
        .collection('surat_keluar') // pastikan sesuai di Firestore
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔹 Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.blue.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade200.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
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
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Selamat Datang di Aplikasi Manajemen Surat e-Surat DPRD!",
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
                  color: Colors.blue,
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
                  color: Colors.deepPurple,
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
                  subtitle: "Surat Tersimpan",
                  badgeValue: count,
                  buttonText: "Lihat Sekarang",
                  color: Colors.green,
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
    required Color color,
    required Color badgeColor,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, size: 32, color: color),
                    ),
                    if (badgeValue > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: badgeColor,
                            borderRadius: BorderRadius.circular(12),
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
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: Text(
                  buttonText,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
