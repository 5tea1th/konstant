import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/artisan_products_controller.dart';

class ArtisanAddProductPage extends StatefulWidget {
  const ArtisanAddProductPage({super.key});

  @override
  State<ArtisanAddProductPage> createState() => _ArtisanAddProductPageState();
}

class _ArtisanAddProductPageState extends State<ArtisanAddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = ArtisanProductsController();

  String title = '';
  String description = '';
  String category = '';
  int priceINR = 0;
  int stock = 0;

  final List<File> _photos = [];

  Future<void> _pickImage() async {
    if (_photos.length >= 5) return;
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _photos.add(File(picked.path));
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    await _controller.addProduct(
      title: title,
      description: description,
      category: category,
      priceINR: priceINR,
      stock: stock,
      photos: _photos,
    );

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Product")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Title"),
                onSaved: (val) => title = val ?? '',
                validator: (val) => val!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Description"),
                onSaved: (val) => description = val ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Category"),
                onSaved: (val) => category = val ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Price (INR)"),
                keyboardType: TextInputType.number,
                onSaved: (val) => priceINR = int.tryParse(val ?? '0') ?? 0,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Stock"),
                keyboardType: TextInputType.number,
                onSaved: (val) => stock = int.tryParse(val ?? '0') ?? 0,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ..._photos.map((file) => Image.file(file, width: 80, height: 80, fit: BoxFit.cover)),
                  if (_photos.length < 5)
                    InkWell(
                      onTap: _pickImage,
                      child: Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.add_a_photo),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}