import 'package:flutter/material.dart';
import '../models/objek_wisata.dart';
import 'penghitung_tiket.dart';

class ObjekWisataCard extends StatelessWidget{
    final ObjekWisata data;
    final VoidCallback onLihatRincian;

    const ObjekWisataCard({
        super.key,
        required this.data,
        required this.onLihatRincian,
    });

    @override
    Widget build(BuildContext context) {
        return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
                                    Container(
                                        height: 64,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: const Color(0xFF1B4B43).withOpacity(0.12), //Deep Teal
                                            borderRadius: BorderRadius.circular(10),
                                        ),
                                        alignment: Alignment.center,
                                        child: const Icon(
                                            Icons.landscape_outlined,
                                            size: 30,
                                            color: Color(0xFF1B4B43),//deep teal
                                        ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                        data.namaObjek,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                        ),
                                    ),
                                    Text(
                                        data.jenis,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                    ),
                                    Text(
                                        data.ringkasanTarif(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 11),
                                    ),
                                ],
                            ),
                        ),
                        const Divider(height: 14),
                        PenghitungTiket(objek: data),
                    ],
                ),
            ),
        );
    }
}