import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manejemen_surat/views/masuk/create.dart';
import 'package:manejemen_surat/views/masuk/detail_surat.dart';

class Surat {
  final String nomor;
  final String asal;
  final String perihal;
  bool sudahDisposisi;
  bool sudahDibaca;

  Surat({
    required this.nomor,
    required this.asal,
    required this.perihal,
    this.sudahDisposisi = false,
    this.sudahDibaca = false,
  });
}

class SuratMasuk extends StatefulWidget {
  const SuratMasuk({super.key});

  @override
  State<SuratMasuk> createState() => _SuratMasukState();
}

class _SuratMasukState extends State<SuratMasuk> {
  int selectedTab = 0; // 0 = Semua, 1 = Disposisi
  TextEditingController searchController = TextEditingController();

  // contoh data
  final List<Surat> semuaSurat = [
    Surat(
      nomor: "001/DPRD/III/2025",
      asal: "Dinas Pendidikan Kota Palembang",
      perihal: "Permohonan Anggaran Pembangunan Sekolah",
      sudahDisposisi: false,
      sudahDibaca: false,
    ),
  ];

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    // filter sesuai tab + pencarian
    List<Surat> suratFiltered = semuaSurat.where((s) {
      final query = searchQuery.toLowerCase();
      final cocok = s.nomor.toLowerCase().contains(query) ||
          s.asal.toLowerCase().contains(query) ||
          s.perihal.toLowerCase().contains(query);

      if (selectedTab == 0) {
        return cocok;
      } else {
        return cocok && s.sudahDisposisi && s.sudahDibaca;
      }
    }).toList();

    // hitung jumlah surat belum dibaca
    int unreadCount = semuaSurat.where((s) => !s.sudahDibaca).length;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TambahSuratMasuk()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // HEADER
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul + Notifikasi
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Surat Masuk",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Stack(
                      children: [
                        const Icon(Icons.notifications,
                            size: 28, color: Colors.white),
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
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Search bar
                TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Cari nomor, asal, atau perihal surat...",
                    hintStyle: GoogleFonts.poppins(fontSize: 13),
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // TAB
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: Text("Semua", style: GoogleFonts.poppins()),
                      selected: selectedTab == 0,
                      onSelected: (_) {
                        setState(() => selectedTab = 0);
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: Text("Disposisi", style: GoogleFonts.poppins()),
                      selected: selectedTab == 1,
                      onSelected: (_) {
                        setState(() => selectedTab = 1);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // LIST SURAT
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: suratFiltered.length,
              itemBuilder: (context, index) {
                final surat = suratFiltered[index];
                final isRead = surat.sudahDibaca;

                return InkWell(
                  onTap: () {
                    setState(() {
                      surat.sudahDibaca = true; // tandai sudah dibaca
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailSurat(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: isRead ? Colors.grey[100] : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 6,
                          offset: const Offset(2, 3),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nomor surat + unread marker
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${index + 1}. ${surat.nomor}",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              if (!surat.sudahDibaca)
                                const Icon(Icons.circle,
                                    color: Colors.red, size: 10),
                            ],
                          ),
                          const SizedBox(height: 6),

                          // Asal surat
                          Text(
                            surat.asal,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 2),

                          // Perihal
                          Text(
                            surat.perihal,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // ACTION ICONS
                          Row(
                            children: [
                              Icon(Icons.visibility,
                                  size: 18, color: Colors.blue.shade600),
                              const SizedBox(width: 12),
                              Icon(Icons.reply,
                                  size: 18, color: Colors.orange.shade600),
                              const SizedBox(width: 12),
                              Icon(Icons.download,
                                  size: 18, color: Colors.green.shade600),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // STATUS
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: surat.sudahDisposisi
                                      ? Colors.green[100]
                                      : Colors.orange[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  surat.sudahDisposisi
                                      ? "Sudah Disposisi"
                                      : "Belum Disposisi",
                                  style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: surat.sudahDibaca
                                      ? Colors.green[100]
                                      : Colors.red[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  surat.sudahDibaca
                                      ? "Sudah Dibaca"
                                      : "Belum Dibaca",
                                  style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
