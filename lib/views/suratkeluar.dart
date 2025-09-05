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
  String selectedTab = "Semua";
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  final List<Map<String, dynamic>> suratList = [
    {
      "no": "001/DPRD/III/2025",
      "tujuan": "Dinas Pendidikan Kota Palembang",
      "perihal": "Tanggapan Permohonan Anggaran Pembangunan Sekolah",
      "tanggal": "24 Agustus 2025",
      "status": "Terkirim",
      "sudahDibaca": false,
    },

  ];

  @override
  Widget build(BuildContext context) {
    // Filter data sesuai tab & pencarian
    List<Map<String, dynamic>> filteredSurat = suratList.where((s) {
      final matchTab = selectedTab == "Semua" || s["status"] == selectedTab;
      final query = searchQuery.toLowerCase();
      final matchSearch = s["no"].toString().toLowerCase().contains(query) ||
          s["tujuan"].toString().toLowerCase().contains(query) ||
          s["perihal"].toString().toLowerCase().contains(query);
      return matchTab && matchSearch;
    }).toList();

    // Hitung jumlah surat belum dibaca
    final int unreadCount =
        suratList.where((s) => s['sudahDibaca'] == false).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Surat Keluar",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            // Notifikasi jumlah surat baru
            Stack(
              children: [
                const Icon(Icons.notifications, size: 26, color: Colors.white),
                if (unreadCount > 0)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          // 🔍 Search bar
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(1, 2),
                ),
              ],
            ),
            child: TextField(
              controller: searchController,
              style: GoogleFonts.poppins(fontSize: 14),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Cari nomor, tujuan, atau perihal...",
                hintStyle: GoogleFonts.poppins(color: Colors.grey),
                icon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          searchController.clear();
                          setState(() {
                            searchQuery = "";
                          });
                        },
                      )
                    : null,
              ),
            ),
          ),

          // 🔖 Tab filter
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTab("Semua"),
                _buildTab("Draft"),
                _buildTab("Terkirim"),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 📋 List Surat
          Expanded(
            child: filteredSurat.isEmpty
                ? Center(
                    child: Text(
                      "Tidak ada surat ditemukan",
                      style: GoogleFonts.poppins(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: filteredSurat.length,
                    itemBuilder: (context, index) {
                      final surat = filteredSurat[index];
                      final noOtomatis = (index + 1).toString();

                      return InkWell(
                        onTap: () {
                          setState(() {
                            surat['sudahDibaca'] = true;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailSuratKeluar(surat: surat),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Nomor + tanggal
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "$noOtomatis. ${surat['no']}",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        if (!surat['sudahDibaca'])
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Text(
                                              "Baru",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    Text(
                                      surat['tanggal'],
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 6),

                                // Tujuan + Perihal
                                Text(
                                  "Tujuan: ${surat['tujuan']}",
                                  style: GoogleFonts.poppins(fontSize: 13),
                                ),
                                Text(
                                  "Perihal: ${surat['perihal']}",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // Icon Action + Status
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        _buildActionIcon(
                                          icon: Icons.remove_red_eye,
                                          color: Colors.blue,
                                          bgColor: const Color(0xFFE3F2FD),
                                          onTap: () {
                                            setState(() {
                                              surat['sudahDibaca'] = true;
                                            });
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailSuratKeluar(
                                                        surat: surat),
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(width: 8),
                                        _buildActionIcon(
                                          icon: Icons.download,
                                          color: Colors.green,
                                          bgColor: const Color(0xFFE8F5E9),
                                          onTap: () {
                                            // TODO: aksi download surat
                                          },
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: surat['status'] == "Terkirim"
                                            ? Colors.green.shade100
                                            : Colors.orange.shade100,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        surat['status'],
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: surat['status'] == "Terkirim"
                                              ? Colors.green
                                              : Colors.orange,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // ➕ Tombol tambah surat keluar
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TambahSuratKeluar(),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // 🔖 Widget Tab
  Widget _buildTab(String text) {
    bool isActive = selectedTab == text;
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () {
        setState(() {
          selectedTab = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: isActive ? Colors.blue : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // 🎯 Widget Icon Action
  Widget _buildActionIcon({
    required IconData icon,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: IconButton(
        icon: Icon(icon, size: 20, color: color),
        onPressed: onTap,
      ),
    );
  }
}
