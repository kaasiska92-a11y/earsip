import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manejemen_surat/auth_data.dart';

class UbahSandi extends StatefulWidget {
  const UbahSandi({super.key});

  @override
  State<UbahSandi> createState() => _UbahSandiState();
}

class _UbahSandiState extends State<UbahSandi> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  bool _isOldPassVisible = false;
  bool _isNewPassVisible = false;

  void _updatePassword() {
    String username = _usernameController.text.trim();
    String oldPass = _oldPasswordController.text.trim();
    String newPass = _newPasswordController.text.trim();

    if (!accounts.containsKey(username)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Username tidak ditemukan")),
      );
      return;
    }

    if (accounts[username] != oldPass) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("⚠️ Password lama salah")));
      return;
    }

    setState(() {
      accounts[username] = newPass; // Update password di global map
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Password berhasil diperbarui")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.blue.shade600;

    return Scaffold(
      backgroundColor: Colors.grey[100],
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
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Icon(Icons.lock_reset, size: 60, color: primaryColor),
                  const SizedBox(height: 16),
                  Text(
                    "Perbarui Kata Sandi Anda",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Username
                  _buildTextField(
                    controller: _usernameController,
                    label: "Username",
                    icon: Icons.person,
                    primaryColor: primaryColor,
                  ),
                  const SizedBox(height: 16),

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
                  const SizedBox(height: 16),

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
                  const SizedBox(height: 24),

                  // Tombol Simpan
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _updatePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        "Simpan Perubahan",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
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
      cursorColor: primaryColor, // 🔹 kursor jadi biru
      style: GoogleFonts.poppins(),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(),
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
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}
