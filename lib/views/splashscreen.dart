import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manejemen_surat/views/login.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _rotateAnimation;
  late Animation<double> _fadeTextAnimation;

  @override
  void initState() {
    super.initState();

    // 🔹 Animasi rotasi logo
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _rotateAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );
    _logoController.repeat();

    // 🔹 Animasi teks fade-in
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeTextAnimation = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    );

    Future.delayed(const Duration(milliseconds: 800), () {
      _textController.forward();
    });

    // 🔹 Pindah ke halaman utama
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // 🌈 Gradasi keren dengan efek "light burst"
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1E3C72), // biru gelap
                  Color(0xFF2A5298), // biru keunguan
                  Color(0xFF36D1DC), // cyan
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // 💡 Efek cahaya lembut di tengah
          Positioned(
            top: screenHeight * 0.3,
            left: 0,
            right: 0,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.white.withOpacity(0.3), Colors.transparent],
                  radius: 0.8,
                ),
              ),
            ),
          ),

          // ✨ Partikel dekoratif (bisa statis biar ringan)
          Positioned(
            top: 100,
            left: 50,
            child: _buildParticle(Colors.white24, 15),
          ),
          Positioned(
            bottom: 150,
            right: 60,
            child: _buildParticle(Colors.white30, 25),
          ),
          Positioned(
            top: 200,
            right: 120,
            child: _buildParticle(Colors.white10, 20),
          ),

          // 🔹 Konten utama
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _rotateAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotateAnimation.value,
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.4),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/logo.png',
                            width: 80,
                            height: 80,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: screenHeight * 0.05),
                FadeTransition(
                  opacity: _fadeTextAnimation,
                  child: Column(
                    children: [
                      Text(
                        "e-Surat DPRD",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Digitalisasi Administrasi Pemerintahan",
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 14,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Widget partikel hias
  Widget _buildParticle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 8, spreadRadius: 2)],
      ),
    );
  }
}
