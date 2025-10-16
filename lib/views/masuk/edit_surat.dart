import 'package:flutter/material.dart';
import 'package:manejemen_surat/models/surat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditSuratMasuk extends StatefulWidget {
  final Surat surat;

  const EditSuratMasuk({super.key, required this.surat,});

  @override
  State<EditSuratMasuk> createState() => _EditSuratMasukState();
}

class _EditSuratMasukState extends State<EditSuratMasuk> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nomorController;
  late TextEditingController asalController;
  late TextEditingController perihalController;
  late TextEditingController tanggalSuratController;
  late TextEditingController tanggalTerimaController;
  late TextEditingController lampiranController;

  @override
  void initState() {
    super.initState();
    nomorController = TextEditingController(text: widget.surat.nomor);
    asalController = TextEditingController(text: widget.surat.asal);
    perihalController = TextEditingController(text: widget.surat.perihal);
    tanggalSuratController = TextEditingController(
      text: widget.surat.tanggalSurat,
    );
    tanggalTerimaController = TextEditingController(
      text: widget.surat.tanggal_penerimaan,
    );
    lampiranController = TextEditingController(
      text: widget.surat.lampiranSurat ?? '',
    );
  }

  Future<void> _updateSurat() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await FirebaseFirestore.instance
          .collection('surat_masuk')
          .doc(widget.surat.id)
          .update({
            'nomor': nomorController.text.trim(),
            'asal': asalController.text.trim(),
            'perihal': perihalController.text.trim(),
            'tanggal_surat': tanggalSuratController.text.trim(),
            'tanggal_penerimaan': tanggalTerimaController.text.trim(),
            'lampiran_surat': lampiranController.text.trim(),
            'updated_at': FieldValue.serverTimestamp(),
          });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Surat berhasil diperbarui')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Gagal memperbarui surat: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Surat Masuk"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildField("Nomor Surat", nomorController),
              _buildField("Asal Surat", asalController),
              _buildField("Perihal", perihalController, maxLines: 2),
              _buildField("Tanggal Surat", tanggalSuratController),
              _buildField("Tanggal Penerimaan", tanggalTerimaController),
              _buildField("Lampiran (Link PDF)", lampiranController),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _updateSurat,
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text("Simpan Perubahan"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator:
            (val) => val == null || val.isEmpty ? "Tidak boleh kosong" : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
