import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailSuratKeluarDraft extends StatefulWidget {
  final Map<String, dynamic> surat;
  final String docId;

  const DetailSuratKeluarDraft({
    super.key,
    required this.surat,
    required this.docId,
  });

  @override
  State<DetailSuratKeluarDraft> createState() => _DetailSuratKeluarDraftState();
}

class _DetailSuratKeluarDraftState extends State<DetailSuratKeluarDraft> {
  late TextEditingController nomorController;
  late TextEditingController tujuanController;
  late TextEditingController perihalController;
  late TextEditingController tanggalController;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    nomorController = TextEditingController(text: widget.surat['nomor'] ?? '');
    tujuanController = TextEditingController(
      text: widget.surat['tujuan'] ?? '',
    );
    perihalController = TextEditingController(
      text: widget.surat['perihal'] ?? '',
    );
    tanggalController = TextEditingController(
      text: widget.surat['tanggalSurat'] ?? '',
    );
  }

  @override
  void dispose() {
    nomorController.dispose();
    tujuanController.dispose();
    perihalController.dispose();
    tanggalController.dispose();
    super.dispose();
  }

  Future<void> _simpanPerubahan() async {
    setState(() => isSaving = true);

    await FirebaseFirestore.instance
        .collection('surat_keluar')
        .doc(widget.docId)
        .update({
          'nomor': nomorController.text.trim(),
          'tujuan': tujuanController.text.trim(),
          'perihal': perihalController.text.trim(),
          'tanggalSurat': tanggalController.text.trim(),
          'isDraft': false, // ✅ otomatis jadi tersimpan
          'updatedAt': FieldValue.serverTimestamp(),
        });

    setState(() => isSaving = false);

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Surat berhasil disimpan")));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Detail Draft Surat"),
        backgroundColor: Colors.blue.shade700,
        actions: [
          if (!isSaving)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _simpanPerubahan,
            ),
        ],
      ),
      body:
          isSaving
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildField("Nomor Surat", nomorController),
                      _buildField("Tujuan Surat", tujuanController),
                      _buildField("Perihal", perihalController),
                      _buildField("Tanggal Surat", tanggalController),
                      const SizedBox(height: 24),
                      _buildButtonSimpan(),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.grey.shade700,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: const Color(0xFFF9FBFD),
        ),
      ),
    );
  }

  Widget _buildButtonSimpan() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.save, color: Colors.white),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade700,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _simpanPerubahan,
        label: Text(
          "Simpan Surat",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
