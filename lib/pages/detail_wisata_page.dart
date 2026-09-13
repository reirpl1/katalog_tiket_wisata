import 'package:flutter/material.dart';

import '../models/objek_wisata.dart';
import '../utils/format_rupiah.dart';

// Fitur F5 - HALAMAN RINCIAN
class DetailWisataPage extends StatelessWidget {
  final ObjekWisata data;

  const DetailWisataPage({
    super.key,
    required this.data,
  });

  static const Color _navy = Color(0xFF14213D);
  static const Color _maroon = Color(0xFF6E3B4C);
  static const Color _bg = Color(0xFFF3ECDD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: Text(
          data.namaObjek,
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: _navy,
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          // breakpoint sederhana untuk menentukan jumlah kolom
          final bool isWide = constraints.maxWidth >= 700;
          final double horizontalPadding =
              constraints.maxWidth >= 900 ? 32 : 16;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 20,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // =========================
                      // GAMBAR OBJEK WISATA (RESPONSIF)
                      // =========================
                      LayoutBuilder(
                        builder: (context, constraintsGambar) {
                          final double tinggiLayar =
                            MediaQuery.of(context).size.height;
                          final double tinggiGambar =
                            (tinggiLayar *0.42).clamp(220.0, 480.0);
                          final double lebarMaksimal  = constraintsGambar.maxWidth;

                          return Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: lebarMaksimal,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Container(
                                  height: tinggiGambar,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: _maroon, width: 2),
                                    color:_navy.withValues(alpha: 0.08),
                                  ),
                                  child: Hero(
                                    tag: 'gambar-wisata-${data.namaObjek}',
                                    child: Image.asset(
                                      data.gambarUntukDetail,
                                      height: tinggiGambar,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace){
                                        return Container(
                                          width: lebarMaksimal,
                                          height: tinggiGambar,
                                          color: _navy.withValues(alpha: 0.15),
                                          alignment: Alignment.center,
                                          child: const Icon(
                                            Icons.image_not_supported_outlined,
                                            size: 48,
                                            color: _navy,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      if (data.galeriGambar.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 90,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: data.galeriGambar.length,
                            separatorBuilder: (_, _) => const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              final fotoGaleri = data.galeriGambar[index];
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  fotoGaleri,
                                  width: 110,
                                  height: 90,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 110,
                                      height: 90,
                                      color: _navy.withValues(alpha: 0.1),
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.broken_image_outlined,
                                        size: 22,
                                        color: _navy,
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],

                      const SizedBox(height: 24),

                      // =========================
                      // INFORMASI WISATA (RESPONSIF: 1 atau 2 kolom)
                      // =========================
                      isWide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      _BarisRincian(
                                        icon: Icons.account_balance_outlined,
                                        label: 'Nama Objek',
                                        nilai: data.namaObjek,
                                      ),
                                      _BarisRincian(
                                        icon: Icons.sell_outlined,
                                        label: 'Jenis',
                                        nilai: data.jenis,
                                      ),
                                      _BarisRincian(
                                        icon: Icons.confirmation_number_outlined,
                                        label: 'Tiket Dewasa',
                                        nilai: formatRupiah(data.tiketDewasa),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: Column(
                                    children: [
                                      _BarisRincian(
                                        icon: Icons.person_outline,
                                        label: 'Tiket Anak',
                                        nilai: formatRupiah(data.tiketAnak),
                                      ),
                                      _BarisRincian(
                                        icon: Icons.groups_outlined,
                                        label: 'Kuota Harian',
                                        nilai: '${data.kuotaHarian} orang',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                _BarisRincian(
                                  icon: Icons.account_balance_outlined,
                                  label: 'Nama Objek',
                                  nilai: data.namaObjek,
                                ),
                                _BarisRincian(
                                  icon: Icons.sell_outlined,
                                  label: 'Jenis',
                                  nilai: data.jenis,
                                ),
                                _BarisRincian(
                                  icon: Icons.confirmation_number_outlined,
                                  label: 'Tiket Dewasa',
                                  nilai: formatRupiah(data.tiketDewasa),
                                ),
                                _BarisRincian(
                                  icon: Icons.person_outline,
                                  label: 'Tiket Anak',
                                  nilai: formatRupiah(data.tiketAnak),
                                ),
                                _BarisRincian(
                                  icon: Icons.groups_outlined,
                                  label: 'Kuota Harian',
                                  nilai: '${data.kuotaHarian} orang',
                                ),
                              ],
                            ),

                      const SizedBox(height: 8),

                      // =========================
                      // INFORMASI DISKON
                      // =========================
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _maroon.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _maroon.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: _maroon,
                              child: const Icon(
                                Icons.info_outline,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Ingat: rombongan dengan 20 orang atau lebih '
                                'otomatis mendapat potongan harga 15% pada '
                                'halaman utama',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ========================================
// BARIS INFORMASI (dengan ikon bulat)
// ========================================

class _BarisRincian extends StatelessWidget {
  final IconData icon;
  final String label;
  final String nilai;

  const _BarisRincian({
    required this.icon,
    required this.label,
    required this.nilai,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFF6E3B4C),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  nilai,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}