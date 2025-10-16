import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BuatDisposisiPage extends StatefulWidget {
  final String noSurat;

  const BuatDisposisiPage({super.key, required this.noSurat});

  @override
  State<BuatDisposisiPage> createState() => _BuatDisposisiPageState();
}

class _BuatDisposisiPageState extends State<BuatDisposisiPage> {
  final List<Map<String, String>> penerimaList = [
    {"jabatan": "Ketua DPRD", "nama": "Budi S.IP"},
    {"jabatan": "Sekretaris DPRD", "nama": "Rina S.IP"},
    {"jabatan": "Bagian Keuangan", "nama": "Siti S.IP"},
    {"jabatan": "Humas & Protokol", "nama": "Andi S.IP"},
    {"jabatan": "Kabag Persidangan", "nama": "Dewi S.IP"},
    {"jabatan": "Kasubbag Risalah", "nama": "FajarS.IP"},
    {"jabatan": "Staf Keuangan", "nama": "Lina S.IP"},
    {"jabatan": "Kabag Hukum", "nama": "Rangga S.IP"},
    {"jabatan": "Komisi I", "nama": "Arif S.IP"},
    {"jabatan": "Komisi II", "nama": "Maya S.IP"},
    {"jabatan": "Komisi III", "nama": "Doni S.IP"},
    {"jabatan": "Komisi IV", "nama": "Intan S.IP"},
  ];

  final List<String> sifatSuratList = ["Biasa", "Penting", "Segera", "Rahasia"];

  Map<String, String>? penerima;
  String? sifatSurat;

  Future<void> _simpanDisposisi() async {
    try {
      final col = FirebaseFirestore.instance.collection('disposisi');

      // 🔹 Cek dulu apakah nomor surat sudah ada
      final existingSnapshot =
          await col.where('no_surat', isEqualTo: widget.noSurat).limit(1).get();

      if (existingSnapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Surat ini sudah didisposisi sebelumnya."),
          ),
        );
        return; // stop execution
      }

      // 🔹 Cari nomor terakhir
      final snapshot =
          await col.orderBy('nomor', descending: true).limit(1).get();

      int nextNomor = 1;
      if (snapshot.docs.isNotEmpty) {
        final lastNomor = snapshot.docs.first.data()['nomor'];
        if (lastNomor != null) {
          nextNomor = (lastNomor as int) + 1;
        }
      }

      // 🔹 Simpan disposisi
      await col.add({
        'no_surat': widget.noSurat,
        'jabatan': penerima?['jabatan'],
        'nama': penerima?['nama'],
        'sifat_surat': sifatSurat,
        'nomor': nextNomor,
        'created_at': FieldValue.serverTimestamp(),
      });

      // 🔹 Update status surat_masuk menjadi sudahDisposisi = true
      final suratQuery =
          await FirebaseFirestore.instance
              .collection('surat_masuk')
              .where('nomor', isEqualTo: widget.noSurat)
              .limit(1)
              .get();

      if (suratQuery.docs.isNotEmpty) {
        final docRef = suratQuery.docs.first.reference;
        await docRef.update({'sudahDisposisi': true});
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Disposisi berhasil dikirim!")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal menyimpan: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Buat Disposisi",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Penerima Disposisi", style: GoogleFonts.poppins()),
            const SizedBox(height: 6),
            DropdownButtonFormField<Map<String, String>>(
              value: penerima,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              items:
                  penerimaList.map((item) {
                    return DropdownMenuItem<Map<String, String>>(
                      value: item,
                      child: Text(
                        "${item['jabatan']} - ${item['nama']}",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  penerima = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Text("Sifat Surat", style: GoogleFonts.poppins()),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: sifatSurat,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              items:
                  sifatSuratList.map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  sifatSurat = value;
                });
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.send, color: Colors.white),
                label: Text(
                  "Kirim Disposisi",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  if (penerima == null || sifatSurat == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Harap lengkapi semua field!"),
                      ),
                    );
                  } else {
                    _simpanDisposisi();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
