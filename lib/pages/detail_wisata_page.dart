import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/objek_wisata.dart';
import '../utils/format_rupiah.dart';

// F5 - HALAMAN RINCIAN
class DetailWisataPage extends StatefulWidget {
  final ObjekWisata data;

  const DetailWisataPage({
    super.key,
    required this.data,
  });

  @override
  State<DetailWisataPage> createState() => _DetailWisataPageState();
}

class _DetailWisataPageState extends State<DetailWisataPage> {
  static const Color _navy = Color(0xFF14213D);
  static const Color _maroon = Color(0xFF6E3B4C);
  static const Color _bg = Color(0xFFF3ECDD);

  late final PageController _pageController;
  late final List<String> _gambarGaleri;

  final FocusNode _galeriFocusNode = FocusNode();

  double _currentPage = 0;

  @override
  void initState() {
    super.initState();

    _gambarGaleri = widget.data.galeriGambar.isNotEmpty
        ? widget.data.galeriGambar
        : [widget.data.gambarUntukDetail];

    _pageController = PageController(
      viewportFraction: 1.0,
    );

    _pageController.addListener(() {
      if (mounted) {
        setState(() {
          _currentPage = _pageController.page ?? 0;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _galeriFocusNode.dispose();
    super.dispose();
  }

  void _keSLideSebelumnya() {
    if (_pageController.page != null &&
        _pageController.page! > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _keSlideSelanjutnya() {
    if (_pageController.page != null &&
        _pageController.page! < _gambarGaleri.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: Text(
          data.namaObjek,
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: _navy,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth >= 700;

          // HP dibuat lebih rapat.
          final double horizontalPadding = isWide
              ? (constraints.maxWidth >= 900 ? 32 : 16)
              : 12;

          final double verticalPadding = isWide ? 14 : 10;

          // =====================================================
          // TINGGI GALERI
          // =====================================================
          //
          // Sebelumnya:
          // tinggi layar * 0.52
          //
          // Akibatnya di HP galeri menjadi terlalu tinggi
          // sehingga gambar berada di tengah dan muncul ruang
          // kosong besar di atas/bawah.
          //
          // Sekarang tinggi mengikuti lebar layar.
          //
          final double tinggiGaleri;

          if (isWide) {
            tinggiGaleri =
                (constraints.maxWidth * 0.42).clamp(
              360.0,
              500.0,
            );
          } else {
            tinggiGaleri =
                (constraints.maxWidth * 0.67).clamp(
              190.0,
              240.0,
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1100,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    // =====================================================
                    // GALERI
                    // =====================================================
                    SizedBox(
                      height: tinggiGaleri,
                      child: KeyboardListener(
                        focusNode: _galeriFocusNode,
                        autofocus: true,
                        onKeyEvent: (event) {
                          if (event is KeyDownEvent) {
                            if (event.logicalKey ==
                                LogicalKeyboardKey.arrowLeft) {
                              _keSLideSebelumnya();
                            }

                            if (event.logicalKey ==
                                LogicalKeyboardKey.arrowRight) {
                              _keSlideSelanjutnya();
                            }
                          }
                        },
                        child: PageView.builder(
                          controller: _pageController,
                          physics:
                              const _BouncyPageScrollPhysics(),
                          itemCount: _gambarGaleri.length,
                          itemBuilder: (context, index) {
                            final double selisih =
                                (_currentPage - index)
                                    .abs()
                                    .clamp(0.0, 1.0);

                            final double skala =
                                1 - (selisih * 0.26);

                            final double opasitas =
                                (1 - (selisih * 0.25))
                                    .clamp(0.75, 1.0);

                            final gambar = ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(
                                isWide ? 18 : 16,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _maroon,
                                    width: 2,
                                  ),
                                  color: _navy.withValues(
                                    alpha: 0.08,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withValues(
                                        alpha: 0.18,
                                      ),
                                      blurRadius: 16,
                                      offset:
                                          const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  _gambarGaleri[index],
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) {
                                    return Container(
                                      color: _navy.withValues(
                                        alpha: 0.15,
                                      ),
                                      alignment:
                                          Alignment.center,
                                      child: const Icon(
                                        Icons
                                            .image_not_supported_outlined,
                                        size: 48,
                                        color: _navy,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );

                            return Center(
                              child: Transform.scale(
                                scale: skala,
                                child: Opacity(
                                  opacity: opasitas,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(
                                      horizontal:
                                          isWide ? 9 : 6,
                                    ),
                                    child: index == 0
                                        ? Hero(
                                            tag:
                                                'gambar-wisata${data.namaObjek}',
                                            child: gambar,
                                          )
                                        : gambar,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // =====================================================
                    // INDIKATOR SLIDE
                    // =====================================================
                    if (_gambarGaleri.length > 1) ...[
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: List.generate(
                          _gambarGaleri.length,
                          (index) {
                            final bool aktif =
                                _currentPage.round() == index;

                            return AnimatedContainer(
                              duration: const Duration(
                                milliseconds: 250,
                              ),
                              curve: Curves.easeOut,
                              margin:
                                  const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              width: aktif ? 20 : 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: aktif
                                    ? _maroon
                                    : _maroon.withValues(
                                        alpha: 0.3,
                                      ),
                                borderRadius:
                                    BorderRadius.circular(
                                  10,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],

                    // =====================================================
                    // JARAK INDIKATOR -> CARD
                    // =====================================================
                    const SizedBox(height: 10),

                    // =====================================================
                    // CARD INFORMASI
                    // =====================================================
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isWide ? 16 : 14,
                        vertical: isWide ? 9 : 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: 0.06,
                            ),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.stretch,
                        children: [
                          // =================================================
                          // INFORMASI DESKTOP / LAPTOP
                          // =================================================
                          isWide
                              ? Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          _BarisRincian(
                                            icon: Icons.account_balance_outlined,
                                            label: 'Nama Objek',
                                            nilai:
                                                data.namaObjek,
                                          ),
                                          _BarisRincian(
                                            icon: Icons.location_on_outlined,
                                            label: 'lokasi',
                                            nilai:  data.lokasi,
                                          ),
                                          _BarisRincian(
                                            icon: Icons.sell_outlined,
                                            label: 'Jenis',
                                            nilai: data.jenis,
                                          ),
                                          _BarisRincian(
                                            icon: Icons.confirmation_number_outlined,
                                            label: 'Tiket Dewasa',
                                            nilai:
                                                formatRupiah(
                                              data.tiketDewasa,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(width: 16),

                                    Expanded(
                                      child: Column(
                                        children: [
                                          _BarisRincian(
                                            icon: Icons
                                                .confirmation_number_outlined,
                                            label: 'Tiket Anak',
                                            nilai:
                                                formatRupiah(
                                              data.tiketAnak,
                                            ),
                                          ),
                                          _BarisRincian(
                                            icon: Icons
                                                .groups_outlined,
                                            label: 'Kuota Harian',
                                            nilai:
                                                '${data.kuotaHarian} orang',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )

                              // =================================================
                              // INFORMASI HP
                              // =================================================
                              : Column(
                                  children: [
                                    _BarisRincian(
                                      icon: Icons.account_balance_outlined,
                                      label: 'Nama Objek',
                                      nilai: data.namaObjek,
                                    ),

                                    _BarisRincian(
                                      icon: Icons.location_on_outlined,
                                      label: 'Lokasi',
                                      nilai: data.lokasi,
                                    ),

                                    _BarisRincian(
                                      icon: Icons.sell_outlined,
                                      label: 'Jenis',
                                      nilai: data.jenis,
                                    ),
                                    _BarisRincian(
                                      icon: Icons
                                          .confirmation_number_outlined,
                                      label: 'Tiket Dewasa',
                                      nilai: formatRupiah(
                                        data.tiketDewasa,
                                      ),
                                    ),
                                    _BarisRincian(
                                      icon:
                                          Icons.person_outline,
                                      label: 'Tiket Anak',
                                      nilai: formatRupiah(
                                        data.tiketAnak,
                                      ),
                                    ),
                                    _BarisRincian(
                                      icon:
                                          Icons.groups_outlined,
                                      label: 'Kuota Harian',
                                      nilai:
                                          '${data.kuotaHarian} orang',
                                    ),
                                  ],
                                ),

                          const SizedBox(height: 2),

                          // =================================================
                          // CATATAN DISKON
                          // =================================================
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              color: _maroon.withValues(
                                alpha: 0.12,
                              ),
                              borderRadius:
                                  BorderRadius.circular(10),
                              border: Border.all(
                                color: _maroon.withValues(
                                  alpha: 0.35,
                                ),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 10,
                                  backgroundColor: _maroon,
                                  child: const Icon(
                                    Icons.info_outline,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Ingat: rombongan dengan 20 orang atau lebih '
                                    'otomatis mendapat potongan harga 15% pada '
                                    'halaman utama',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11.5,
                                      color:
                                          Colors.grey.shade800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
// FISIKA SCROLL BIAR ADA EFEK "MANTUL"
// ========================================
class _BouncyPageScrollPhysics
    extends PageScrollPhysics {
  const _BouncyPageScrollPhysics({
    super.parent,
  });

  @override
  _BouncyPageScrollPhysics applyTo(
    ScrollPhysics? ancestor,
  ) {
    return _BouncyPageScrollPhysics(
      parent: buildParent(ancestor),
    );
  }

  @override
  SpringDescription get spring =>
      SpringDescription.withDampingRatio(
        mass: 0.5,
        stiffness: 100,
        ratio: 0.65,
      );
}

// ========================================
// BARIS INFORMASI
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
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor:
                const Color(0xFF6E3B4C),
            child: Icon(
              icon,
              color: Colors.white,
              size: 14,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  nilai,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
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