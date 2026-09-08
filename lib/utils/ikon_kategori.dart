import 'package:flutter/material.dart';

IconData ikonUntukJenis(String jenis) {
  final jenisKecil = jenis.toLowerCase();

  if (jenisKecil.contains('pantai') || jenisKecil.contains('laut')) {
    return Icons.beach_access_outlined;
}
  if (jenisKecil.contains('budaya')) {
    return Icons.account_balance_outlined;
}
  if (jenisKecil.contains('goa')) {
    return Icons.terrain_outlined;
}
  if (jenisKecil.contains('hutan')) {
    return Icons.park_outlined;
}
  if (jenisKecil.contains('kebun binatang')) {
    return Icons.pets_outlined;
}
  if (jenisKecil.contains('alam')) {
    return Icons.nature_outlined;
}

return Icons.landscape_outlined;
}

//file ini tempat ikon berdasarkan jenis kategori objek wisata
