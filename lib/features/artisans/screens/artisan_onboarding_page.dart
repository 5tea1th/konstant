import 'dart:io';
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

  // ✅ TextEditingControllers
  final displayNameController = TextEditingController();
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();

  File? aadhaarFile;
  File? panFile;
  File? selfieFile;

  Future<void> pickAadhaar() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => aadhaarFile = File(picked.path));
  }

  Future<void> pickPan() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => panFile = File(picked.path));
  }

  Future<void> captureSelfie() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) setState(() => selfieFile = File(picked.path));
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please capture a selfie')),
      );
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
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Onboarding submitted successfully!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ArtisanHome()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
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
      appBar: AppBar(title: const Text('Artisan Onboarding')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: displayNameController,
                decoration: const InputDecoration(labelText: 'Display Name'),
                validator: (v) => v!.isEmpty ? 'Enter your name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: address1Controller,
                decoration: const InputDecoration(labelText: 'Address Line 1'),
                validator: (v) => v!.isEmpty ? 'Enter address line 1' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: address2Controller,
                decoration: const InputDecoration(labelText: 'Address Line 2'),
                validator: (v) => v!.isEmpty ? 'Enter address line 2' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: cityController,
                decoration: const InputDecoration(labelText: 'City'),
                validator: (v) => v!.isEmpty ? 'Enter city' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: stateController,
                decoration: const InputDecoration(labelText: 'State'),
                validator: (v) => v!.isEmpty ? 'Enter state' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: countryController,
                decoration: const InputDecoration(labelText: 'Country'),
                validator: (v) => v!.isEmpty ? 'Enter country' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.upload_file),
                label: Text(aadhaarFile == null ? 'Upload Aadhaar' : 'Change Aadhaar'),
                onPressed: pickAadhaar,
              ),
              if (aadhaarFile != null) ...[
                const SizedBox(height: 10),
                Image.file(aadhaarFile!, height: 150),
              ],
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.upload_file),
                label: Text(panFile == null ? 'Upload PAN' : 'Change PAN'),
                onPressed: pickPan,
              ),
              if (panFile != null) ...[
                const SizedBox(height: 10),
                Image.file(panFile!, height: 150),
              ],
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: Text(selfieFile == null ? 'Capture Selfie' : 'Retake Selfie'),
                onPressed: captureSelfie,
              ),
              if (selfieFile != null) ...[
                const SizedBox(height: 10),
                Image.file(selfieFile!, height: 150),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}