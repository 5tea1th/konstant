import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/artisan_onboarding_controller.dart';
import 'artisan_home.dart';

class ArtisanOnboardingPage extends StatefulWidget {
  const ArtisanOnboardingPage({super.key});

  @override
  State<ArtisanOnboardingPage> createState() => _ArtisanOnboardingPageState();
}

class _ArtisanOnboardingPageState extends State<ArtisanOnboardingPage> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  final _controller = ArtisanOnboardingController();

  // TextEditingControllers
  final displayNameController = TextEditingController();
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();

  // File objects for mobile
  File? aadhaarFile;
  File? panFile;
  File? selfieFile;

  // Bytes for web display
  Uint8List? aadhaarBytes;
  Uint8List? panBytes;
  Uint8List? selfieBytes;

  Future<void> pickAadhaar() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        aadhaarFile = File(picked.path);
        aadhaarBytes = bytes;
      });
    }
  }

  Future<void> pickPan() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        panFile = File(picked.path);
        panBytes = bytes;
      });
    }
  }

  Future<void> captureSelfie() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        selfieFile = File(picked.path);
        selfieBytes = bytes;
      });
    }
  }

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (aadhaarFile == null || panFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload both Aadhaar and PAN')),
      );
      return;
    }

    if (selfieFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please capture a selfie')));
      return;
    }

    try {
      await _controller.submitOnboarding(
        displayName: displayNameController.text.trim(),
        addressLine1: address1Controller.text.trim(),
        addressLine2: address2Controller.text.trim(),
        city: cityController.text.trim(),
        state: stateController.text.trim(),
        country: countryController.text.trim(),
        aadhaarFile: aadhaarFile!,
        panFile: panFile!,
        selfieFile: selfieFile!,
        aadhaarBytes: aadhaarBytes, // Pass bytes for web
        panBytes: panBytes, // Pass bytes for web
        selfieBytes: selfieBytes, // Pass bytes for web
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Onboarding submitted successfully!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ArtisanHome()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Widget _buildImagePreview(Uint8List? bytes, String label) {
    if (bytes == null) return const SizedBox.shrink();

    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(bytes, height: 150, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$label uploaded',
          style: TextStyle(
            color: Colors.green.shade600,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    displayNameController.dispose();
    address1Controller.dispose();
    address2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artisan Onboarding'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Personal Information Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Personal Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: displayNameController,
                        decoration: const InputDecoration(
                          labelText: 'Display Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (v) => v!.isEmpty ? 'Enter your name' : null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Address Information Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Address Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: address1Controller,
                        decoration: const InputDecoration(
                          labelText: 'Address Line 1',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_on),
                        ),
                        validator: (v) =>
                            v!.isEmpty ? 'Enter address line 1' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: address2Controller,
                        decoration: const InputDecoration(
                          labelText: 'Address Line 2',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_on),
                        ),
                        validator: (v) =>
                            v!.isEmpty ? 'Enter address line 2' : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: cityController,
                              decoration: const InputDecoration(
                                labelText: 'City',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.location_city),
                              ),
                              validator: (v) =>
                                  v!.isEmpty ? 'Enter city' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: stateController,
                              decoration: const InputDecoration(
                                labelText: 'State',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.map),
                              ),
                              validator: (v) =>
                                  v!.isEmpty ? 'Enter state' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: countryController,
                        decoration: const InputDecoration(
                          labelText: 'Country',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.public),
                        ),
                        validator: (v) => v!.isEmpty ? 'Enter country' : null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Document Upload Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Document Verification',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Aadhaar Upload
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.upload_file),
                          label: Text(
                            aadhaarFile == null
                                ? 'Upload Aadhaar Card'
                                : 'Change Aadhaar Card',
                          ),
                          onPressed: pickAadhaar,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: aadhaarFile == null
                                ? Colors.grey
                                : Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      _buildImagePreview(aadhaarBytes, 'Aadhaar Card'),
                      const SizedBox(height: 16),

                      // PAN Upload
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.upload_file),
                          label: Text(
                            panFile == null
                                ? 'Upload PAN Card'
                                : 'Change PAN Card',
                          ),
                          onPressed: pickPan,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: panFile == null
                                ? Colors.grey
                                : Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      _buildImagePreview(panBytes, 'PAN Card'),
                      const SizedBox(height: 16),

                      // Selfie Capture
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.camera_alt),
                          label: Text(
                            selfieFile == null
                                ? 'Capture Selfie'
                                : 'Retake Selfie',
                          ),
                          onPressed: captureSelfie,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selfieFile == null
                                ? Colors.blue
                                : Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      _buildImagePreview(selfieBytes, 'Selfie'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Submit Onboarding',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Info text
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Your documents will be verified within 24-48 hours. You\'ll receive a notification once approved.',
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
