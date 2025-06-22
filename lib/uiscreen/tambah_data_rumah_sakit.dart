import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:rumah_sakit/model/model_rumah_sakit.dart';
import 'package:rumah_sakit/uiscreen/list_data_rumahsakit.dart';

class TambahDataRumahSakit extends StatefulWidget {
  final ModelRumahSakit? data;

  const TambahDataRumahSakit({Key? key, this.data}) : super(key: key);

  @override
  State<TambahDataRumahSakit> createState() => _TambahDataRumahSakitState();
}

class _TambahDataRumahSakitState extends State<TambahDataRumahSakit> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController namaSakitController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController teleponController = TextEditingController();
  final TextEditingController tipeController = TextEditingController();
  final TextEditingController latController = TextEditingController();
  final TextEditingController longController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      namaSakitController.text = widget.data!.namaRumahsakit;
      alamatController.text = widget.data!.alamat;
      teleponController.text = widget.data!.noTelp;
      tipeController.text = widget.data!.tipe;
      latController.text =
          widget.data != null ? widget.data!.lat.toString() : '';
      longController.text =
          widget.data != null ? widget.data!.long.toString() : '';
    }
  }

  Future<void> simpanData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final model = ModelRumahSakit(
      namaRumahsakit: namaSakitController.text,
      alamat: alamatController.text,
      noTelp: teleponController.text,
      tipe: tipeController.text,
      lat: double.tryParse(latController.text) ?? 0.0,
      long: double.tryParse(longController.text) ?? 0.0,
      updatedAt: DateTime.now(),
      createdAt: widget.data?.createdAt ?? DateTime.now(),
      id: widget.data?.id ?? 0,
    );

    http.Response response;
    if (widget.data == null) {
      response = await http.post(
        Uri.parse('http://192.168.69.188:8000/api/rumah-sakit/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(model.toJson()),
      );
    } else {
      response = await http.put(
        Uri.parse('http://192.168.69.188:8000/api/rumah-sakit/${model.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(model.toJson()),
      );
    }

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 201 || response.statusCode == 200) {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ListDataRumahsakit()),
          (route) => false,
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan data: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8D8C4),
      appBar: AppBar(
        title: Text(
          widget.data == null
              ? 'Tambah Data Rumah Sakit'
              : 'Edit Data Rumah Sakit',
        ),
        backgroundColor: const Color(0xFF561C24),
        elevation: 1,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: namaSakitController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Rumah Sakit',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.local_hospital_sharp),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: alamatController,
                        decoration: const InputDecoration(
                          labelText: 'Alamat',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.import_contacts),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Alamat wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: teleponController,
                        decoration: const InputDecoration(
                          labelText: 'No Telepon',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'No Telepon wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: tipeController,
                        decoration: const InputDecoration(
                          labelText: 'Tipe',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.merge_type),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Tipe wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: latController,
                        decoration: const InputDecoration(
                          labelText: 'Lat',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.satellite_alt),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Lat wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: longController,
                        decoration: const InputDecoration(
                          labelText: 'Long',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.satellite_alt),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Long wajib diisi' : null,
                      ),
                      const SizedBox(height: 28),
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: simpanData,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF561C24),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  widget.data == null ? 'Simpan' : 'Update',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
