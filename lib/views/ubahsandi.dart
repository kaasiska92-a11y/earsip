import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UbahSandi extends StatefulWidget {
  const UbahSandi({super.key});

  @override
  State<UbahSandi> createState() => _UbahSandiState();
}

class _UbahSandiState extends State<UbahSandi> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  bool _isOldPassVisible = false;
  bool _isNewPassVisible = false;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> _updatePasswordFirestore(
    String email,
    String oldPass,
    String newPass,
  ) async {
    try {
      QuerySnapshot query =
          await firestore
              .collection('users')
              .where('email', isEqualTo: email)
              .get();

      if (query.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("⚠️ Email tidak ditemukan")),
        );
        return;
      }

      var userDoc = query.docs.first;
      if (userDoc['password'] != oldPass) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("⚠️ Password lama salah")));
        return;
      }

      await firestore.collection('users').doc(userDoc.id).update({
        'password': newPass,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Password berhasil diperbarui")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("⚠️ Terjadi kesalahan: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.blue.shade700;
    final Color backgroundColor = const Color(0xFFE3F2FD); // abu lembut

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          "Ubah Kata Sandi",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(
                    255,
                    255,
                    255,
                    255,
                  ).withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor.withOpacity(0.1),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Icon(
                      Icons.lock_reset,
                      size: 60,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Perbarui Kata Sandi Anda",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Email
                  _buildTextField(
                    controller: _emailController,
                    label: "Email",
                    icon: Icons.email,
                    primaryColor: primaryColor,
                  ),
                  const SizedBox(height: 20),

                  // Password Lama
                  _buildTextField(
                    controller: _oldPasswordController,
                    label: "Password Lama",
                    icon: Icons.lock,
                    primaryColor: primaryColor,
                    isPassword: true,
                    isVisible: _isOldPassVisible,
                    onToggleVisibility: () {
                      setState(() {
                        _isOldPassVisible = !_isOldPassVisible;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // Password Baru
                  _buildTextField(
                    controller: _newPasswordController,
                    label: "Password Baru",
                    icon: Icons.lock_outline,
                    primaryColor: primaryColor,
                    isPassword: true,
                    isVisible: _isNewPassVisible,
                    onToggleVisibility: () {
                      setState(() {
                        _isNewPassVisible = !_isNewPassVisible;
                      });
                    },
                  ),
                  const SizedBox(height: 32),

                  // Tombol Simpan
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        String email = _emailController.text.trim();
                        String oldPass = _oldPasswordController.text.trim();
                        String newPass = _newPasswordController.text.trim();
                        _updatePasswordFirestore(email, oldPass, newPass);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 6,
                        shadowColor: primaryColor.withOpacity(0.4),
                      ),
                      child: Text(
                        "Simpan Perubahan",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color primaryColor,
    bool isPassword = false,
    bool isVisible = false,
    VoidCallback? onToggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? !isVisible : false,
      cursorColor: primaryColor,
      style: GoogleFonts.poppins(),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.grey[700]),
        prefixIcon: Icon(icon, color: primaryColor),
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    isVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: onToggleVisibility,
                )
                : null,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}
