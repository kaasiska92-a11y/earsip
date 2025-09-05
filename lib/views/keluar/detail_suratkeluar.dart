import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailSuratKeluar extends StatelessWidget {
  final Map<String, dynamic> surat;

  const DetailSuratKeluar({super.key, required this.surat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "Detail Surat Keluar",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Field detail surat
                buildInputCard("Nomor Surat", surat['no']),
                const SizedBox(height: 12),
                buildInputCard("Tanggal Surat", surat['tanggal']),
                const SizedBox(height: 12),
                buildInputCard("Tujuan", surat['tujuan']),
                const SizedBox(height: 12),
                buildInputCard("Perihal", surat['perihal']),
                const SizedBox(height: 12),

                if (surat['lampiran'] != null)
                  buildLampiranCard(surat['lampiran']),
                const SizedBox(height: 16),

                buildStatusCard(surat['status'] ?? "Belum Dibaca"),
                const SizedBox(height: 100), // spasi untuk tombol bawah
              ],
            ),
          ),

          // Tombol bawah
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              children: [
                // Tombol kiri
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (surat['status'] == "Draft") {
                        // TODO: fungsi Edit
                      } else if (surat['status'] == "Terkirim") {
                        // TODO: fungsi Arsipkan
                      } else {
                        // TODO: fungsi Simpan Draft
                      }
                    },
                    icon: Icon(
                      surat['status'] == "Draft"
                          ? Icons.edit
                          : surat['status'] == "Terkirim"
                              ? Icons.archive
                              : Icons.drafts,
                      color: Colors.white,
                    ),
                    label: Text(
                      surat['status'] == "Draft"
                          ? "Edit"
                          : surat['status'] == "Terkirim"
                              ? "Arsipkan"
                              : "Draft",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: surat['status'] == "Draft"
                          ? Colors.green
                          : surat['status'] == "Terkirim"
                              ? Colors.green
                              : Colors.grey[400],
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Tombol kanan
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (surat['status'] == "Terkirim") {
                        // TODO: fungsi Kirim
                      } else {
                        // TODO: fungsi Simpan
                      }
                    },
                    icon: Icon(
                      surat['status'] == "Terkirim" ? Icons.send : Icons.save,
                      color: Colors.white,
                    ),
                    label: Text(
                      surat['status'] == "Terkirim" ? "Kirim" : "Simpan",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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

  // Card field input
  Widget buildInputCard(String title, String? value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 13, color: Colors.grey[700])),
          const SizedBox(height: 6),
          Text(value ?? "-",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600, fontSize: 16)),
        ],
      ),
    );
  }

  // Card status surat
  Widget buildStatusCard(String status) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.mark_email_unread,
              color: status == "Belum Dibaca" ? Colors.blue : Colors.green),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Status: $status",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Card lampiran PDF
  Widget buildLampiranCard(String lampiran) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ListTile(
        leading: const Icon(Icons.picture_as_pdf,
            color: Colors.red, size: 40),
        title: Text(
          lampiran,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        subtitle: Text("PDF Dokumen",
            style: GoogleFonts.poppins(fontSize: 12)),
        trailing: IconButton(
          icon: const Icon(Icons.download, color: Colors.grey),
          onPressed: () {
            // TODO: aksi download PDF
          },
        ),
      ),
    );
  }
}
