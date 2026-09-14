import '../utils/format_rupiah.dart';

class ObjekWisata {
  final String namaObjek;
  final String jenis;
  final int tiketDewasa;
  final int tiketAnak;
  int kuotaHarian;
  final String gambar;
  final List<String> galeriGambar;
  final String lokasi;

    ObjekWisata({
    required this.namaObjek,
    required this.jenis,
    required this.tiketDewasa,
    required this.tiketAnak,
    required this.kuotaHarian,
    required this.gambar,
    this.galeriGambar = const [],
    required this.lokasi,
  });

  String get gambarUntukDetail => galeriGambar.isNotEmpty || galeriGambar.isNotEmpty ? galeriGambar.first : gambar;

  String ringkasanTarif() {
    return 'Dewasa ${formatRupiah(tiketDewasa)}, Anak ${formatRupiah(tiketAnak)}';
  }
}

// kelas data buatan sendiri untuk mempresentasikan satu objek ObjekWisata
// sengaja dibuat sebagai class bukan Map supaya tipe datanya jelas