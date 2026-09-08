import '../utils/format_rupiah.dart';

class ObjekWisata {
  final String namaObjek;
  final String jenis;
  final int tiketDewasa;
  final int tiketAnak;
  final int kuotaHarian;

  const ObjekWisata({
    required this.namaObjek,
    required this.jenis,
    required this.tiketDewasa,
    required this.tiketAnak,
    required this.kuotaHarian,
  });

  String ringkasanTarif() {
    return 'Dewasa ${formatRupiah(tiketDewasa)} Anak ${formatRupiah(tiketAnak)}';
  }
}

// kelas data buatan sendiri untuk mempresentasikan satu objek ObjekWisata
// sengaja dibuat sebagai class bukan Map supaya tipe datanya jelas