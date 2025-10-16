import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TambahSuratMasuk extends StatefulWidget {
  final int? noUrut; // ✅ tambah properti opsional

  const TambahSuratMasuk({super.key, this.noUrut}); // ✅ ubah jadi opsional

  @override
  State<TambahSuratMasuk> createState() => _TambahSuratMasukState();
}

class _TambahSuratMasukState extends State<TambahSuratMasuk> {
  final TextEditingController nomorController = TextEditingController();
  final TextEditingController tanggalPenerimaanController =
      TextEditingController();
  final TextEditingController tanggalSuratController = TextEditingController();
  final TextEditingController pengirimController = TextEditingController();
  final TextEditingController perihalController = TextEditingController();
  final TextEditingController lampiranSuratController = TextEditingController();

  String? sifatSurat;

  final List<String> sifatOptions = [
    "Biasa",
    "Rahasia",
    "Penting",
    "Sangat Penting",
  ];

  final Color primaryColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: primaryColor,
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField("No Surat", nomorController),
            const SizedBox(height: 12),
            _buildDropdownField("Sifat Surat", sifatOptions, sifatSurat, (
              value,
            ) {
              setState(() => sifatSurat = value);
            }),
            const SizedBox(height: 12),
            _buildDateField("Tgl Terima", tanggalPenerimaanController),
            const SizedBox(height: 12),
            _buildDateField("Tgl Surat", tanggalSuratController),
            const SizedBox(height: 12),
            _buildTextField("Asal Surat", pengirimController),
            const SizedBox(height: 12),
            _buildTextField("Perihal", perihalController, maxLines: 4),
            const SizedBox(height: 12),
            _buildTextField("Link File", lampiranSuratController),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _simpanSurat,
                icon: const Icon(Icons.save, color: Colors.white),
                label: Text(
                  "Simpan Surat Masuk",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  elevation: 5,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        cursorColor: primaryColor,
        style: GoogleFonts.poppins(),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(),
          floatingLabelStyle: TextStyle(color: primaryColor),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    List<String> options,
    String? value,
    Function(String?) onChanged,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(),
          floatingLabelStyle: TextStyle(color: primaryColor),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        items:
            options
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e, style: GoogleFonts.poppins()),
                  ),
                )
                .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        readOnly: true,
        cursorColor: primaryColor,
        style: GoogleFonts.poppins(),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(),
          floatingLabelStyle: TextStyle(color: primaryColor),
          suffixIcon: Icon(Icons.calendar_today, color: primaryColor),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: primaryColor,
                    onPrimary: Colors.white,
                    onSurface: Colors.black,
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(foregroundColor: primaryColor),
                  ),
                ),
                child: child!,
              );
            },
          );
          if (pickedDate != null) {
            controller.text =
                "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
          }
        },
      ),
    );
  }

  Future<void> _simpanSurat() async {
    if (nomorController.text.isEmpty ||
        sifatSurat == null ||
        tanggalPenerimaanController.text.isEmpty ||
        tanggalSuratController.text.isEmpty ||
        pengirimController.text.isEmpty ||
        perihalController.text.isEmpty ||
        lampiranSuratController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠️ Semua field harus diisi sebelum menyimpan!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // ✅ Ambil no_urut terakhir dari Firestore
      final snapshot =
          await FirebaseFirestore.instance
              .collection("surat_masuk")
              .orderBy("no_urut", descending: true)
              .limit(1)
              .get();

      int nextNoUrut = 1;
      if (snapshot.docs.isNotEmpty) {
        final lastData = snapshot.docs.first.data();
        nextNoUrut = (lastData['no_urut'] ?? 0) + 1;
      }

      await FirebaseFirestore.instance.collection("surat_masuk").add({
        "no_urut": nextNoUrut,
        "nomor": nomorController.text,
        "tanggal_penerimaan": tanggalPenerimaanController.text,
        "tanggal_surat": tanggalSuratController.text,
        "asal": pengirimController.text,
        "perihal": perihalController.text,
        "lampiran_surat": lampiranSuratController.text,
        "sifat": sifatSurat,
        "sudah_disposisi": false,
        "sudah_dibaca": false,
        "created_at": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Surat masuk berhasil disimpan"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Gagal menyimpan: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
