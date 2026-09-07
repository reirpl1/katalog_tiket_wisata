import 'package:flutter/material.dart';
import '../models/objek_wisata.dart';
import '../utils/aturan_tiket.dart';
import '../utils/format_rupiah.dart';

class PenghitungTiket extends StatefulWidget {
  final ObjekWisata objek;

  const PenghitungTiket({super.key, required this.objek});

  @override
  State<PenghitungTiket> createState() => _PenghitungTiketState();
}

class _PenghitungTiketState  extends State<PenghitungTiket> {
  int _jumlahDewasa = 0;
  int _jumlahAnak = 0;
  String? _pesanPeringatan;

  void _ubahDewasa(int delta) => _prosesPerubahan(deltaDewasa: delta);
  void _ubahAnak(int delta) => _prosesPerubahan(deltaAnak: delta);

  void _prosesPerubahan({int deltaDewasa = 0, int deltaAnak = 0}) {
    final calonDewasa = _jumlahDewasa + deltaDewasa;
    final calonAnak = _jumlahAnak + deltaAnak;

    final totalCalon = calonDewasa + calonAnak;

    setState(() {
      if (!masihMuatKuota(totalCalon, widget.objek.kuotaHarian)) {
        _pesanPeringatan = 
          'Kuota harian ${widget.objek.namaObjek} sudah penuh (maks ${widget.objek.kuotaHarian} orang)';
          return;
      }
     _pesanPeringatan = null;
     _jumlahDewasa = calonDewasa; 
     _jumlahAnak = calonAnak; 
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalOrang = _jumlahDewasa + _jumlahAnak;
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
          nilai :  _jumlahDewasa,
          onTambah: () => _ubahDewasa(1),
          onKurang: () => _ubahDewasa(-1),
        ),
        _BarisPenghitung(
          label: 'Anak',
          nilai :  _jumlahAnak,
          onTambah: () => _ubahAnak(1),
          onKurang: () => _ubahAnak(-1),
        ),
        const SizedBox(height: 6),
        if (diskon > 0)
        Text(
          'Diskon rombongan 15% aktif',
        style: TextStyle(
          fontSize: 11,
          color: Colors.green.shade700,
          fontWeight: FontWeight.w600,
        ),
      ),
      Text(
        'Total: ${formatRupiah(totalAkhir)}',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
      if (_pesanPeringatan != null)
      Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          _pesanPeringatan!,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 11,
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
  final VoidCallback onTambah;
  final VoidCallback onKurang;

  const _BarisPenghitung({
    required this.label,
    required this.nilai,
    required this.onTambah,
    required this.onKurang,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 48,
          child: Text(label, style: const TextStyle(fontSize: 12)),
        ),
        _TombolBulat(icon: Icons.remove, onTap: onKurang),
        SizedBox(
          width: 22,
          child: Text(
            '$nilai',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        _TombolBulat(icon: Icons.add, onTap: onTambah),
      ],
    );
  }
}

class _TombolBulat extends StatelessWidget  {
  final  IconData icon;
  final VoidCallback onTap;

  const _TombolBulat({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width:22,
        height: 22,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF1E4CB),  //sand
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon, size: 14, color: const Color(0xFF6E3B4C)), //plum
      ),
    );
  }
}

