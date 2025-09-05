import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TambahSuratKeluar extends StatefulWidget {
  const TambahSuratKeluar({super.key});

  @override
  State<TambahSuratKeluar> createState() => _TambahSuratKeluarState();
}

class _TambahSuratKeluarState extends State<TambahSuratKeluar> {
  final TextEditingController nomorController = TextEditingController();
  final TextEditingController tujuanController = TextEditingController();
  final TextEditingController perihalController = TextEditingController();
  final TextEditingController lampiranController = TextEditingController();

  DateTime? tanggalSurat;
  String statusSurat = "Belum Dibaca";

  Future<void> _pilihTanggal(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != tanggalSurat) {
      setState(() {
        tanggalSurat = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F2F9),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          "Tambah Surat Keluar",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Nomor Surat
            Text("Nomor Surat", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              controller: nomorController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),

            // Tanggal Surat
            Text("Tanggal Surat", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _pilihTanggal(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tanggalSurat != null
                          ? "${tanggalSurat!.day}-${tanggalSurat!.month}-${tanggalSurat!.year}"
                          : "Pilih Tanggal",
                      style: GoogleFonts.poppins(),
                    ),
                    const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tujuan
            Text("Tujuan", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              controller: tujuanController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),

            // Perihal
            Text("Perihal", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              controller: perihalController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),

            // Lampiran
            Text("Lampiran Pdf", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              controller: lampiranController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),

            // Status Surat
            Text("Status Surat", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Radio(
                    value: "Belum Dibaca",
                    groupValue: statusSurat,
                    onChanged: (value) {
                      setState(() {
                        statusSurat = value.toString();
                      });
                    },
                  ),
                  Text("Belum Dibaca", style: GoogleFonts.poppins()),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Draf & Simpan
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // aksi simpan ke draft
                    },
                    icon: const Icon(Icons.save_as, color: Colors.white),
                    label: Text("Draf", style: GoogleFonts.poppins()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // aksi simpan data
                    },
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: Text("Simpan", style: GoogleFonts.poppins()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
}