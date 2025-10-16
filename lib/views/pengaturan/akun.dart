import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Import halaman login & ubah sandi
import 'package:manejemen_surat/views/login.dart';
import 'package:manejemen_surat/views/ubahsandi.dart';

class User {
  final String nama;
  final String jabatan;
  final String role;

  User({required this.nama, required this.jabatan, required this.role});
}

// Default akun: Rizky Pratama
final User currentUser = User(
  nama: "Rizky Pratama S.IP",
  jabatan: "Staf Bagian Umum DPRD",
  role: "admin",
);

class Akun extends StatefulWidget {
  const Akun({super.key});

  @override
  State<Akun> createState() => _AkunState();
}

class _AkunState extends State<Akun> {
  final List<User> akunList = [currentUser];

  // Fungsi tambah akun baru
  void _tambahAkunDialog() {
    final namaController = TextEditingController();
    final jabatanController = TextEditingController();
    String role = 'user';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "Tambah Akun Baru",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: namaController,
                  decoration: const InputDecoration(
                    labelText: "Nama Lengkap",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: jabatanController,
                  decoration: const InputDecoration(
                    labelText: "Jabatan",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: role,
                  items: const [
                    DropdownMenuItem(value: 'user', child: Text("User")),
                    DropdownMenuItem(value: 'admin', child: Text("Admin")),
                  ],
                  decoration: const InputDecoration(
                    labelText: "Role",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    role = val ?? 'user';
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Batal", style: GoogleFonts.poppins()),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                if (namaController.text.isNotEmpty &&
                    jabatanController.text.isNotEmpty) {
                  setState(() {
                    akunList.add(
                      User(
                        nama: namaController.text,
                        jabatan: jabatanController.text,
                        role: role,
                      ),
                    );
                  });
                  Navigator.pop(context);
                }
              },
              child: Text(
                "Simpan",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade600, Colors.blue.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    currentUser.nama,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentUser.jabatan,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Akses: ${currentUser.role.toUpperCase()}",
                      style: GoogleFonts.poppins(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ACTION CARD: Ubah Kata Sandi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                child: ListTile(
                  leading: const Icon(Icons.lock, color: Colors.orange),
                  title: Text(
                    "Ubah Kata Sandi",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UbahSandi(),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ✅ Tambah Akun
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                child: ListTile(
                  leading: const Icon(Icons.person_add, color: Colors.blue),
                  title: Text(
                    "Tambah Akun",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _tambahAkunDialog,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ✅ Daftar Akun yang tersimpan
            if (akunList.length > 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Daftar Akun:",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...akunList
                        .skip(1)
                        .map(
                          (u) => Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(
                                u.nama,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                "${u.jabatan}\nRole: ${u.role}",
                                style: GoogleFonts.poppins(fontSize: 12),
                              ),
                              isThreeLine: true,
                            ),
                          ),
                        )
                        .toList(),
                  ],
                ),
              ),

            const SizedBox(height: 40),

            // BUTTON LOGOUT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: Text(
                    "Keluar Akun",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
