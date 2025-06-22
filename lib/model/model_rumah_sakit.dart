import 'dart:convert';

List<ModelRumahSakit> modelRumahSakitFromJson(String str) =>
    List<ModelRumahSakit>.from(json.decode(str).map((x) => ModelRumahSakit.fromJson(x)));

String modelRumahSakitToJson(List<ModelRumahSakit> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelRumahSakit {
  String namaRumahsakit;
  String alamat;
  String noTelp;
  String tipe;
  double lat;
  double long;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  ModelRumahSakit({
    required this.namaRumahsakit,
    required this.alamat,
    required this.noTelp,
    required this.tipe,
    required this.lat,
    required this.long,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory ModelRumahSakit.fromJson(Map<String, dynamic> json) => ModelRumahSakit(
        namaRumahsakit: json["nama_rumahsakit"],
        alamat: json["alamat"],
        noTelp: json["no_telp"],
        tipe: json["tipe"],
        lat: (json["lat"] as num).toDouble(),
        long: (json["long"] as num).toDouble(),
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "nama_rumahsakit": namaRumahsakit,
        "alamat": alamat,
        "no_telp": noTelp,
        "tipe": tipe,
        "lat": lat,
        "long": long,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}
