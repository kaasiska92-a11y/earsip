import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

textView(margin, text, posisi, warna, tebal, ukuran) {
  return Container(
    margin: margin,
    child: Text(
      text,
      textAlign: posisi,
      style: GoogleFonts.poppins(
        color: warna,
        fontWeight: tebal,
        fontSize: ukuran,
      ),
    ),
  );
}