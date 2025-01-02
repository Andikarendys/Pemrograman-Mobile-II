// To parse this JSON data, do
//
//     final barang = barangFromJson(jsonString);

import 'dart:convert';

List<Barang> barangFromJson(String str) => List<Barang>.from(json.decode(str).map((x) => Barang.fromJson(x)));

String barangToJson(List<Barang> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Barang {
    int id;
    String kodebarang;
    String namabarang;
    int hargabarang;
    int stokbarang;
    String gambarbarang;
    DateTime createdAt;
    DateTime updatedAt;

    Barang({
        required this.id,
        required this.kodebarang,
        required this.namabarang,
        required this.hargabarang,
        required this.stokbarang,
        required this.gambarbarang,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Barang.fromJson(Map<String, dynamic> json) => Barang(
        id: json["id"],
        kodebarang: json["kodebarang"],
        namabarang: json["namabarang"],
        hargabarang: json["hargabarang"],
        stokbarang: json["stokbarang"],
        gambarbarang: json["gambarbarang"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "kodebarang": kodebarang,
        "namabarang": namabarang,
        "hargabarang": hargabarang,
        "stokbarang": stokbarang,
        "gambarbarang": gambarbarang,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
