class Surat {
  String nomor;
  String asal;
  String perihal;
  String tanggalSurat;
  String tanggalTerima;
  bool sudahDisposisi;
  bool sudahDibaca;

  Surat({
    required this.nomor,
    required this.asal,
    required this.perihal,
    required this.tanggalSurat,
    required this.tanggalTerima,
    this.sudahDisposisi = false,
    this.sudahDibaca = false,
  });
}
