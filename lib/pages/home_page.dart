import 'package:flutter/material.dart';
import '../data/data_wisata.dart';
import '../models/objek_wisata.dart';
import '../utils/format_rupiah.dart';
import '../utils/ringkasan_data.dart';
import '../widgets/objek_wisata_card.dart';
import 'detail_wisata_page.dart';

const _navy = Color(0xFF14213D);
const _plum = Color.fromARGB(255, 81, 59, 110);
const _sand = Color(0xFFF1E4C8);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _controllerPencarian;
  String _kataKunci = '';

  // F2: kategori yang sedang dipilih. null artinya "Semua".
  String? _kategoriTerpilih;

  // F1: arah urutan nama. true = A-Z, false = Z-A.
  bool _urutNaik = true;

  @override
  void initState() {
    super.initState();
    _controllerPencarian = TextEditingController();
    _controllerPencarian.addListener(() {
      setState(() {
        _kataKunci = _controllerPencarian.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _controllerPencarian.dispose();
    super.dispose();
  }

  List<String> get _daftarKategori {
    final kategoriUnik = daftarWisata.map((objek) => objek.jenis).toSet();
    return kategoriUnik.toList();
  }

  List<ObjekWisata> get _hasilTersaring {
    var hasil = daftarWisata.where((objek) {
      final cocokKataKunci = _kataKunci.isEmpty ||
          objek.namaObjek.toLowerCase().contains(_kataKunci) ||
          objek.jenis.toLowerCase().contains(_kataKunci);
      final cocokKategori =
          _kategoriTerpilih == null || objek.jenis == _kategoriTerpilih;
      return cocokKataKunci && cocokKategori;
    }).toList();

    // F1: urutkan nama sesuai arah yang dipilih.
    hasil.sort((a, b) => _urutNaik
        ? a.namaObjek.compareTo(b.namaObjek)
        : b.namaObjek.compareTo(a.namaObjek));

    return hasil;
  }

  int _tentukanJumlahKolom(double lebar) {
    if (lebar >= 900) return 3;
    if (lebar >= 600) return 2;
    return 1;
  }

  // menghitung tinggi foto yang proporsional (rasio 16:9) supaya
  // gambar tidak gepeng diukuran layar manapun

  double  _hitungTinggiGambar(double lebarLayar, int jumlahKolom) {
    const paddingHorizontalGrid = 32.0; // padding kiri kanan gridView (16+16)
    const spasiAntarKolom = 12.0; // spasi antar kolom
    const paddingDalamKartu = 20.0; // padding  kiri kanan gridCard(10+10)

    final totalSpasi = spasiAntarKolom * (jumlahKolom - 1);
    final lebarKartu = (lebarLayar - paddingHorizontalGrid - totalSpasi) / jumlahKolom;
    final lebarGambar = lebarKartu - paddingDalamKartu;

    return (lebarGambar * 0.65).clamp(220.0, 300.0);
    
  }

  @override
  Widget build(BuildContext context) {
    final hasil = _hasilTersaring;
    final ringkasan = hitungRingkasan(hasil);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Jelajah Nusantara — Katalog Wisata',
          style: TextStyle(color: Colors.white)),
        backgroundColor: _navy,
        foregroundColor: _sand,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _controllerPencarian,
              decoration: InputDecoration(
                hintText: 'Cari objek wisata atau jenisnya...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: _sand,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: _navy.withValues(alpha: 0.35), width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: _navy.withValues(alpha: 0.35), width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: _navy, width: 1.5)
                )
              ),
            ),
          ),

          // F1 + F2: baris kategori (kiri) dan tombol urutkan (kanan).
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _ChipKategori(
                          label: 'Semua',
                          terpilih: _kategoriTerpilih == null,
                          onTap: () => setState(() => _kategoriTerpilih = null),
                        ),
                        for (final kategori in _daftarKategori)
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: _ChipKategori(
                              label: kategori,
                              terpilih: _kategoriTerpilih == kategori,
                              onTap: () =>
                                  setState(() => _kategoriTerpilih = kategori),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  tooltip: _urutNaik ? 'Urut A ke Z' : 'Urut Z ke A',
                  onPressed: () => setState(() => _urutNaik = !_urutNaik),
                  icon: Icon(
                    _urutNaik
                        ? Icons.arrow_downward_rounded
                        : Icons.arrow_upward_rounded,
                    color: _navy
                  ),
                ),
              ],
            ),
          ),

          // F3: ringkasan atas, dua angka dari perulangan, ikut berubah
          // saat pencarian/kategori berubah.
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: _plum.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _plum.withValues(alpha: 0.45)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      '${ringkasan.totalObjek} objek ditampilkan',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                 const SizedBox(width: 8),
                 Flexible(
                  child: Text(
                    'Rata-rata: ${formatRupiah(ringkasan.hargaTermurah)} / ${formatRupiah(ringkasan.hargaTermahal)}',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                 ),
                ],
              ),
            ),
          ),

          // F4: tampilan kosong jika hasil filter tidak ada, F5 lewat
          // onLihatRincian di setiap kartu.
          Expanded(
            child: hasil.isEmpty
                ? _TampilanKosong(kataKunci: _kataKunci)
                : LayoutBuilder(
                  builder: (context, constraints) {
                    final jumlahKolom =
                    _tentukanJumlahKolom(constraints.maxWidth);
                    final tinggiGambar =
                    _hitungTinggiGambar(constraints.maxWidth, jumlahKolom);
                    const tinggiKontenLain = 215.0; //nama+jenis+harga+counter+total
                    final tinggiKartu = tinggiGambar + tinggiKontenLain;

                    return GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                      itemCount: hasil.length,
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: jumlahKolom,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        mainAxisExtent: tinggiKartu,
                      ),
                      itemBuilder: (context, index) {
                        final objek = hasil[index];
                        return ObjekWisataCard(
                          data: objek,
                          tinggiGambar: tinggiGambar,
                          onLihatRincian: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:(_) =>
                                  DetailWisataPage(data: objek),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}

class _ChipKategori extends StatelessWidget {
  final String label;
  final bool terpilih;
  final VoidCallback onTap;

  const _ChipKategori({
    required this.label,
    required this.terpilih,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      selected: terpilih,
      onSelected: (_) => onTap(),
      selectedColor: _navy,
      backgroundColor: _sand,
      labelStyle: TextStyle(
        color: terpilih ? Colors.white : const Color(0xFF2C2A28),
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide.none,
      ),
    );
  }
}

// F4: tampilan khusus saat hasil pencarian/filter kosong.
class _TampilanKosong extends StatelessWidget {
  final String kataKunci;

  const _TampilanKosong({required this.kataKunci});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.travel_explore, size: 56, color: _plum.withValues(alpha: 0.5)),
          const SizedBox(height: 12),
          Text(
            kataKunci.isEmpty
                ? 'Tidak ada objek wisata pada kategori ini.'
                : 'Objek wisata "$kataKunci" tidak ditemukan.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Color(0xFF2C2A28)),
          ),
          const SizedBox(height: 4),
          const Text(
            'Coba ubah kata kunci atau kategori.',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}