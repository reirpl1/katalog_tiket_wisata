import '../models/objek_wisata.dart';

class RingkasanData {
  final int totalObjek;
  final int totalTiket;

  const RingkasanData({
    required this.totalObjek,
    required this.totalTiket,
  });
}

RingkasanData hitungRingkasan(List<ObjekWisata> daftar) {
  int totalTiket = 0;

  for (final objek in daftar) {
    totalTiket += objek.kuotaHarian;
  }

  return RingkasanData(
    totalObjek: daftar.length,
    totalTiket: totalTiket,
  );
}