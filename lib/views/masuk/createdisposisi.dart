import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BuatDisposisiPage extends StatefulWidget {
  final String noSurat;

  const BuatDisposisiPage({super.key, required this.noSurat, required String idSurat});

  @override
  State<BuatDisposisiPage> createState() => _BuatDisposisiPageState();
}

class _BuatDisposisiPageState extends State<BuatDisposisiPage> {
  List<Map<String, dynamic>> penerimaList = [];
  Map<String, dynamic>? penerima;

  @override
  void initState() {
    super.initState();
    getPenerimaList();
  }

  Future<void> getPenerimaList() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').get();

      final List<Map<String, dynamic>> data =
          snapshot.docs
              .map((doc) {
                final user = doc.data() as Map<String, dynamic>;
                if (user['role'] == 'user') {
                  return {
                    'jabatan': user['jabatan'] ?? '',
                    'nama': user['nama'] ?? '',
                    'uid': doc.id,
                  };
                }
                return null;
              })
              .where((e) => e != null)
              .cast<Map<String, dynamic>>()
              .toList();

      setState(() {
        penerimaList = data;
      });
      print(
        'Penerima list loaded: ${penerimaList.length} items',
      ); // Logging untuk debug
    } catch (e) {
      print('Error loading penerima list: $e'); // Logging error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal memuat data penerima: $e")));
    }
  }

  Future<void> _simpanDisposisi() async {
    if (penerima == null) return;

    try {
      final col = FirebaseFirestore.instance.collection('disposisi');

      // Cek apakah surat sudah didisposisi oleh penerima yang sama
      final existingSnapshot =
          await col
              .where('nomor', isEqualTo: widget.noSurat)
              .where('penerima_uid', isEqualTo: penerima!['uid'])
              .limit(1)
              .get();

      if (existingSnapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Surat ini sudah didisposisi kepada penerima ini."),
          ),
        );
        return;
      }

      // Simpan disposisi baru
      await col.add({
        'nomor': widget.noSurat,
        'penerima_uid': penerima!['uid'],
        'nama': penerima!['nama'],
        'jabatan': penerima!['jabatan'],
        'created_at': FieldValue.serverTimestamp(),
      });

      // Update status surat_masuk
      final suratQuery =
          await FirebaseFirestore.instance
              .collection('surat_masuk')
              .where('nomor', isEqualTo: widget.noSurat)
              .limit(1)
              .get();

      if (suratQuery.docs.isNotEmpty) {
        final docRef = suratQuery.docs.first.reference;
        await docRef.update({'sudahDisposisi': true});
      }

      print('Disposisi saved for: ${penerima!['nama']}'); // Logging untuk debug
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Disposisi berhasil dikirim!")),
      );

      Navigator.pop(context);
    } catch (e) {
      print('Error saving disposisi: $e'); // Logging error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal menyimpan disposisi: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Buat Disposisi",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body:
          penerimaList.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pilih Penerima Disposisi",
                      style: GoogleFonts.poppins(),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: double.infinity,
                      child: DropdownButtonFormField<Map<String, dynamic>>(
                        isExpanded: true,
                        value: penerima,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                        ),
                        items:
                            penerimaList.map((item) {
                              return DropdownMenuItem<Map<String, dynamic>>(
                                value: item,
                                child: Text(
                                  "${item['jabatan']} - ${item['nama']}",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(fontSize: 14),
                                ),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            penerima = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
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
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          if (penerima == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Harap pilih penerima!"),
                              ),
                            );
                          } else {
                            _simpanDisposisi();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
