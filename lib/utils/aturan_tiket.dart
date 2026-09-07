/// Aturan 1: rombongan 20 orang ke atas mendapat potongan 15%
double hitungDiskon(int totalPengunjung) {
  return totalPengunjung >= 20? 0.15 : 0.0;
}

/// Aturan 2: jumlah pengunjung tidak boleh melebihi kuota harian
bool masihMuatKuota(int jumlahDiminta, int kuotaHarian) {
  return jumlahDiminta <= kuotaHarian;
}

/// Aturan 3: total tiket dihitung dari jumlah dewasa dan anak (tarifnya berbeda)
int hitungTotalTiket({
  required int jumlahDewasa,
  required int jumlahAnak,
  required int hargaDewasa,
  required int hargaAnak,
}) {
  return (jumlahDewasa * hargaDewasa) + (jumlahAnak * hargaAnak);
}

/// Menerapkan hasil hitungDiskon() ke total tiket, dibulatkan
int terapkanDiskon(int totalTiket, double diskon) {
  return (totalTiket - (totalTiket * diskon)).round();
}
