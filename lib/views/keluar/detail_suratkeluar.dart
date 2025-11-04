import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart'; // untuk salin teks

class DetailSuratKeluar extends StatelessWidget {
  final Map<String, dynamic> surat;

  const DetailSuratKeluar({
    super.key,
    required this.surat,
    required String docId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: Text(
          "Detail Surat Keluar",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildDetailCard("Nomor Surat", surat['nomor']),
            const SizedBox(height: 12),
            buildDetailCard("Tanggal Surat", surat['tanggalSurat']),
            const SizedBox(height: 12),
            buildDetailCard("Tujuan", surat['tujuan']),
            const SizedBox(height: 12),
            buildDetailCard("Perihal", surat['perihal']),
            const SizedBox(height: 12),

            // 🔗 Tampilkan link yang bisa diklik
            if (surat['linkSurat'] != null && surat['linkSurat'] != "")
              buildLinkCard(context, surat['linkSurat']),
          ],
        ),
      ),
    );
  }

  // 📋 Card umum untuk menampilkan data surat
  Widget buildDetailCard(String title, String? value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value ?? "-",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  // 🔗 Card khusus untuk link surat
  Widget buildLinkCard(BuildContext context, String linkSurat) {
    // Validasi dan perbaiki URL jika perlu
    String validUrl = linkSurat;
    if (!validUrl.startsWith('http://') && !validUrl.startsWith('https://')) {
      validUrl = 'https://$validUrl'; // Tambahkan https jika belum ada
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.link, color: Colors.blue, size: 26),
          const SizedBox(width: 10),
          Expanded(
            child: InkWell(
              onTap: () async {
                final Uri url = Uri.parse(validUrl);
                try {
                  // Coba launch langsung tanpa canLaunchUrl
                  bool launched = await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  );
                  if (!launched) {
                    // Jika gagal, tampilkan pesan
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Gagal membuka link surat")),
                    );
                  }
                } catch (e) {
                  // Tangani exception dan tampilkan detail error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Gagal membuka link surat: ${e.toString()}",
                      ),
                    ),
                  );
                }
              },
              child: Text(
                validUrl, // Tampilkan URL yang sudah divalidasi
                style: GoogleFonts.poppins(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy, color: Colors.grey),
            tooltip: "Salin link",
            onPressed: () async {
              await Clipboard.setData(
                ClipboardData(text: validUrl),
              ); // Salin URL yang sudah divalidasi
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Link surat disalin ke clipboard"),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
