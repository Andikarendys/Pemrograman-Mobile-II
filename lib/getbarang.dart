import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'barang.dart';

class GetBarang extends StatefulWidget {
  const GetBarang({super.key});

  @override
  State<GetBarang> createState() => _GetBarangState();
}

class _GetBarangState extends State<GetBarang> {
  List<Barang> barangList = [];
  bool _isLoading = false;

  File? imageFile;

  @override
  void initState() {
    super.initState();
    _fetchBarang();
  }

  Future<void> _fetchBarang() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response =
          await http.get(Uri.parse('http://andika.mobilekelasa.my.id/barang'));

      if (response.statusCode == 200) {
        final List<Barang> loadedBarang = barangFromJson(response.body);
        setState(() {
          barangList = loadedBarang;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load barang');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showCustomSnackBar('Error: ${e.toString()}', isError: true);
    }
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
    );
  }

  void _showCustomSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  Future<void> _addBarang() async {
    final result = await showDialog<Barang>(
      context: context,
      builder: (BuildContext context) {
        final namaBarangController = TextEditingController();
        final kodeBarangController = TextEditingController();
        final hargaBarangController = TextEditingController();
        final stokBarangController = TextEditingController();

        return AlertDialog(
          title: const Text('Tambah Barang',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(namaBarangController, 'Nama Barang', Icons.label),
              const SizedBox(height: 10),
              _buildTextField(kodeBarangController, 'Kode Barang', Icons.code),
              const SizedBox(height: 10),
              _buildTextField(
                  hargaBarangController, 'Harga Barang', Icons.attach_money,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 10),
              _buildTextField(
                  stokBarangController, 'Stok Barang', Icons.inventory,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                  onPressed: () {
                    PickImageFromGallery();
                  },
                  label: Text('Gambar'),
                  icon: Icon(Icons.image))
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final response = await http.post(
                      Uri.parse(
                          'http://andika.mobilekelasa.my.id/barang/simpan'),
                      body: {
                        'namabarang': namaBarangController.text,
                        'kodebarang': kodeBarangController.text,
                        'hargabarang': hargaBarangController.text,
                        'stokbarang': stokBarangController.text,
                        'gambarbarang': 'default.jpg'
                      });

                  if (response.statusCode == 200) {
                    final newBarang =
                        Barang.fromJson(jsonDecode(response.body));
                    Navigator.pop(context, newBarang);
                  } else {
                    throw Exception('Failed to add barang');
                  }
                } catch (e) {
                  _showCustomSnackBar('Error: ${e.toString()}', isError: true);
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        barangList.add(result);
      });
      _showCustomSnackBar('Barang berhasil ditambahkan');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Barang'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: barangList.length,
              itemBuilder: (context, index) {
                final barang = barangList[index];
                return ListTile(
                  title: Text(barang.namabarang),
                  subtitle: Text(
                      'Kode: ${barang.kodebarang} - Stok: ${barang.stokbarang}'),
                  trailing: Text(
                    'Rp ${barang.hargabarang.toString()}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBarang,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> PickImageFromGallery() async {
    final picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );
      
      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
        _showCustomSnackBar('Gambar berhasil dipilih');
      }
    } catch (e) {
      _showCustomSnackBar('Error saat memilih gambar: $e', isError: true);
    }
  }
}
