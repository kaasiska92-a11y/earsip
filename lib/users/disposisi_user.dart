import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manejemen_surat/users/detaildisposisi.user.dart';

class DisposisiUser extends StatefulWidget {
  const DisposisiUser({
    super.key,
    required String namaUser,
    required String jabatanUser,
  });

  @override
  State<DisposisiUser> createState() => _DisposisiUserState();
}

class _DisposisiUserState extends State<DisposisiUser> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  bool showAntrian = true; // Tab aktif
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: Column(
        children: [
          const SizedBox(height: 12),
          _buildSearchBar(),
          const SizedBox(height: 10),
          _buildTabBar(),
          const SizedBox(height: 8),
          Expanded(child: _buildDisposisiList()),
        ],
      ),
    );
  }

  // 🔹 Search Bar
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: searchController,
        onChanged: (value) => setState(() => searchQuery = value),
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
        decoration: InputDecoration(
          hintText: "Cari disposisi berdasarkan nomor, asal, atau perihal...",
          hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[500]),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Colors.blueAccent,
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
    );
  }

  // 🔹 Tab Antrian & History
  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _tabButton("Antrian", showAntrian),
          const SizedBox(width: 10),
          _tabButton("History", !showAntrian),
        ],
      ),
    );
  }

  Widget _tabButton(String text, bool active) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => showAntrian = (text == "Antrian")),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? Colors.blue : Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.blue, width: 1.5),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: active ? Colors.white : Colors.blue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Daftar Disposisi
  Widget _buildDisposisiList() {
    final disposisiStream =
        FirebaseFirestore.instance
            .collection('disposisi')
            .where('penerima_uid', isEqualTo: currentUserId)
            .orderBy('created_at', descending: true)
            .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: disposisiStream,
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(child: Text("Error: ${snapshot.error}"));
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

        final docs =
            snapshot.data!.docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final riwayat = List.from(data['riwayat'] ?? []);
              final sudahDikerjakanUser = riwayat.any(
                (r) => r['uid'] == currentUserId,
              );

              // Tab filter
              if (showAntrian && sudahDikerjakanUser) return false;
              if (!showAntrian && !sudahDikerjakanUser) return false;

              // Search filter
              final query = searchQuery.toLowerCase();
              return (data['nomor'] ?? '').toLowerCase().contains(query) ||
                  (data['asal'] ?? '').toLowerCase().contains(query) ||
                  (data['perihal'] ?? '').toLowerCase().contains(query);
            }).toList();

        if (docs.isEmpty) {
          return Center(
            child: Text(
              showAntrian
                  ? "Tidak ada surat antrian"
                  : "Belum ada riwayat disposisi",
              style: GoogleFonts.poppins(color: Colors.grey[700]),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>;
            return _DisposisiCardUser(docId: doc.id, data: data);
          },
        );
      },
    );
  }
}

// 🔹 Card Disposisi User
class _DisposisiCardUser extends StatelessWidget {
  final String docId;
  final Map<String, dynamic> data;

  const _DisposisiCardUser({required this.docId, required this.data});

  @override
  Widget build(BuildContext context) {
    final nomor = data['nomor'] ?? '-';
    final asal = data['asal'] ?? '-';
    final perihal = data['perihal'] ?? '-';
    final riwayat = List.from(data['riwayat'] ?? []);
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final sudahDikerjakanUser = riwayat.any((r) => r['uid'] == currentUserId);

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailDisposisiUser(docId: docId, data: data),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    nomor,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color:
                            sudahDikerjakanUser ? Colors.orange : Colors.blue,
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      sudahDikerjakanUser
                          ? "Sudah Disposisi"
                          : "Belum Disposisi",
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color:
                            sudahDikerjakanUser ? Colors.orange : Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                asal,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 2),
              Text(
                perihal,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
