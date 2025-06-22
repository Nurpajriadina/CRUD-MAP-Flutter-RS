import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rumah_sakit/model/model_rumah_sakit.dart';
import 'package:rumah_sakit/uiscreen/detail_rumah_sakit.dart';
import './tambah_data_rumah_sakit.dart';

class ListDataRumahsakit extends StatefulWidget {
  const ListDataRumahsakit({super.key});

  @override
  State<ListDataRumahsakit> createState() => _ListDataRumahsakitState();
}

class _ListDataRumahsakitState extends State<ListDataRumahsakit> {
  late Future<List<ModelRumahSakit>> futureSakit;

  @override
  void initState() {
    super.initState();
    futureSakit = fetchSakit();
  }

  Future<List<ModelRumahSakit>> fetchSakit() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.69.188:8000/api/rumah-sakit/'),
      );
      if (response.statusCode == 200) {
        return modelRumahSakitFromJson(response.body);
      } else {
        throw Exception('Gagal memuat data rumah sakit');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }

  Future<void> deleteSakit(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://192.168.69.188:8000/api/rumah-sakit/$id'),
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          futureSakit = fetchSakit();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data Rumah Sakit berhasil dihapus')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus data Rumah Sakit')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8D8C4), // background utama
      appBar: AppBar(
        title: const Text('Daftar Rumah Sakit'),
        backgroundColor: const Color(0xFF561C24), // primary color
        elevation: 1,
      ),
      body: FutureBuilder<List<ModelRumahSakit>>(
        future: futureSakit,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Data Rumah Sakit kosong'));
          }

          final sakitList = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                futureSakit = fetchSakit();
              });
              await futureSakit;
            },
            child: ListView.builder(
              itemCount: sakitList.length,
              itemBuilder: (context, index) {
                final sakit = sakitList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  elevation: 4,
                  color: const Color(0xFFF6EEE0), // warna terang dari palet
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailRumahSakit(rumahSakit: sakit),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: const Color(0xFF6D2932),
                            child: const Icon(
                              Icons.local_hospital,
                              color: Color(0xFFE8D8C4),
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sakit.namaRumahsakit,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19,
                                    color: Color(0xFF561C24),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFC7B7A3),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    sakit.tipe,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF561C24),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, size: 16, color: Colors.red),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        sakit.alamat,
                                        style: const TextStyle(fontSize: 13, color: Colors.black87),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.phone, size: 16, color: Colors.green),
                                    const SizedBox(width: 4),
                                    Text(
                                      sakit.noTelp,
                                      style: const TextStyle(fontSize: 13, color: Colors.black87),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.map, size: 16, color: Colors.orange),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        'Lat: ${sakit.lat}, Long: ${sakit.long}',
                                        style: const TextStyle(fontSize: 13, color: Colors.black54),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Color(0xFF6D2932)),
                                tooltip: 'Edit',
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TambahDataRumahSakit(data: sakit),
                                    ),
                                  );
                                  if (result == true) {
                                    setState(() {
                                      futureSakit = fetchSakit();
                                    });
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                tooltip: 'Hapus',
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Konfirmasi Hapus'),
                                      content: Text('Yakin ingin menghapus "${sakit.namaRumahsakit}"?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: const Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          child: const Text(
                                            'Hapus',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    await deleteSakit(sakit.id);
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),

      // FAB: Tambah Rumah Sakit
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TambahDataRumahSakit(),
            ),
          );
          if (result == true) {
            setState(() {
              futureSakit = fetchSakit();
            });
          }
        },
        backgroundColor: const Color(0xFF561C24),
        child: const Icon(
          Icons.local_hospital,
          color: Colors.white,
          size: 28,
        ),
        tooltip: 'Tambah Rumah Sakit',
      ),
    );
  }
}
