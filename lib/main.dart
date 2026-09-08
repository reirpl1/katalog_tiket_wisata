import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main(){
  runApp(const AplikasiKatalogWisata());
}

class AplikasiKatalogWisata extends StatelessWidget {
  const AplikasiKatalogWisata({super.key});

  @override
  Widget build(BuildContext context) {
    const deepTeal = Color(0xFF14213D);
    const plum = Color(0xFF6E3B4C);
    const sand = Color(0xFFF1E4C8);
    const charcoal = Color(0xFF2C2A28);

    return MaterialApp(
      title: 'Katalog Wisata & Perhitungan Tiket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: deepTeal,
          primary: deepTeal,
          secondary: plum,
        ),
        scaffoldBackgroundColor: sand,
        useMaterial3: true,
        textTheme: const TextTheme().apply(bodyColor: charcoal),
        cardTheme: const CardThemeData(
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: const HomePage(),
    );
  }
}
