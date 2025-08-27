import 'package:flutter/material.dart';
import 'dart:io';
import '../../utils/colors.dart';
import '../../services/auth_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({super.key});

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  final AuthService _authService = AuthService();
  final ImagePicker _picker = ImagePicker();
  File? _selectedAvatar;
  final List<File?> _selectedImages = List.filled(4, null);
  int _uploadedCount = 0;
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textLight),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Upload Photos',
          style: TextStyle(
            color: textLight,
            fontFamily: 'Medium',
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add your best photos',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textLight,
                  fontFamily: 'Bold',
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Upload an avatar and at least 4 photos to continue',
                style: TextStyle(
                  fontSize: 14,
                  color: textGrey,
                  fontFamily: 'Regular',
                ),
              ),

              const SizedBox(height: 20),

              // Progress Indicator
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.photo_library,
                      color: primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isUploading
                                ? 'Uploading... ${(_uploadProgress * 100).toInt()}%'
                                : '${_uploadedCount}/5 uploaded',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: textLight,
                              fontFamily: 'Medium',
                            ),
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: _isUploading
                                ? _uploadProgress
                                : _uploadedCount / 5,
                            backgroundColor: surface,
                            valueColor: AlwaysStoppedAnimation<Color>(primary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Avatar Section
              const Text(
                'Profile Avatar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textLight,
                  fontFamily: 'Medium',
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'This will be your main profile picture',
                style: TextStyle(
                  fontSize: 14,
                  color: textGrey,
                  fontFamily: 'Regular',
                ),
              ),

              const SizedBox(height: 15),

              // Avatar Upload
              Center(
                child: GestureDetector(
                  onTap: () => _showAvatarPickerDialog(),
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(60),
                      border: Border.all(
                        color: _selectedAvatar != null
                            ? primary
                            : primary.withOpacity(0.3),
                        width: _selectedAvatar != null ? 3 : 2,
                      ),
                    ),
                    child: _selectedAvatar != null
                        ? Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Image.file(
                                  _selectedAvatar!,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: GestureDetector(
                                  onTap: () => _removeAvatar(),
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(12.5),
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: textLight,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                size: 30,
                                color: primary.withOpacity(0.6),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Add Avatar',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: textGrey,
                                  fontFamily: 'Regular',
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Photos Section
              const Text(
                'Additional Photos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textLight,
                  fontFamily: 'Medium',
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Add at least 4 more photos',
                style: TextStyle(
                  fontSize: 14,
                  color: textGrey,
                  fontFamily: 'Regular',
                ),
              ),

              const SizedBox(height: 20),

              // Image Grid
              SizedBox(
                height: 300, // Adjust this height as needed
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return _buildImageCard(index);
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Continue Button
              Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: (_uploadedCount >= 5 && !_isUploading)
                        ? [primary, primary.withOpacity(0.8)]
                        : [textGrey, textGrey.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: (_uploadedCount >= 5 && !_isUploading)
                          ? primary.withOpacity(0.3)
                          : Colors.transparent,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: (_uploadedCount >= 5 && !_isUploading)
                      ? _handleContinue
                      : null,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: _isUploading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(buttonText),
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _uploadedCount >= 5
                              ? 'Continue'
                              : 'Upload avatar and 4 photos first',
                          style: TextStyle(
                            color: buttonText,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Medium',
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCard(int index) {
    return GestureDetector(
      onTap: () => _showImagePickerDialog(index),
      child: Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: _selectedImages[index] != null
                ? primary
                : primary.withOpacity(0.2),
            width: _selectedImages[index] != null ? 2 : 1,
          ),
        ),
        child: _selectedImages[index] != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  children: [
                    Image.file(
                      _selectedImages[index]!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),

                    // Remove button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => _removeImage(index),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: textLight,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate,
                    size: 40,
                    color: primary.withOpacity(0.6),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Photo ${index + 1}',
                    style: TextStyle(
                      fontSize: 14,
                      color: textGrey,
                      fontFamily: 'Regular',
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _showAvatarPickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Add Avatar',
            style: TextStyle(
              color: textLight,
              fontFamily: 'Medium',
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: primary),
                title: const Text(
                  'Choose from Gallery',
                  style: TextStyle(
                    color: textLight,
                    fontFamily: 'Regular',
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickAvatarFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: primary),
                title: const Text(
                  'Take a Photo',
                  style: TextStyle(
                    color: textLight,
                    fontFamily: 'Regular',
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _takeAvatarPhoto();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showImagePickerDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Add Photo',
            style: TextStyle(
              color: textLight,
              fontFamily: 'Medium',
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: primary),
                title: const Text(
                  'Choose from Gallery',
                  style: TextStyle(
                    color: textLight,
                    fontFamily: 'Regular',
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery(index);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: primary),
                title: const Text(
                  'Take a Photo',
                  style: TextStyle(
                    color: textLight,
                    fontFamily: 'Regular',
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _takePhoto(index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _pickAvatarFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        setState(() {
          if (_selectedAvatar == null) {
            _uploadedCount++;
          }
          _selectedAvatar = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking avatar from gallery: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to pick image from gallery'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _takeAvatarPhoto() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        setState(() {
          if (_selectedAvatar == null) {
            _uploadedCount++;
          }
          _selectedAvatar = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error taking avatar photo: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to take photo'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _simulateAvatarPick() {
    setState(() {
      if (_selectedAvatar == null) {
        _uploadedCount++;
      }
      _selectedAvatar = File('demo_avatar.jpg');
    });
  }

  void _removeAvatar() {
    setState(() {
      if (_selectedAvatar != null) {
        _uploadedCount--;
      }
      _selectedAvatar = null;
    });
  }

  void _pickImageFromGallery(int index) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        setState(() {
          if (_selectedImages[index] == null) {
            _uploadedCount++;
          }
          _selectedImages[index] = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to pick image from gallery'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _takePhoto(int index) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        setState(() {
          if (_selectedImages[index] == null) {
            _uploadedCount++;
          }
          _selectedImages[index] = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error taking photo: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to take photo'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      if (_selectedImages[index] != null) {
        _uploadedCount--;
      }
      _selectedImages[index] = null;
    });
  }

  void _handleContinue() async {
    if (_uploadedCount >= 5 && _selectedAvatar != null) {
      setState(() {
        _isUploading = true;
        _uploadProgress = 0.0;
      });

      try {
        // Upload images to Firebase Storage
        List<String> imageUrls = [];

        // Upload avatar
        String avatarUrl = await _uploadImageToFirebase(
          _selectedAvatar!,
          'avatar',
          0,
        );
        imageUrls.add(avatarUrl);

        // Upload additional images
        for (int i = 0; i < _selectedImages.length; i++) {
          if (_selectedImages[i] != null) {
            String imageUrl = await _uploadImageToFirebase(
              _selectedImages[i]!,
              'photo',
              i + 1,
            );
            imageUrls.add(imageUrl);
          }
        }

        // Debug prints
        print('Avatar URL: $avatarUrl');
        print('Image URLs: $imageUrls');

        // Save image URLs to Firestore
        await _authService.saveUserImages(
          avatarUrl: avatarUrl,
          imageUrls: imageUrls,
        );

        // Mark images as uploaded
        await _authService.markImagesAsUploaded();

        // Navigate to home screen
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
      } catch (e) {
        print('Error uploading images: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to upload images. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isUploading = false;
          });
        }
      }
    }
  }

  Future<String> _uploadImageToFirebase(
      File imageFile, String type, int index) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Create a reference to the file location
      String fileName =
          '${type}_${user.uid}_${DateTime.now().millisecondsSinceEpoch}_$index.jpg';
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images/${user.uid}/$fileName');

      // Upload file
      UploadTask uploadTask = storageRef.putFile(imageFile);

      // Listen to upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        if (mounted) {
          setState(() {
            _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
          });
        }
      });

      // Wait for upload to complete
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get download URL
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image to Firebase: $e');
      rethrow;
    }
  }
}
