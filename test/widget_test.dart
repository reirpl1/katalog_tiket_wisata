import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:katalog_wisata/main.dart';

void main() {
  testWidgets('Aplikasi menampilkan judul dan kotak pencarian',
      (WidgetTester tester) async {
    await tester.pumpWidget(const AplikasiKatalogWisata());

    // Judul aplikasi di AppBar harus muncul.
    expect(find.text('Jelajah Nusantara — Katalog Wisata'), findsOneWidget);

    // Kotak pencarian harus muncul.
    expect(find.byType(TextField), findsOneWidget);
  });
}