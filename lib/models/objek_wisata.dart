import '../utils/format_rupiah.dart';

class ObjekWisata {
  final String namaObjek;
  final String jenis;
  final int tiketDewasa;
  final int tiketAnak;
  final int kuotaHarian;
  final String gambar;
  final String? gambarDetail;
  final List<String> galeriGambar;

  const ObjekWisata({
    required this.namaObjek,
    required this.jenis,
    required this.tiketDewasa,
    required this.tiketAnak,
    required this.kuotaHarian,
    required this.gambar,
    this.gambarDetail,
    this.galeriGambar = const [],
  });

  String get gambarUntukDetail => gambarDetail ?? gambar;

  String ringkasanTarif() {
    return 'Dewasa ${formatRupiah(tiketDewasa)} Anak ${formatRupiah(tiketAnak)}';
  }
}

// kelas data buatan sendiri untuk mempresentasikan satu objek ObjekWisata
// sengaja dibuat sebagai class bukan Map supaya tipe datanya jelas