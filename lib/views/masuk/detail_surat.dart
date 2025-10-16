import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manejemen_surat/views/masuk/createdisposisi.dart';
import 'package:manejemen_surat/views/masuk/webview.dart';
import 'package:manejemen_surat/models/surat.dart';
import 'package:manejemen_surat/views/masuk/edit_surat.dart';

class DetailSurat extends StatelessWidget {
  final Surat surat;

  const DetailSurat({super.key, required this.surat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Detail Surat",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Data surat
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow("Nomor Surat", surat.nomor),
                  _buildDetailRow("Tanggal Terima", surat.tanggal_penerimaan),
                  _buildDetailRow("Tanggal Surat", surat.tanggalSurat),
                  _buildDetailRow("Asal Surat", surat.asal),
                  _buildDetailRow(
                    "Sifat Surat",
                    (surat.sifat != null && surat.sifat!.isNotEmpty)
                        ? surat.sifat!
                        : "-",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 🔹 Perihal
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Perihal",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(surat.perihal, style: GoogleFonts.poppins(fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 🔹 Lampiran
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.picture_as_pdf, color: Colors.red, size: 30),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        final lampiran = surat.lampiranSurat ?? "";
                        if (lampiran.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WebViewPage(url: lampiran),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Lampiran tidak tersedia"),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Lampiran Surat",
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 🔹 Tombol Edit (kiri) dan Disposisi (kanan)
            Row(
              children: [
                // 🔸 Tombol Edit
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditSuratMasuk(surat: surat), //
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit, color: Colors.white),
                    label: Text(
                      "Edit",
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // 🔹 Tombol Disposisi
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          surat.sudahDisposisi ? Colors.grey : Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed:
                        surat.sudahDisposisi
                            ? null
                            : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => BuatDisposisiPage(
                                        noSurat: surat.nomor,
                                      ),
                                ),
                              );
                            },
                    icon: const Icon(Icons.send, color: Colors.white),
                    label: Text(
                      surat.sudahDisposisi ? "Sudah Disposisi" : "Disposisi",
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Widget detail row
  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
