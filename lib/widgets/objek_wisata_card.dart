import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/objek_wisata.dart';
import 'penghitung_tiket.dart';
import '../utils/ikon_kategori.dart';

class ObjekWisataCard extends StatelessWidget {
  final ObjekWisata data;
  final VoidCallback onLihatRincian;
  final double tinggiGambar;
  final ValueChanged<int> onJumlahTiketBerubah;

  const ObjekWisataCard({
    super.key,
    required this.data,
    required this.onLihatRincian,
    required this.tinggiGambar,
    required this.onJumlahTiketBerubah,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: onLihatRincian,
              borderRadius: BorderRadius.circular(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: double.infinity,
                      height: tinggiGambar,
                      child: Hero(
                        tag: 'gambar-wisata${data.namaObjek}',
                        child: Image.asset(
                          data.gambar,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (
                            context,
                            error,
                            stackTrace,
                          ) {
                            return Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFF14213D)
                                    .withValues(alpha: 0.15),
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                ikonUntukJenis(
                                  data.namaObjek,
                                  data.jenis,
                                ),
                                size: 30,
                                color: const Color(0xFF14213D),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    data.namaObjek,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),

                  Text(
                    data.jenis,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  Text(
                    data.ringkasanTarif(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 14),

            PenghitungTiket(
              objek: data,
              onJumlahTiketBerubah: onJumlahTiketBerubah,
            ),
          ],
        ),
      ),
    );
  }
}