import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Import model dan halaman lain
import 'package:manejemen_surat/models/surat.dart';
import 'package:manejemen_surat/views/masuk/create.dart';
import 'package:manejemen_surat/views/masuk/detail_surat.dart';

class SuratMasuk extends StatefulWidget {
  const SuratMasuk({super.key});

  @override
  State<SuratMasuk> createState() => _SuratMasukState();
}

class _SuratMasukState extends State<SuratMasuk> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          const SizedBox(height: 16),
          _buildSearchBar(),
          const SizedBox(height: 8),
          Expanded(child: _buildSemuaSurat()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TambahSuratMasuk(noUrut: null),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // 🔹 Search Bar (Versi Desain Baru)
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          controller: searchController,
          onChanged: (value) => setState(() => searchQuery = value),
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
          decoration: InputDecoration(
            hintText: "🔍  Cari surat berdasarkan nomor, asal, atau perihal...",
            hintStyle: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey[500],
            ),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Container(
              margin: const EdgeInsets.only(left: 12, right: 4),
              child: const Icon(Icons.search_rounded, color: Colors.blueAccent),
            ),
            suffixIcon:
                searchQuery.isNotEmpty
                    ? IconButton(
                      icon: const Icon(Icons.clear_rounded, color: Colors.grey),
                      onPressed: () {
                        searchController.clear();
                        setState(() => searchQuery = "");
                      },
                    )
                    : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.blue.shade100, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.blue, width: 1.8),
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 StreamBuilder daftar surat
  Widget _buildSemuaSurat() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('surat_masuk')
              .orderBy('created_at')
              .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Belum ada surat masuk"));
        }

        // 🔍 Filter pencarian
        final docs =
            snapshot.data!.docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final query = searchQuery.toLowerCase();
              return (data['nomor'] ?? '').toString().toLowerCase().contains(
                    query,
                  ) ||
                  (data['asal'] ?? '').toString().toLowerCase().contains(
                    query,
                  ) ||
                  (data['perihal'] ?? '').toString().toLowerCase().contains(
                    query,
                  );
            }).toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final surat = docs[docs.length - 1 - index];
            final data = surat.data() as Map<String, dynamic>;
            final suratModel = Surat.fromFirestore(surat);

            final nomorTetap = data['no_urut'] ?? '-';
            final isRead = data['sudahDibaca'] ?? false;
            final sudahDisposisi = data['sudahDisposisi'] ?? false;
            final tanggalTerima = data['tanggal_penerimaan'] ?? '-';

            return Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Stack(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      surat.reference.update({'sudahDibaca': true});
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailSurat(surat: suratModel),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🔹 Baris atas
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "$nomorTetap. ${data['nomor'] ?? '-'}",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),

                              // 🔹 Tombol aksi (hapus + batal)
                              IconButton(
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    builder:
                                        (_) => Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Aksi Surat",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              ListTile(
                                                leading: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                title: Text(
                                                  "Hapus Surat",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                onTap: () async {
                                                  Navigator.pop(context);
                                                  final confirm = await showDialog<
                                                    bool
                                                  >(
                                                    context: context,
                                                    builder:
                                                        (_) => AlertDialog(
                                                          title: const Text(
                                                            "Konfirmasi Hapus",
                                                          ),
                                                          content: const Text(
                                                            "Apakah Anda yakin ingin menghapus surat ini?",
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed:
                                                                  () =>
                                                                      Navigator.pop(
                                                                        context,
                                                                        false,
                                                                      ),
                                                              child: const Text(
                                                                "Batal",
                                                              ),
                                                            ),
                                                            ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor:
                                                                    Colors.red,
                                                              ),
                                                              onPressed:
                                                                  () =>
                                                                      Navigator.pop(
                                                                        context,
                                                                        true,
                                                                      ),
                                                              child: const Text(
                                                                "Hapus",
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                  );

                                                  if (confirm == true) {
                                                    await surat.reference
                                                        .delete();
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          "Surat berhasil dihapus",
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                              ListTile(
                                                leading: const Icon(
                                                  Icons.close,
                                                  color: Colors.grey,
                                                ),
                                                title: Text(
                                                  "Batal",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                onTap:
                                                    () =>
                                                        Navigator.pop(context),
                                              ),
                                            ],
                                          ),
                                        ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          Text(
                            data['asal'] ?? '',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),

                          Text(
                            data['perihal'] ?? '',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 4),

                          Text(
                            "Tanggal Penerimaan: $tanggalTerima",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),

                          // 🔹 Status disposisi
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color:
                                    sudahDisposisi
                                        ? Colors.orange
                                        : Colors.blue,
                                width: 1.2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              sudahDisposisi
                                  ? "Sudah Disposisi"
                                  : "Belum Disposisi",
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color:
                                    sudahDisposisi
                                        ? Colors.orange
                                        : Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 🔹 Label status baca
                  Positioned(
                    top: 8,
                    right: 48,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: isRead ? Colors.grey : Colors.green,
                          width: 1.2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isRead ? "Sudah Dibaca" : "Baru",
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isRead ? Colors.grey : Colors.green,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
