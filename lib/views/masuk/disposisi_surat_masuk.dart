import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuatDisposisiPage extends StatefulWidget {
  const BuatDisposisiPage({super.key});

  @override
  State<BuatDisposisiPage> createState() => _BuatDisposisiPageState();
}

class _BuatDisposisiPageState extends State<BuatDisposisiPage> {
  // Data dropdown
  final List<String> penerimaList = [
    "Ketua DPRD",
    "Wakil Ketua",
    "Sekretaris DPRD",
    "Komisi I",
    "Komisi II",
    "Komisi III",
    "Komisi IV",
  ];

  final List<String> sifatSuratList = [
    "Biasa",
    "Penting",
    "Segera",
    "Rahasia",
  ];

  // Controller
  String? penerima;
  String? sifatSurat;
  DateTime? batasWaktu;
  final TextEditingController instruksiController = TextEditingController();

  // Date Picker
  Future<void> _pilihTanggal(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != batasWaktu) {
      setState(() {
        batasWaktu = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          "Buat Disposisi",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Penerima
            Text("Penerima Disposisi", style: GoogleFonts.poppins()),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: penerima,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              items: penerimaList
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  penerima = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Sifat Surat
            Text("Sifat Surat", style: GoogleFonts.poppins()),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: sifatSurat,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              items: sifatSuratList
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  sifatSurat = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Instruksi
            Text("Instruksi", style: GoogleFonts.poppins()),
            const SizedBox(height: 6),
            TextField(
              controller: instruksiController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Tulis instruksi untuk penerima...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            // Batas Waktu
            Text("Batas Waktu", style: GoogleFonts.poppins()),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () => _pilihTanggal(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  batasWaktu != null
                      ? "${batasWaktu!.day}-${batasWaktu!.month}-${batasWaktu!.year}"
                      : "Pilih tanggal",
                  style: GoogleFonts.poppins(
                    color: batasWaktu == null ? Colors.grey : Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Tombol
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
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  if (penerima == null ||
                      sifatSurat == null ||
                      batasWaktu == null ||
                      instruksiController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Harap lengkapi semua field!")),
                    );
                  } else {
                    // Simpan disposisi
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Disposisi berhasil dikirim!")),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
