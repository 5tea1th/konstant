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

  String displayName = '';
  String addressLine1 = '';
  String addressLine2 = '';
  String city = '';
  String state = '';
  String country = '';
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

    _formKey.currentState!.save();

    try {
      await _controller.submitOnboarding(
        displayName: displayName,
        addressLine1: addressLine1,
        addressLine2: addressLine2,
        city: city,
        state: state,
        country: country,
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
                decoration: const InputDecoration(labelText: 'Display Name'),
                validator: (v) => v!.isEmpty ? 'Enter your name' : null,
                onSaved: (v) => displayName = v!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Address Line 1'),
                validator: (v) => v!.isEmpty ? 'Enter address line 1' : null,
                onSaved: (v) => addressLine1 = v!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Address Line 2'),
                validator: (v) => v!.isEmpty ? 'Enter address line 2' : null,
                onSaved: (v) => addressLine2 = v!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'City'),
                validator: (v) => v!.isEmpty ? 'Enter city' : null,
                onSaved: (v) => city = v!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'State'),
                validator: (v) => v!.isEmpty ? 'Enter state' : null,
                onSaved: (v) => state = v!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Country'),
                validator: (v) => v!.isEmpty ? 'Enter country' : null,
                onSaved: (v) => country = v!,
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