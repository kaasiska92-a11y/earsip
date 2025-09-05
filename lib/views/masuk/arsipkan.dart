import 'package:flutter/material.dart';

class Arsipkan extends StatefulWidget {
  final Map<String, dynamic>? suratBaru; // terima data baru

  const Arsipkan({super.key, this.suratBaru});

  @override
  State<Arsipkan> createState() => _ArsipkanState();
}

class _ArsipkanState extends State<Arsipkan> {
  int? selectedKategori;
  int selectedTab = 0;

  final List<Map<String, dynamic>> kategori = [
    {"label": "Anggaran", "icon": Icons.folder, "color": Colors.blue},
    {"label": "Laporan", "icon": Icons.folder, "color": Colors.green},
    {"label": "Rekomendasi", "icon": Icons.folder, "color": Colors.purple},
    {"label": "Undangan", "icon": Icons.folder, "color": Colors.orange},
  ];

  final List<Map<String, dynamic>> suratList = [];

  @override
  void initState() {
    super.initState();
    if (widget.suratBaru != null) {
      suratList.add(widget.suratBaru!); // masukkan surat baru
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Arsipkan",
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: "Cari dokumen arsip...",
                hintStyle: const TextStyle(fontFamily: "Poppins"),
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Kategori
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: kategori.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.1,
              ),
              itemBuilder: (context, index) {
                final item = kategori[index];
                final bool isSelected = selectedKategori == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedKategori = isSelected ? null : index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            isSelected ? Colors.deepPurple : Colors.grey[300]!,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item["icon"], color: item["color"], size: 28),
                        const SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["label"],
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "${suratList.where((s) => s["kategori"] == item["label"]).length} dokumen",
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Tab Filter
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildTabButton("Semua", 0),
                buildTabButton("Masuk", 1),
                buildTabButton("Keluar", 2),
              ],
            ),
            const SizedBox(height: 20),

            // Daftar Surat
            Column(
              children: suratList
                  .where((surat) =>
                      (selectedKategori == null ||
                          surat["kategori"] ==
                              kategori[selectedKategori!]["label"]) &&
                      (selectedTab == 0 ||
                          surat["tipe"] ==
                              (selectedTab == 1 ? "Masuk" : "Keluar")))
                  .map((surat) => buildSuratCard(surat))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Tombol Tab
  Widget buildTabButton(String text, int index) {
    final bool isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  // Kartu Surat
  Widget buildSuratCard(Map<String, dynamic> surat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nomor surat + tipe + tanggal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                surat["nomor"],
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      surat["tipe"],
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    surat["tanggal"],
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Instansi
          Text(
            surat["instansi"],
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 13,
            ),
          ),

          // Perihal
          Text(
            surat["perihal"],
            style: const TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 10),

          // Kategori + Status + Hapus
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.purple[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      surat["kategori"],
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      surat["status"],
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    suratList.remove(surat);
                  });
                },
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}