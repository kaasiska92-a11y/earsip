import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manejemen_surat/views/suratmasuk.dart';

class TambahSuratMasuk extends StatefulWidget {
  const TambahSuratMasuk({super.key});

  @override
  State<TambahSuratMasuk> createState() => _TambahSuratMasukState();
}

class _TambahSuratMasukState extends State<TambahSuratMasuk> {
  final TextEditingController nomorController = TextEditingController();
  final TextEditingController tanggalTerimaController = TextEditingController();
  final TextEditingController tanggalSuratController = TextEditingController();
  final TextEditingController pengirimController = TextEditingController();
  final TextEditingController perihalController = TextEditingController();
  final TextEditingController linkSuratController = TextEditingController();

  String statusSurat = "Belum Dibaca";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Text(
          "Tambah Surat Masuk",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // langsung kembali ke halaman SuratMasuk
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField("Nomor Surat", nomorController),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildDateField("Tanggal Terima", tanggalTerimaController),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDateField("Tanggal Surat", tanggalSuratController),
                ),
              ],
            ),
            const SizedBox(height: 12),

            _buildTextField("Asal Surat", pengirimController),
            const SizedBox(height: 12),
            _buildTextField("Perihal", perihalController),
            const SizedBox(height: 12),
            _buildTextField("Link Surat", linkSuratController),
            const SizedBox(height: 12),

            Text(
              "Status Surat",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Row(
              children: [
                Radio<String>(
                  value: "Belum Dibaca",
                  groupValue: statusSurat,
                  onChanged: (val) {
                    setState(() => statusSurat = val!);
                  },
                ),
                Text("Belum Dibaca", style: GoogleFonts.poppins()),
                Radio<String>(
                  value: "Sudah Dibaca",
                  groupValue: statusSurat,
                  onChanged: (val) {
                    setState(() => statusSurat = val!);
                  },
                ),
                Text("Sudah Dibaca", style: GoogleFonts.poppins()),
              ],
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final suratBaru = Surat(
                    nomor: nomorController.text,
                    asal: pengirimController.text,
                    perihal: perihalController.text,
                    sudahDisposisi: false,
                    sudahDibaca: statusSurat == "Sudah Dibaca",
                  );

                  Navigator.pop(context, suratBaru);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Surat masuk berhasil disimpan")),
                  );
                },
                icon: const Icon(Icons.save),
                label: Text(
                  "Simpan Surat Masuk",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: GoogleFonts.poppins(),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true,
      style: GoogleFonts.poppins(),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(),
        suffixIcon: const Icon(Icons.calendar_today),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          controller.text =
              "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
        }
      },
    );
  }
}
