import '../models/objek_wisata.dart';

class RingkasanData {
  final int totalObjek;
  final int hargaTermurah;
  final int hargaTermahal;

  const RingkasanData({
    required this.totalObjek,
    required this.hargaTermurah,
    required this.hargaTermahal,
  });
}

/// F3: menghitung jumlah objek yang tampil, serta harga tiket termurah
/// dan termahal (dari tiket dewasa dan tiket anak) dari daftar yang sudah difilter
/// memakai perulangan for manual untuk mencari nilai minimum dan maksimum

RingkasanData hitungRingkasan(List<ObjekWisata> daftar) {
  final totalObjek = daftar.length;

  if (daftar.isEmpty) {
    return const RingkasanData(
      totalObjek: 0,
      hargaTermurah: 0,
      hargaTermahal: 0,
    );
  }

  int termurah = daftar.first.tiketDewasa;
  int termahal = daftar.first.tiketAnak;

  for (final objek in daftar) {
    if (objek.tiketDewasa < termurah) {
      termurah = objek.tiketDewasa;
    }
    if (objek.tiketDewasa > termahal) {
      termahal = objek.tiketDewasa;
    }
    if (objek.tiketAnak < termurah) {
      termurah = objek.tiketAnak;
    }
    if (objek.tiketAnak > termahal ) {
      termahal  =  objek.tiketAnak;
    }
  }

  return RingkasanData(
    totalObjek: totalObjek,
    hargaTermurah: termurah,
    hargaTermahal: termahal,
  );
}