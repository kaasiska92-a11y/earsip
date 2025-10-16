import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manejemen_surat/views/disposisi_masuk/detaildisposisi.dart';

class DisposisiSuratMasuk extends StatefulWidget {
  const DisposisiSuratMasuk({super.key});

  @override
  State<DisposisiSuratMasuk> createState() => _DisposisiSuratMasukState();
}

class _DisposisiSuratMasukState extends State<DisposisiSuratMasuk> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTabButton("Antrian", 0),
              const SizedBox(width: 12),
              _buildTabButton("History", 1),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                // ✅ TAB ANTRIAN
                StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance
                          .collection('disposisi')
                          .orderBy('created_at', descending: true)
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(
                          "Belum ada disposisi",
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final doc = snapshot.data!.docs[index];
                        final data = doc.data() as Map<String, dynamic>;

                        final nomor = (data['nomor'] ?? '-').toString();
                        final noSurat = (data['no_surat'] ?? '-').toString();
                        final jabatan = (data['jabatan'] ?? '-').toString();
                        final nama = (data['nama'] ?? '-').toString();
                        final sifat =
                            (data['sifat_surat'] ?? 'Biasa').toString();
                        final tanggal =
                            data['created_at'] != null
                                ? (data['created_at'] as Timestamp)
                                    .toDate()
                                    .toString()
                                    .substring(0, 10)
                                : "-";

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: DisposisiCard(
                            docId: doc.id,
                            data: data,
                            nomor: nomor,
                            noSurat: noSurat,
                            jabatan: jabatan,
                            nama: nama,
                            sifatSurat: sifat,
                            tanggal: tanggal,
                          ),
                        );
                      },
                    );
                  },
                ),

                // ✅ TAB HISTORY
                Center(
                  child: Text(
                    'Belum ada riwayat',
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    final bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: isSelected ? Colors.white : Colors.blue,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class DisposisiCard extends StatelessWidget {
  final String docId;
  final Map<String, dynamic> data;
  final String nomor;
  final String noSurat;
  final String jabatan;
  final String nama;
  final String sifatSurat;
  final String tanggal;

  const DisposisiCard({
    super.key,
    required this.docId,
    required this.data,
    required this.nomor,
    required this.noSurat,
    required this.jabatan,
    required this.nama,
    required this.sifatSurat,
    required this.tanggal,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // ✅ Navigasi ke detail
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailDisposisiPage(docId: docId, data: data),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Card(
        color: Colors.white, // 🔹 Warna putih untuk kotak data
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Header: nomor, tanggal, dan titik tiga
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "No: $nomor",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[700],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        tanggal,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      // 🔹 Titik tiga menu
                      PopupMenuButton<String>(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onSelected: (value) async {
                          if (value == 'hapus') {
                            await FirebaseFirestore.instance
                                .collection('disposisi')
                                .doc(docId)
                                .delete();
                          } else if (value == 'batal') {
                            // tidak melakukan apa-apa
                          }
                        },
                        itemBuilder:
                            (context) => [
                              const PopupMenuItem(
                                value: 'hapus',
                                child: Text("Hapus"),
                              ),
                              const PopupMenuItem(
                                value: 'batal',
                                child: Text("Batal"),
                              ),
                            ],
                        icon: const Icon(Icons.more_vert, size: 20),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Text(
                "No Surat: $noSurat",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.blue[700],
                ),
              ),
              const SizedBox(height: 4),

              Text(
                "Diteruskan ke: $jabatan - $nama",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 4),

              Text(
                "Sifat Surat: $sifatSurat",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
