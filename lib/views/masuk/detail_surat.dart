import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manejemen_surat/views/masuk/disposisi_surat_masuk.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailSurat extends StatelessWidget {
  const DetailSurat({super.key});

  Future<void> _openPdfLink(BuildContext context) async {
    const url = "https://drive.google.com/file/d/1aBcD3EfGhIJkLMnoPqrStUVWxyz/view?usp=sharing";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal membuka dokumen")),
      );
    }
  }

  void _showArsipkanBottomSheet(BuildContext context) {
    String? selectedCategory;

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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Arsipkan Surat",
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text("Kategori",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, fontSize: 14)),

                  const SizedBox(height: 8),
                  // Pilihan kategori
                  ...["Anggaran", "Rekomendasi", "Laporan", "Undangan"]
                      .map((kategori) => GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCategory = kategori;
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: selectedCategory == kategori
                                    ? Colors.blue.shade50
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: selectedCategory == kategori
                                      ? Colors.blue
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Text(
                                kategori,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: selectedCategory == kategori
                                      ? Colors.blue
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ))
                      .toList(),

                  const SizedBox(height: 20),
                  // Tombol Simpan
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: selectedCategory == null
                          ? null
                          : () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Surat berhasil diarsipkan ke kategori $selectedCategory",
                                    style: GoogleFonts.poppins(),
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: Text(
                        "Simpan Arsip",
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          bottom: TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            tabs: const [
              Tab(text: "Detail"),
              Tab(text: "Riwayat Surat"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // ================== TAB DETAIL ===================
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Detail Surat
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow("Nomor Surat", "001/DPRD/III/2025"),
                        _buildDetailRow("Tanggal Terima", "22 Agustus 2025"),
                        _buildDetailRow("Tanggal Surat", "20 Agustus 2025"),
                        _buildDetailRow(
                            "Asal Surat", "Dinas Pendidikan Kota Palembang"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Perihal
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Perihal",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500, fontSize: 14)),
                        const SizedBox(height: 8),
                        Text("Permohonan Anggaran Pembangunan Sekolah",
                            style: GoogleFonts.poppins(fontSize: 14)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Lampiran
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        const Icon(Icons.picture_as_pdf,
                            color: Colors.red, size: 30),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _openPdfLink(context),
                            child: Text(
                              "Proposal_Anggaran_Sekolah.pdf",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Tombol Aksi
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            _showArsipkanBottomSheet(context);
                          },
                          icon: const Icon(Icons.archive),
                          label: Text("Arsipkan",
                              style: GoogleFonts.poppins(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const BuatDisposisiPage(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.send),
                          label: Text("Disposisi",
                              style: GoogleFonts.poppins(color: Colors.white)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            // ================== TAB RIWAYAT DISPOSISI ===================
            Center(
              child: Text(
                "Belum ada riwayat disposisi",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.w500)),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.right,
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}