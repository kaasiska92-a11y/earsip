import 'package:cloud_firestore/cloud_firestore.dart';

class Surat {
  String? id; // ✅ tambahkan ini
  String nomor;
  String asal;
  String perihal;
  String tanggalSurat;
  String tanggal_penerimaan;
  bool sudahDisposisi;
  bool sudahDibaca;
  String? lampiranSurat;
  String? sifat;

  Surat({
    this.id, // ✅ tambahkan ini
    required this.nomor,
    required this.asal,
    required this.perihal,
    required this.tanggalSurat,
    required this.tanggal_penerimaan,
    this.sudahDisposisi = false,
    this.sudahDibaca = false,
    this.lampiranSurat,
    this.sifat,
  });

  // ✅ Factory untuk mapping dari Firestore
  factory Surat.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Surat(
      id: doc.id, // ✅ simpan ID dokumen
      nomor: data['nomor'] ?? '',
      asal: data['asal'] ?? '',
      perihal: data['perihal'] ?? '',
      tanggalSurat: data['tanggal_surat'] ?? '',
      tanggal_penerimaan: data['tanggal_penerimaan'] ?? '',
      sudahDisposisi: data['sudah_disposisi'] ?? false,
      sudahDibaca: data['sudah_dibaca'] ?? false,
      lampiranSurat: data['lampiran_surat'],
      sifat: data['sifat'],
    );
  }

  // ✅ untuk simpan balik ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'nomor': nomor,
      'asal': asal,
      'perihal': perihal,
      'tanggal_surat': tanggalSurat,
      'tanggal_penerimaan': tanggal_penerimaan,
      'sudah_disposisi': sudahDisposisi,
      'sudah_dibaca': sudahDibaca,
      'lampiran_surat': lampiranSurat,
      'sifat': sifat,
    };
  }
}