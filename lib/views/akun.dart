import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class User {
  final String nama;
  final String jabatan;
  final String email;
  final String role;

  User({
    required this.nama,
    required this.jabatan,
    required this.email,
    required this.role,
  });
}

// Daftar akun DPRD
final List<User> daftarAkun = [
  User(
    nama: "Admin Bagian Umum",
    jabatan: "Sekretariat",
    email: "admin@dprd.go.id",
    role: "admin",
  ),
  User(
    nama: "Ketua DPRD",
    jabatan: "Pimpinan",
    email: "ketua@dprd.go.id",
    role: "ketua",
  ),
  User(
    nama: "Sekwan",
    jabatan: "Sekretaris DPRD",
    email: "sekwan@dprd.go.id",
    role: "sekwan",
  ),
  User(
    nama: "Komisi I",
    jabatan: "Komisi Bidang Pemerintahan",
    email: "komisi1@dprd.go.id",
    role: "komisi1",
  ),
  User(
    nama: "Komisi II",
    jabatan: "Komisi Bidang Ekonomi",
    email: "komisi2@dprd.go.id",
    role: "komisi2",
  ),
  User(
    nama: "Komisi III",
    jabatan: "Komisi Bidang Pembangunan",
    email: "komisi3@dprd.go.id",
    role: "komisi3",
  ),
  User(
    nama: "Komisi IV",
    jabatan: "Komisi Bidang Kesejahteraan Rakyat",
    email: "komisi4@dprd.go.id",
    role: "komisi4",
  ),
  User(
    nama: "Wakil Ketua",
    jabatan: "Pimpinan DPRD",
    email: "wakil@dprd.go.id",
    role: "wakil",
  ),
  User(
    nama: "Sekretaris Ketua",
    jabatan: "Staf Pimpinan",
    email: "sekretaris.ketua@dprd.go.id",
    role: "sekretaris_ketua",
  ),
];

class Akun extends StatefulWidget {
  const Akun({super.key});

  @override
  State<Akun> createState() => _AkunState();
}

class _AkunState extends State<Akun> {
  // Default akun login = Admin
  User currentUser = daftarAkun.first;

  void _gantiAkun(User user) {
    setState(() {
      currentUser = user;
    });
    Navigator.pop(context); // Tutup bottomsheet
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Akun",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue.shade100,
              child: Icon(Icons.person,
                  size: 50, color: Colors.blue.shade700),
            ),
            const SizedBox(height: 12),
            Text(currentUser.nama,
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w600)),
            Text(currentUser.jabatan,
                style: GoogleFonts.poppins(
                    color: Colors.grey, fontSize: 14)),
            Text(currentUser.email,
                style: GoogleFonts.poppins(
                    color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 8),
            Text("Akses: ${currentUser.role.toUpperCase()}",
                style: GoogleFonts.poppins(
                    color: Colors.green,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 20),
            const Divider(),

            // Menu Akses Akun
            ListTile(
              leading: const Icon(Icons.swap_horiz, color: Colors.purple),
              title: Text("Akses Akun", style: GoogleFonts.poppins()),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                final List<User> aksesAkun = daftarAkun.where((user) {
                  return user.role == "admin" ||
                      user.role == "ketua" ||
                      user.role == "sekretaris_ketua" ||
                      user.role == "sekwan" ||
                      user.role.startsWith("komisi") ||
                      user.role == "wakil";
                }).toList();

                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (_) => Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Pilih Akun",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600, fontSize: 18)),
                        const SizedBox(height: 10),
                        Flexible(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: aksesAkun.length,
                            itemBuilder: (context, index) {
                              final user = aksesAkun[index];
                              final bool isSelected =
                                  user.email == currentUser.email;

                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: isSelected
                                      ? BorderSide(
                                          color: Colors.blue.shade400,
                                          width: 2)
                                      : BorderSide.none,
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue.shade100,
                                    child: Icon(Icons.person,
                                        color: Colors.blue.shade700),
                                  ),
                                  title: Text(user.nama,
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600)),
                                  subtitle: Text(
                                    "${user.jabatan}\n${user.email}",
                                    style: GoogleFonts.poppins(fontSize: 12),
                                  ),
                                  isThreeLine: true,
                                  trailing: isSelected
                                      ? Icon(Icons.check_circle,
                                          color: Colors.blue.shade600)
                                      : null,
                                  onTap: () => _gantiAkun(user),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: Text("Sunting Profil", style: GoogleFonts.poppins()),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.lock, color: Colors.orange),
              title: Text("Ubah Kata Sandi", style: GoogleFonts.poppins()),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            const Spacer(),

            // Logout
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: Text("Keluar Akun",
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
