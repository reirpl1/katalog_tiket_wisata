import '../models/objek_wisata.dart';

class RingkasanData {
  final int totalObjek;
  final double rataRataTiketDewasa;

  const RingkasanData({
    required this.totalObjek,
    required this.rataRataTiketDewasa,
  });
}

///Fitur F3: menghitung jumlah objek yang tampil dan rata rata tiket dewasa
///dari daftar yang sudah difilter. Memakai perulangan for manual
///bukan fold/reduce sesuai instruksi "dihitung dengan perulangan".
///Dipanggil ulang setiap daftar hasil filter berubah.

RingkasanData hitungRingkasan(List<ObjekWisata> daftar) {
  final totalObjek = daftar.length;

  int jumlahHarga =  0;
  for (final objek in daftar){
    jumlahHarga += objek.tiketDewasa;
  }

  final rataRata = totalObjek == 0 ? 0.0 : jumlahHarga / totalObjek;

  return RingkasanData(
    totalObjek: totalObjek,
    rataRataTiketDewasa: rataRata,
  );
}