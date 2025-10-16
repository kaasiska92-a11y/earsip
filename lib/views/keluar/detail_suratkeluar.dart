import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailSuratKeluar extends StatelessWidget {
  final Map<String, dynamic> surat;

  const DetailSuratKeluar({
    super.key,
    required this.surat,
    required String docId,
  });

  @override
  Widget build(BuildContext context) {
    final status = surat['status'] ?? "";

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
                buildInputCard("Nomor Surat", surat['nomor']),
                const SizedBox(height: 12),
                buildInputCard("Tanggal Surat", surat['tanggalSurat']),
                const SizedBox(height: 12),
                buildInputCard("Tujuan", surat['tujuan']),
                const SizedBox(height: 12),
                buildInputCard("Perihal", surat['perihal']),
                const SizedBox(height: 12),

                if (surat['link_surat'] != null && surat['link_surat'] != "")
                  buildLinkSuratCard(context, surat['link_surat']),

                const SizedBox(height: 16),

                // Hanya tampilkan card status jika Draft atau Terkirim
                if (status == "Draft" || status == "Terkirim")
                  buildStatusCard(context, status),

                const SizedBox(height: 100),
              ],
            ),
          ),

          // Tombol bawah hanya untuk Draft atau Terkirim
          if (status == "Draft" || status == "Terkirim")
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (status == "Terkirim") {
                    _showArsipkanModal(context);
                  } else if (status == "Draft") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Klik untuk edit draft")),
                    );
                  }
                },
                icon: Icon(
                  status == "Draft" ? Icons.edit : Icons.archive,
                  color: Colors.white,
                ),
                label: Text(
                  status == "Draft" ? "Edit" : "Arsipkan",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

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
          Text(
            title,
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700]),
          ),
          const SizedBox(height: 6),
          Text(
            value ?? "-",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatusCard(BuildContext context, String status) {
    Color bgColor = Colors.blue.shade50;
    Color iconColor = Colors.green;

    if (status == "Draft") {
      bgColor = Colors.green.shade100;
      iconColor = Colors.green;
    }

    return InkWell(
      onTap:
          status == "Draft"
              ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Klik untuk edit draft")),
                );
              }
              : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: bgColor.withOpacity(0.7)),
        ),
        child: Row(
          children: [
            Icon(Icons.mark_email_unread, color: iconColor),
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
      ),
    );
  }

  Widget buildLinkSuratCard(BuildContext context, String linkSurat) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.link, color: Colors.blue, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap: () async {
                final Uri url = Uri.parse(linkSurat);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Gagal membuka link surat")),
                  );
                }
              },
              child: Text(
                linkSurat,
                style: GoogleFonts.poppins(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showArsipkanModal(BuildContext context) {
    String? selectedKategori;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Arsipkan Surat",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Kategori",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...["Anggaran", "Rekomendasi", "Laporan", "Undangan"].map((
                    kategori,
                  ) {
                    final isSelected = selectedKategori == kategori;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedKategori = kategori;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? Colors.blue.shade100
                                    : Colors.white,
                            border: Border.all(
                              color:
                                  isSelected
                                      ? Colors.blue
                                      : Colors.grey.shade300,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            kategori,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: isSelected ? Colors.blue : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed:
                          selectedKategori == null
                              ? null
                              : () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Surat berhasil diarsipkan ke $selectedKategori",
                                    ),
                                  ),
                                );
                              },
                      icon: const Icon(Icons.save),
                      label: Text(
                        "Simpan Arsip",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        disabledBackgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
