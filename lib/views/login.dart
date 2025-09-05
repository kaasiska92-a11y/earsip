import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manejemen_surat/views/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool rememberMe = false;
  String? errorMessage;

  // Dummy akun
  final Map<String, String> accounts = {
    "admin": "admin123",
    "KetuaDPRD@dprd.go.id": "Ketuadprd123",
    "Wakilketua@dprd.go.id": "staff123",
    "sekertaris@dprd.go.id": "staff1777",
  };

  void _login() {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (accounts.containsKey(username) && accounts[username] == password) {
      setState(() => errorMessage = null);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login berhasil, selamat datang $username")),
      );
       // Navigasi ke halaman baru
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
    } else {
      setState(() => errorMessage = "Username atau password salah!");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon logo
              Image.asset(
              'assets/logo.png',
              width: 120,
              height: 120,
            ),
              const SizedBox(height: 10),

              // Judul
              Text(
                "e-Arsip",
                style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              const SizedBox(height: 30),

              // Username
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 16),

              // Password
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 10),

              // Remember Me + Reset Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        onChanged: (val) {
                          setState(() {
                            rememberMe = val ?? false;
                          });
                        },
                      ),
                      const Text("Remember Me"),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Reset Password?",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),

              if (errorMessage != null)
                Text(errorMessage!,
                    style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 20),

              // Tombol Login
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text("Login",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}