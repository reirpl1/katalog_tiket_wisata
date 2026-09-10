import 'package:flutter/material.dart';
import '../models/objek_wisata.dart';
import '../utils/format_rupiah.dart';
import '../utils/ikon_kategori.dart';

// Fitur F5 - HALAMAN RINCIAN: halaman ini menampilkan seluruh data objek wisata
class DetailWisataPage extends StatelessWidget {
  final ObjekWisata data;

  const DetailWisataPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          data.namaObjek,
          style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF14213D), //navy
        foregroundColor: const Color.fromARGB(255, 211, 190, 144), //sand
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              data.gambar,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFF14213D).withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    ikonUntukJenis(data.namaObjek, data.jenis),
                    size: 64,
                    color: const Color((0xFF14213D)),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          _BarisRincian(label: 'Nama Objek', nilai: data.namaObjek),
          _BarisRincian(label: 'Jenis', nilai: data.jenis),
          _BarisRincian(
            label: 'Tiket Dewasa',
            nilai: formatRupiah(data.tiketDewasa),
          ),
          _BarisRincian(
            label: 'Tiket Anak',
            nilai: formatRupiah(data.tiketAnak),
          ),
          _BarisRincian(
            label: 'Kuota Harian',
            nilai: '${data.kuotaHarian} orang',
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF6E3B4C).withValues(alpha: 0.15), //plum
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF6E3B4C).withValues(alpha: 0.5)),
            ),
            child: const Text(
              'Ingat:  rombongan dengan 20 orang atau lebih otomatis\n'
              'mendapat potongan harga 15% pada halaman utama',
              style: TextStyle(fontSize: 12.5, color: Color(0xFF2C2A28)),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarisRincian extends StatelessWidget {
  final String label;
  final String nilai;

  const _BarisRincian({required this.label, required this.nilai});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label, 
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(nilai, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
