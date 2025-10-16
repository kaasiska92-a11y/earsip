import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailDisposisiPage extends StatelessWidget {
  final String docId;
  final Map<String, dynamic> data;

  const DetailDisposisiPage({
    super.key,
    required this.docId,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final nomor = data['nomor'] ?? '-';
    final noSurat = data['no_surat'] ?? '-';
    final jabatan = data['jabatan'] ?? '-';
    final nama = data['nama'] ?? '-';
    final sifatSurat = data['sifat_surat'] ?? '-';
    final catatan = data['catatan'] ?? '-';
    final tanggal =
        data['created_at'] != null
            ? (data['created_at'] as Timestamp).toDate().toString().substring(
              0,
              10,
            )
            : '-';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Disposisi",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text(
                  "Nomor Disposisi: $nomor",
                  style: GoogleFonts.poppins(fontSize: 15),
                ),
                const SizedBox(height: 8),
                Text(
                  "No Surat: $noSurat",
                  style: GoogleFonts.poppins(fontSize: 15),
                ),
                const SizedBox(height: 8),
                Text("Asal Surat : ", style: GoogleFonts.poppins(fontSize: 15)),
                const SizedBox(height: 8),
                Text(
                  "Diteruskan ke: $jabatan - $nama",
                  style: GoogleFonts.poppins(fontSize: 15),
                ),
                const SizedBox(height: 8),
                Text(
                  "Sifat Surat: $sifatSurat",
                  style: GoogleFonts.poppins(fontSize: 15),
                ),
                const SizedBox(height: 8),
                Text(
                  "Tanggal Terima: $tanggal",
                  style: GoogleFonts.poppins(fontSize: 15),
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 12),
                Text(
                  "Tanggal Surat: $tanggal",
                  style: GoogleFonts.poppins(fontSize: 15),
                ),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  "Perihal:",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  catatan,
                  style: GoogleFonts.poppins(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
