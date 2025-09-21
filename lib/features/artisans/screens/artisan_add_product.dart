import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/artisan_products_controller.dart';
import '../../../demo_state.dart';

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
  final List<Uint8List> _photoBytes = []; // For web compatibility
  bool _isUploading = false;
  String _uploadStatus = '';

  Future<void> _pickImage() async {
    if (_photos.length >= 5) return;
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _photos.add(File(picked.path));
        _photoBytes.add(bytes);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _photos.removeAt(index);
      _photoBytes.removeAt(index);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _photos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all fields and add at least one photo"),
        ),
      );
      return;
    }
    _formKey.currentState!.save();

    setState(() {
      _isUploading = true;
      _uploadStatus = 'Uploading product...';
    });

    try {
      // Step 1: Upload product and get result
      final result = await _controller.addProduct(
        title: title,
        description: description,
        category: category,
        priceINR: priceINR,
        stock: stock,
        photos: _photos,
        photoBytes: _photoBytes,
      );

      // Step 2: Extract data from result
      final String productId =
          result['productId'] ??
          DateTime.now().millisecondsSinceEpoch.toString();
      final String? firstImageUrl = result['firstImageUrl'];

      // Step 3: Update demo state
      final demoState = Provider.of<DemoState>(context, listen: false);
      demoState.addProduct(title, imageUrl: firstImageUrl);

      setState(() {
        _uploadStatus = 'Product uploaded! Generating reel...';
      });

      // Step 4: Generate reel
      await _generateReel(productId);

      // Step 5: Success
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Product added and reel generated successfully!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() => _isUploading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _generateReel(String productId) async {
    try {
      setState(() {
        _uploadStatus = 'Calling reel generation service...';
      });

      // Call your cloud function
      final response = await http.post(
        Uri.parse(
          'https://reel-transcript-service-546548502432.asia-south1.run.app/generate',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'doc_id': productId}),
      );

      if (response.statusCode == 200) {
        // Parse response
        final responseData = json.decode(response.body);

        setState(() {
          _uploadStatus = 'Reel generated successfully!';
        });

        // Step 5: Add reel to demo state
        final demoState = Provider.of<DemoState>(context, listen: false);

        // Get the current artisan ID from Firebase Auth
        final artisanId = FirebaseAuth.instance.currentUser!.uid;

        final reelStoragePath =
            'gs://artisan-app-media/artisans/$artisanId/products/$productId/final_reel.mp4';
        demoState.addReel(
          '$title Reel',
          reelStoragePath,
        ); // Store title and path together

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Reel generated and saved!"),
              backgroundColor: Colors.blue,
            ),
          );
        }
      } else {
        throw Exception('Reel generation failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Reel generation error: $e');
      setState(() {
        _uploadStatus = 'Reel generation failed, but product was saved.';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Product saved, but reel generation failed: $e"),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _isUploading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    _uploadStatus,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Please wait while we process your product...",
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Title
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Product Title",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.title),
                      ),
                      onSaved: (val) => title = val ?? '',
                      validator: (val) =>
                          val?.isEmpty ?? true ? "Title is required" : null,
                    ),
                    SizedBox(height: 16),

                    // Description
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                      ),
                      maxLines: 3,
                      onSaved: (val) => description = val ?? '',
                      validator: (val) => val?.isEmpty ?? true
                          ? "Description is required"
                          : null,
                    ),
                    SizedBox(height: 16),

                    // Category
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Category",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.category),
                      ),
                      onSaved: (val) => category = val ?? '',
                    ),
                    SizedBox(height: 16),

                    // Price and Stock Row
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: "Price (₹)",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.currency_rupee),
                            ),
                            keyboardType: TextInputType.number,
                            onSaved: (val) =>
                                priceINR = int.tryParse(val ?? '0') ?? 0,
                            validator: (val) {
                              final price = int.tryParse(val ?? '0') ?? 0;
                              return price <= 0 ? "Enter valid price" : null;
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: "Stock",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.inventory),
                            ),
                            keyboardType: TextInputType.number,
                            onSaved: (val) =>
                                stock = int.tryParse(val ?? '0') ?? 0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),

                    // Photos Section
                    Text(
                      "Product Photos (Required)",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Add up to 5 photos of your product",
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 12),

                    // Photo Grid
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        // Display selected images
                        for (int i = 0; i < _photoBytes.length; i++)
                          Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.memory(
                                    _photoBytes[i],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () => _removeImage(i),
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                        // Add photo button
                        if (_photos.length < 5)
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_a_photo,
                                    size: 32,
                                    color: Colors.grey.shade600,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Add Photo",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),

                    if (_photos.isEmpty)
                      Container(
                        margin: EdgeInsets.only(top: 8),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info, color: Colors.orange, size: 20),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Please add at least one photo to continue",
                                style: TextStyle(color: Colors.orange.shade800),
                              ),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isUploading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _isUploading
                              ? "Processing..."
                              : "Add Product & Generate Reel",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Info text
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Your product will be automatically processed to generate a marketing reel!",
                              style: TextStyle(
                                color: Colors.blue.shade800,
                                fontSize: 14,
                              ),
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
  }
}
