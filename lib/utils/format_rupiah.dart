/// mengubah  angka (150000) menjadi teks "150.000"
String formatRupiah(int angka) {
  final teksAsli = angka.toString();
  final buffer = StringBuffer();
  int hitung = 0;

  for (int i = teksAsli.length - 1; i >= 0; i--) {
    buffer.write(teksAsli[i]);
    hitung++;
    if (hitung % 3 == 0 && i != 0) {
      buffer.write('.');
    }
  }

  final terbalik = buffer.toString().split('').reversed.join();
  return 'Rp$terbalik';
}