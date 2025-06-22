import 'package:flutter/material.dart';
import 'package:rumah_sakit/model/model_rumah_sakit.dart';
import 'package:rumah_sakit/uiscreen/detail_map_rumah_sakit.dart';

class DetailRumahSakit extends StatelessWidget {
  final ModelRumahSakit rumahSakit;

  const DetailRumahSakit({Key? key, required this.rumahSakit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(rumahSakit.namaRumahsakit),
        backgroundColor: const Color(0xFF561C24),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 36,
                    backgroundColor: const Color(0xFFE8D8C4),
                    child: const Icon(Icons.local_hospital, color: Color(0xFF561C24), size: 40),
                  ),
                ),
                const SizedBox(height: 18),
                Center(
                  child: Text(
                    rumahSakit.namaRumahsakit,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Color(0xFF561C24),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFFE8D8C4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      rumahSakit.tipe,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF561C24),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on, size: 20, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        rumahSakit.alamat,
                        style: const TextStyle(fontSize: 15, color: Colors.black87),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.phone, size: 20, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      rumahSakit.noTelp,
                      style: const TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.map, size: 20, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Lat: ${rumahSakit.lat}, Long: ${rumahSakit.long}',
                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF561C24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    icon: const Icon(Icons.map, color: Colors.white),
                    label: const Text(
                      'Lihat di Map',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailMapRumahSakit(rumahSakit: rumahSakit),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
