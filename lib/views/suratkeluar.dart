import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manejemen_surat/views/keluar/createkeluar.dart';
import 'package:manejemen_surat/views/keluar/detail_suratkeluar.dart';

class SuratKeluar extends StatefulWidget {
  const SuratKeluar({super.key});

  @override
  State<SuratKeluar> createState() => _SuratKeluarState();
}

class _SuratKeluarState extends State<SuratKeluar> {
  String selectedTab = "Tersimpan";
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          const SizedBox(height: 16),
          _buildSearchBar(),
          const SizedBox(height: 12),
          _buildTabBar(),
          const SizedBox(height: 12),
          Expanded(child: _buildSuratList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade700,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => const TambahSuratKeluar(editData: {}, docId: ''),
            ),
          );
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // 🔹 SEARCH BAR
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: searchController,
          onChanged: (value) => setState(() => searchQuery = value),
          style: GoogleFonts.poppins(fontSize: 14),
          decoration: InputDecoration(
            hintText: "Cari surat berdasarkan nomor, tujuan, atau perihal...",
            hintStyle: GoogleFonts.poppins(color: Colors.grey.shade500),
            prefixIcon: const Icon(Icons.search, color: Colors.blue),
            suffixIcon:
                searchQuery.isNotEmpty
                    ? IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        searchController.clear();
                        setState(() => searchQuery = "");
                      },
                    )
                    : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  // 🔹 TAB NAVIGASI
  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Expanded(child: _buildTab("Tersimpan")),
            Expanded(child: _buildTab("Draft")),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String text) {
    bool isActive = selectedTab == text;
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () => setState(() => selectedTab = text),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue.shade700 : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: isActive ? Colors.white : Colors.grey.shade700,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // 🔹 DAFTAR SURAT
  Widget _buildSuratList() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection("surat_keluar")
              .orderBy("createdAt", descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final allDocs = snapshot.data!.docs;
        final filteredDocs =
            allDocs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final query = searchQuery.toLowerCase();

              final matchTab =
                  (selectedTab == "Draft" && data["isDraft"] == true) ||
                  (selectedTab == "Tersimpan" && data["isDraft"] == false);

              final matchSearch =
                  (data["nomor"] ?? "").toString().toLowerCase().contains(
                    query,
                  ) ||
                  (data["tujuan"] ?? "").toString().toLowerCase().contains(
                    query,
                  ) ||
                  (data["perihal"] ?? "").toString().toLowerCase().contains(
                    query,
                  );

              return matchTab && matchSearch;
            }).toList();

        if (filteredDocs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.mail_outline, size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 10),
                Text(
                  "Tidak ada surat ditemukan",
                  style: GoogleFonts.poppins(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // 🔹 Nomor urut dari bawah ke atas
        final total = filteredDocs.length;

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: total,
          itemBuilder: (context, index) {
            // index 0 di atas, jadi urutannya dibalik
            final doc = filteredDocs[index];
            final data = doc.data() as Map<String, dynamic>;

            // nomor urut dihitung dari bawah
            final nomorUrut = total - index;

            return _buildSuratCard(data, nomorUrut, doc.id);
          },
        );
      },
    );
  }

  // 🔹 KARTU SURAT
  Widget _buildSuratCard(
    Map<String, dynamic> data,
    int nomorUrut,
    String docId,
  ) {
    final isDraft = data["isDraft"] == true;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailSuratKeluar(surat: data, docId: docId),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔸 Nomor + tanggal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$nomorUrut. ${data['nomor'] ?? ''}",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 13,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        data['tanggalSurat'] ?? '',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Text(
                "Tujuan: ${data['tujuan'] ?? ''}",
                style: GoogleFonts.poppins(fontSize: 13),
              ),
              Text(
                "Perihal: ${data['perihal'] ?? ''}",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors:
                          isDraft
                              ? [Colors.orange.shade400, Colors.orange.shade600]
                              : [Colors.blue.shade400, Colors.blue.shade600],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isDraft ? Icons.edit : Icons.check_circle,
                        size: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isDraft ? "Draft" : "Tersimpan",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
