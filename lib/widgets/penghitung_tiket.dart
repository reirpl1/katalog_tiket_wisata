import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/objek_wisata.dart';
import '../utils/aturan_tiket.dart';
import '../utils/format_rupiah.dart';

class PenghitungTiket extends StatefulWidget {
  final ObjekWisata objek;
  final ValueChanged<int> onJumlahTiketBerubah;

  const PenghitungTiket({
    super.key,
    required this.objek,
    required this.onJumlahTiketBerubah,
  });

  @override
  State<PenghitungTiket> createState() => _PenghitungTiketState();
}

class _PenghitungTiketState extends State<PenghitungTiket> {
  int _jumlahDewasa = 0;
  int _jumlahAnak = 0;

  String? _pesanPeringatan;

  int get _totalOrang => _jumlahDewasa + _jumlahAnak;

  int get _sisaKuota {
    final sisa = widget.objek.kuotaHarian - _totalOrang;
    return sisa < 0 ? 0 : sisa;
  }

  bool get _bolehTambah => _sisaKuota > 0;

  void _ubahDewasa(int delta) {
    _prosesPerubahan(deltaDewasa: delta);
  }

  void _ubahAnak(int delta) {
    _prosesPerubahan(deltaAnak: delta);
  }

  void _prosesPerubahan({
    int deltaDewasa = 0,
    int deltaAnak = 0,
  }) {
    final calonDewasa = _jumlahDewasa + deltaDewasa;
    final calonAnak = _jumlahAnak + deltaAnak;

    // Tidak boleh sampai jumlah menjadi negatif.
    if (calonDewasa < 0 || calonAnak < 0) {
      return;
    }

    final totalCalon = calonDewasa + calonAnak;

    // Kalau menambah tetapi kuota sudah habis,
    // jangan mengubah jumlah tiket.
    if (totalCalon > widget.objek.kuotaHarian) {
      setState(() {
        _pesanPeringatan =
            'Kuota harian ${widget.objek.namaObjek} sudah penuh '
            '(maks. ${widget.objek.kuotaHarian} orang).';
      });
      return;
    }

    setState(() {
      _jumlahDewasa = calonDewasa;
      _jumlahAnak = calonAnak;

      // Tampilkan peringatan ketika kuota tepat habis.
      if (totalCalon == widget.objek.kuotaHarian) {
        _pesanPeringatan =
            'Kuota penuh. Tombol + dinonaktifkan.';
      } else {
        _pesanPeringatan = null;
      }
    });

    widget.onJumlahTiketBerubah(totalCalon);
  }

  @override
  Widget build(BuildContext context) {
    final totalOrang = _totalOrang;

    final subtotal = hitungTotalTiket(
      jumlahDewasa: _jumlahDewasa,
      jumlahAnak: _jumlahAnak,
      hargaDewasa: widget.objek.tiketDewasa,
      hargaAnak: widget.objek.tiketAnak,
    );

    final diskon = hitungDiskon(totalOrang);
    final totalAkhir = terapkanDiskon(subtotal, diskon);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BarisPenghitung(
          label: 'Dewasa',
          nilai: _jumlahDewasa,
          bolehTambah: _bolehTambah,
          bolehKurang: _jumlahDewasa > 0,
          onTambah: () => _ubahDewasa(1),
          onKurang: () => _ubahDewasa(-1),
        ),

        const SizedBox(height: 7),

        _BarisPenghitung(
          label: 'Anak',
          nilai: _jumlahAnak,
          bolehTambah: _bolehTambah,
          bolehKurang: _jumlahAnak > 0,
          onTambah: () => _ubahAnak(1),
          onKurang: () => _ubahAnak(-1),
        ),

        const SizedBox(height: 6),

        if (diskon > 0)
          Text(
            'Diskon rombongan 15% aktif',
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.green.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),

          Text(
          'Sisa kuota: $_sisaKuota tiket',
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: _sisaKuota == 0
                ? Colors.red.shade700
                : Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF14213D),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'Total: ${formatRupiah(totalAkhir)}',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),

      if (_pesanPeringatan != null)
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            'Kuota penuh. Tombol + dinonaktifkan.',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 10.5,
              color: Colors.red.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _BarisPenghitung extends StatelessWidget {
  final String label;
  final int nilai;
  final bool bolehTambah;
  final bool bolehKurang;
  final VoidCallback onTambah;
  final VoidCallback onKurang;

  const _BarisPenghitung({
    required this.label,
    required this.nilai,
    required this.bolehTambah,
    required this.bolehKurang,
    required this.onTambah,
    required this.onKurang,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 58,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.visible,
          ),
        ),

        _TombolBulat(
          icon: Icons.remove,
          aktif: bolehKurang,
          onTap: onKurang,
        ),

        const SizedBox(width: 8),

        SizedBox(
          width: 24,
          child: Text(
            '$nilai',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(width: 8),

        _TombolBulat(
          icon: Icons.add,
          aktif: bolehTambah,
          onTap: onTambah,
        ),
      ],
    );
  }
}

class _TombolBulat extends StatelessWidget {
  final IconData icon;
  final bool aktif;
  final VoidCallback onTap;

  const _TombolBulat({
    required this.icon,
    required this.aktif,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: aktif ? onTap : null,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 22,
        height: 22,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: aktif
              ? const Color(0xFFF1E4CB)
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          icon,
          size: 14,
          color: aktif
              ? const Color(0xFF6E3B4C)
              : Colors.grey.shade400,
        ),
      ),
    );
  }
}