import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  //F2: kategori yang dipilih
  String? _kategoriTerpilih;

  //pilihan pengurutan
  String _urutanDipilih = 'A-Z';
  final Map<String, int> _tiketDipilih = {};

  int _hitungTiketTersisa(List<ObjekWisata> daftar) {
  int totalTiket = 0;

  for (final objek in daftar) {
    totalTiket += objek.kuotaHarian;
    totalTiket -= _tiketDipilih[objek.namaObjek] ?? 0;
  }

  return totalTiket;
}

  @override
  void initState() {
    super.initState();

    _controllerPencarian = TextEditingController();

    _controllerPencarian.addListener(() {
      setState(() {
        _kataKunci = 
          _controllerPencarian.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _controllerPencarian.dispose();
    super.dispose();
  }

  List<String> get _daftarKategori {
    final kategoriUnik =
      daftarWisata.map((objek) => objek.jenis).toSet();

      return kategoriUnik.toList();
  }

  List<ObjekWisata> get _hasilTersaring {
    var hasil = daftarWisata.where((objek) {
      final cocokKataKunci =
          _kataKunci.isEmpty ||
          objek.namaObjek.toLowerCase().contains(_kataKunci) ||
          objek.jenis.toLowerCase().contains(_kataKunci);

      final cocokKategori =
          _kategoriTerpilih == null ||
          objek.jenis == _kategoriTerpilih;

      return cocokKataKunci && cocokKategori;
    }).toList();

    //F1: Pengurutan sesuai pilihan filter
   if (_urutanDipilih == 'A-Z') {
      hasil.sort(
        (a, b) => a.namaObjek.compareTo(b.namaObjek),
      );
    } else if (_urutanDipilih == 'Harga tiket termurah') {
      hasil.sort(
        (a, b) => a.tiketDewasa.compareTo(b.tiketDewasa),
      );
    } else if (_urutanDipilih == 'Harga tiket termahal') {
      hasil.sort(
        (a, b) => b.tiketDewasa.compareTo(a.tiketDewasa),
      );
    }

    return hasil;
  }

  int _tentukanJumlahKolom(double lebar) {
    if (lebar >= 900) return 3;
    if (lebar >= 600) return 2;
    return 1;
  }

  double _hitungTinggiGambar(
    double lebarLayar,
    int jumlahKolom,
  ) {
    const paddingHorizontalGrid = 32.0;
    const spasiAntarKolom = 12.0;
    const paddingDalamKartu = 20.0;

    final totalSpasi =
        spasiAntarKolom * (jumlahKolom -1);

    final lebarKartu =
        (lebarLayar - paddingHorizontalGrid - totalSpasi) / jumlahKolom;

    final lebarGambar =
        lebarKartu - paddingDalamKartu;

    return (lebarGambar * 0.65).clamp(220.0, 300.0);
  }

  @override
  Widget build(BuildContext context) {
    final hasil = _hasilTersaring;
    final ringkasan = hitungRingkasan(hasil);
    final totalTiketTersisa = _hitungTiketTersisa(hasil);

    return Scaffold(
      appBar: AppBar(
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.terrain,
            color: Colors.white,
            size: 21,
          ),
          const SizedBox(width: 6),
          Text(
            'Jelajah Nusantara',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ],
      ),
      backgroundColor: _navy,
      foregroundColor: Colors.white,
    ),

     body: Column(
        children: [

          // =========================
          // SEARCH
          // =========================
          Padding(
            padding:
                const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _controllerPencarian,
              decoration: InputDecoration(
                hintText:
                    'Cari objek wisata atau jenisnya...',
                prefixIcon:
                    const Icon(Icons.search),
                filled: true,
                fillColor: _sand,

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: _navy.withValues(alpha: 0.35),
                    width: 1,
                  ),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: _navy.withValues(alpha: 0.35),
                    width: 1,
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: _navy,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),

          // =========================
          // KATEGORI + FILTER
          // =========================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // =========================
                // KATEGORI WISATA
                // =========================
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 10,
                    children: [
                      _ChipKategori(
                        label: 'Semua',
                        terpilih: _kategoriTerpilih == null,
                        onTap: () {
                          setState(() {
                            _kategoriTerpilih = null;
                          });
                        },
                      ),

                      for (final kategori in _daftarKategori)
                        _ChipKategori(
                          label: kategori,
                          terpilih: _kategoriTerpilih == kategori,
                          onTap: () {
                            setState(() {
                              _kategoriTerpilih = kategori;
                            });
                          },
                        ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // =========================
                // TOMBOL FILTER
                // =========================
                PopupMenuButton<String>(
                  tooltip: 'Urutkan',

                  icon: const Icon(
                    Icons.filter_list_rounded,
                    color: _navy,
                    size: 27,
                  ),

                  onSelected: (String pilihan) {
                    setState(() {
                      _urutanDipilih = pilihan;
                    });
                  },

                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem<String>(
                        value: 'A-Z',
                        child: Row(
                          children: [
                            Icon(
                              Icons.sort_by_alpha_rounded,
                              color: _urutanDipilih == 'A-Z'
                                  ? _navy
                                  : Colors.grey,
                            ),

                            const SizedBox(width: 10),

                            const Text('A-Z'),

                            const Spacer(),

                            if (_urutanDipilih == 'A-Z')
                              const Icon(
                                Icons.check,
                                color: _navy,
                                size: 20,
                              ),
                          ],
                        ),
                      ),

                      PopupMenuItem<String>(
                        value: 'Harga tiket termurah',
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_downward_rounded,
                              color: _urutanDipilih ==
                                      'Harga tiket termurah'
                                  ? _navy
                                  : Colors.grey,
                            ),

                            const SizedBox(width: 10),

                            const Text('Harga tiket termurah'),

                            const Spacer(),

                            if (_urutanDipilih ==
                                'Harga tiket termurah')
                              const Icon(
                                Icons.check,
                                color: _navy,
                                size: 20,
                              ),
                          ],
                        ),
                      ),

                      PopupMenuItem<String>(
                        value: 'Harga tiket termahal',
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_upward_rounded,
                              color: _urutanDipilih ==
                                      'Harga tiket termahal'
                                  ? _navy
                                  : Colors.grey,
                            ),

                            const SizedBox(width: 10),

                            const Text('Harga tiket termahal'),

                            const Spacer(),

                            if (_urutanDipilih ==
                                'Harga tiket termahal')
                              const Icon(
                                Icons.check,
                                color: _navy,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),

          // =========================
          // RINGKASAN
          // =========================
          Padding(
            padding:
                const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Container(
              width: double.infinity,

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),

              decoration: BoxDecoration(
                color:
                    _plum.withValues(alpha: 0.18),

                borderRadius:
                    BorderRadius.circular(10),

                border: Border.all(
                  color:
                      _plum.withValues(alpha: 0.45),
                ),
              ),

              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [

                  Flexible(
                    child: Text(
                      '${ringkasan.totalObjek} objek ditampilkan',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.5,
                      ),
                      overflow:
                          TextOverflow.ellipsis,
                    ),
                  ),

                  const SizedBox(width: 8),

                  Flexible(
                    child: Text(
                      'Total tiket: $totalTiketTersisa',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // =========================
          // DAFTAR WISATA
          // =========================
          Expanded(
            child: hasil.isEmpty
                ? _TampilanKosong(
                    kataKunci: _kataKunci,
                  )
                : LayoutBuilder(
                    builder:
                        (context, constraints) {

                      final jumlahKolom =
                          _tentukanJumlahKolom(
                        constraints.maxWidth,
                      );

                      final tinggiGambar =
                          _hitungTinggiGambar(
                        constraints.maxWidth,
                        jumlahKolom,
                      );

                      const tinggiKontenLain =
                          265.0;

                      final tinggiKartu =
                          tinggiGambar +
                              tinggiKontenLain;

                      return GridView.builder(
                        padding:
                            const EdgeInsets.fromLTRB(
                          16,
                          12,
                          16,
                          4,
                        ),

                        itemCount: hasil.length,

                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              jumlahKolom,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          mainAxisExtent:
                              tinggiKartu,
                        ),

                        itemBuilder:
                            (context, index) {

                          final objek =
                              hasil[index];

                          return ObjekWisataCard(
                            data: objek,

                            tinggiGambar: tinggiGambar,

                            onJumlahTiketBerubah: (jumlah) {
                              setState(() {
                                if (jumlah == 0) {
                                  _tiketDipilih.remove(objek.namaObjek);
                                } else {
                                  _tiketDipilih[objek.namaObjek] = jumlah;
                                }
                              });
                            },

                            onLihatRincian: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailWisataPage(
                                    data: objek,
                                  ),
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

// ======================================================
// CHIP KATEGORI
// ======================================================

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
      label: Text(
        label,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.visible,
      ),

      selected: terpilih,

      onSelected: (_) => onTap(),

      selectedColor: _navy,
      backgroundColor: _sand,

      labelStyle: GoogleFonts.poppins(
        color: terpilih
            ? Colors.white
            : const Color(0xFF2C2A28),
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),

      labelPadding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),

      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 5,
      ),

      materialTapTargetSize:
          MaterialTapTargetSize.shrinkWrap,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: _navy.withValues(alpha: 0.25),
        ),
      ),
    );
  }
}

// ======================================================
// TAMPILAN KOSONG
// ======================================================

class _TampilanKosong extends StatelessWidget {
  final String kataKunci;

  const _TampilanKosong({
    required this.kataKunci,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize:
            MainAxisSize.min,

        children: [

          Icon(
            Icons.travel_explore,
            size: 56,
            color:
                _plum.withValues(alpha: 0.5),
          ),

          const SizedBox(height: 12),

          Text(
            kataKunci.isEmpty
                ? 'Tidak ada objek wisata pada kategori ini.'
                : 'Objek wisata "$kataKunci" tidak ditemukan.',

            textAlign:
                TextAlign.center,

            style: const TextStyle(
              fontSize: 13,
              color:
                  Color(0xFF2C2A28),
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            'Coba ubah kata kunci atau kategori.',

            style: TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}