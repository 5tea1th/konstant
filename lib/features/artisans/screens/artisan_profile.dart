import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class ArtisanProfile extends StatefulWidget {
  const ArtisanProfile({super.key});

  @override
  State<ArtisanProfile> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ArtisanProfile> {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _bioController = TextEditingController();

  String? profilePhotoUrl;
  String? introVideoUrl;

  File? _imageFile;
  File? _videoFile;

  bool isLoading = true;
  late VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final doc = await FirebaseFirestore.instance
        .collection("artisans")
        .doc(userId)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      _nameController.text = data["displayName"] ?? "";
      _bioController.text = data["bio"] ?? "";
      profilePhotoUrl = data["profilePhotoUrl"];
      introVideoUrl = data["introVideoUrl"];

      if (introVideoUrl != null) {
        _videoController = VideoPlayerController.network(introVideoUrl!)
          ..initialize().then((_) => setState(() {}));
      }
    }
    setState(() => isLoading = false);
  }

  Future<String> _uploadFile(File file, String path) async {
    final ref = FirebaseStorage.instanceFor(
        bucket: "gs://artisan-app-media"
    ).ref().child(path);
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    String? imageUrl = profilePhotoUrl;
    String? videoUrl = introVideoUrl;

    if (_imageFile != null) {
      imageUrl = await _uploadFile(_imageFile!, "artisans/$userId/profile.jpg");
    }

    if (_videoFile != null) {
      videoUrl = await _uploadFile(_videoFile!, "artisans/$userId/intro.mp4");
    }

    await FirebaseFirestore.instance.collection("artisans").doc(userId).update({
      "displayName": _nameController.text.trim(),
      "bio": _bioController.text.trim(),
      "profilePhotoUrl": imageUrl,
      "introVideoUrl": videoUrl,
    });

    setState(() {
      profilePhotoUrl = imageUrl;
      introVideoUrl = videoUrl;
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated successfully")),
    );
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  Future<void> _pickVideo() async {
    final picked = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _videoFile = File(picked.path));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Image
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : (profilePhotoUrl != null ? NetworkImage(profilePhotoUrl!) : null) as ImageProvider?,
                  child: _imageFile == null && profilePhotoUrl == null
                      ? const Icon(Icons.add_a_photo, size: 40)
                      : null,
                ),
              ),
              const SizedBox(height: 16),

              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (val) => val!.isEmpty ? "Enter your name" : null,
              ),
              const SizedBox(height: 12),

              // Bio
              TextFormField(
                controller: _bioController,
                decoration: const InputDecoration(labelText: "Bio"),
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              // Intro Video
              Column(
                children: [
                  if (_videoFile != null)
                    Text("New video selected: ${_videoFile!.path.split('/').last}"),
                  if (_videoFile == null && introVideoUrl != null && _videoController != null)
                    AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    ),
                  TextButton.icon(
                    onPressed: _pickVideo,
                    icon: const Icon(Icons.video_call),
                    label: const Text("Upload Intro Video"),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Save button
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}