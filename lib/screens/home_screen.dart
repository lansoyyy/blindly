import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import '../utils/colors.dart';
import 'full_screen_image_viewer.dart';
import '../services/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final ImagePicker _picker = ImagePicker(); // Add image picker instance

  // User data will be loaded from Firebase
  String _userName = "Loading...";
  String _userAge = "--";
  String _userBio = "Loading...";
  List<String> _userImages = [];
  String? _userAvatar;
  bool _isLoading = true;
  bool _isUploading = false; // Add uploading state

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await _authService.getUserProfile();
      print('User data loaded: $userData'); // Debug print
      if (userData != null && mounted) {
        setState(() {
          _userName = userData['name'] ?? 'Anonymous User';
          _userAge = userData['age']?.toString() ?? '--';
          _userBio = userData['bio'] ?? 'No bio available';

          // Load user images
          _userAvatar = userData['avatarUrl'];
          _userImages = List<String>.from(userData['imageUrls'] ?? []);

          // Debug prints
          print('Avatar URL: $_userAvatar');
          print('Image URLs: $_userImages');
          print('Number of images: ${_userImages.length}');

          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: textLight,
            fontFamily: 'Bold',
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon:
                const Icon(FontAwesomeIcons.rightFromBracket, color: textLight),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        // Profile Header
                        _buildProfileHeader(),

                        // Bio Section
                        _buildBioSection(),

                        // Action Buttons
                        _buildActionButtons(),

                        // Photos Section
                        _buildPhotosSection(),
                      ],
                    ),
                  ),
                  // Loading indicator overlay
                  if (_isUploading)
                    Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Picture with Online Indicator
          Stack(
            alignment: Alignment.center,
            children: [
              // Profile Picture - Made tappable to update avatar
              GestureDetector(
                onTap: _updateAvatar,
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        primary,
                        accent
                      ], // Using accent color for Instagram-like gradient
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: _userAvatar != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(65),
                          child: Image.network(
                            _userAvatar!,
                            width: 130,
                            height: 130,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                FontAwesomeIcons.user,
                                size: 65,
                                color: textLight,
                              );
                            },
                          ),
                        )
                      : const Icon(
                          FontAwesomeIcons.user,
                          size: 65,
                          color: textLight,
                        ),
                ),
              ),
              // Online indicator
              Positioned(
                bottom: 5,
                right: 5,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: surface,
                      width: 3,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          // Name and Age
          Text(
            '$_userName',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: textLight,
              fontFamily: 'Bold',
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 5),

          Text(
            '$_userAge years old',
            style: const TextStyle(
              fontSize: 16,
              color: textGrey,
              fontFamily: 'Regular',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBioSection() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Bio',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textLight,
                  fontFamily: 'Bold',
                ),
              ),
              // Edit button
              GestureDetector(
                onTap: _editBio,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    FontAwesomeIcons.penToSquare,
                    size: 18,
                    color: primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: primary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              _userBio,
              style: const TextStyle(
                fontSize: 15,
                color: textLight,
                fontFamily: 'Regular',
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Edit bio functionality
  void _editBio() {
    TextEditingController bioController = TextEditingController(text: _userBio);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Edit Bio',
            style: TextStyle(
              color: textLight,
              fontFamily: 'Bold',
            ),
          ),
          content: TextField(
            controller: bioController,
            maxLines: 4,
            style: const TextStyle(
              color: textLight,
              fontFamily: 'Regular',
            ),
            decoration: InputDecoration(
              hintText: 'Tell us about yourself...',
              hintStyle: const TextStyle(
                color: textGrey,
                fontFamily: 'Regular',
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: primary, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: primary, width: 2),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: textGrey,
                  fontFamily: 'Regular',
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                String newBio = bioController.text.trim();
                Navigator.pop(context);

                try {
                  setState(() {
                    _isUploading = true;
                  });

                  // Update bio in Firestore
                  await _updateBioInFirestore(newBio);

                  // Update state
                  setState(() {
                    _userBio = newBio;
                    _isUploading = false;
                  });

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Bio updated successfully'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                } catch (e) {
                  print('Error updating bio: $e');
                  setState(() {
                    _isUploading = false;
                  });
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to update bio'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }
              },
              child: const Text(
                'Save',
                style: TextStyle(
                  color: primary,
                  fontFamily: 'Medium',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Update bio in Firestore
  Future<void> _updateBioInFirestore(String bio) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _authService.saveUserProfile(
          name: _userName,
          age: _userAge,
          gender: '', // These fields are required but not used in this context
          preference:
              '', // These fields are required but not used in this context
          city: '', // These fields are required but not used in this context
          bio: bio,
        );
      }
    } catch (e) {
      print('Error updating bio in Firestore: $e');
      rethrow;
    }
  }

  Widget _buildActionButtons() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          // Add Photo Button
          Expanded(
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: _addPhoto,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      FontAwesomeIcons.camera,
                      color: primary,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Add Photo',
                      style: TextStyle(
                        color: primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Medium',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          // Find Match Button
          Expanded(
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primary, primary.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: primary.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/find-match');
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      FontAwesomeIcons.search,
                      color: buttonText,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Find Match',
                      style: TextStyle(
                        color: buttonText,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Medium',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosSection() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Photos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textLight,
              fontFamily: 'Bold',
            ),
          ),
          const SizedBox(height: 20),
          // Instagram-like grid layout
          _buildInstagramGrid(),
        ],
      ),
    );
  }

  // Instagram-like photo grid
  Widget _buildInstagramGrid() {
    if (_userImages.isEmpty) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              FontAwesomeIcons.images,
              size: 50,
              color: textGrey,
            ),
            const SizedBox(height: 15),
            const Text(
              'No photos yet',
              style: TextStyle(
                fontSize: 16,
                color: textGrey,
                fontFamily: 'Regular',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Add photos to your profile',
              style: TextStyle(
                fontSize: 14,
                color: textGrey,
                fontFamily: 'Regular',
              ),
            ),
          ],
        ),
      );
    }

    // Create a grid that looks more like Instagram
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 1,
      ),
      itemCount: _userImages.length > 9
          ? 9
          : _userImages.length, // Show max 9 images like Instagram
      itemBuilder: (context, index) {
        return _buildInstagramPhotoCard(index);
      },
    );
  }

  // Instagram-style photo card
  Widget _buildInstagramPhotoCard(int index) {
    return GestureDetector(
      onTap: () => _showPhotoOptions(index),
      onLongPress: () =>
          _showPhotoOptions(index), // Add long press for more options
      child: Container(
        decoration: BoxDecoration(
          color: surface,
        ),
        child: ClipRRect(
          child: _userImages.isNotEmpty && index < _userImages.length
              ? Image.network(
                  _userImages[index],
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: surface,
                      child: Center(
                        child: Icon(
                          FontAwesomeIcons.user,
                          size: 30,
                          color: primary.withOpacity(0.6),
                        ),
                      ),
                    );
                  },
                )
              : Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: surface,
                  child: Center(
                    child: Icon(
                      FontAwesomeIcons.user,
                      size: 30,
                      color: primary.withOpacity(0.6),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  void _showPhotoOptions(int index) {
    // Show options for photo management
    showModalBottomSheet(
      context: context,
      backgroundColor: surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: textGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Photo Options',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textLight,
                  fontFamily: 'Bold',
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(FontAwesomeIcons.eye, color: primary),
                title: const Text(
                  'View Photo',
                  style: TextStyle(
                    color: textLight,
                    fontFamily: 'Regular',
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _viewPhoto(index);
                },
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.trash, color: Colors.red),
                title: const Text(
                  'Delete Photo',
                  style: TextStyle(
                    color: textLight,
                    fontFamily: 'Regular',
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _removePhoto(index);
                },
              ),
              const Divider(color: textGrey),
              ListTile(
                leading: const Icon(FontAwesomeIcons.xmark, color: textGrey),
                title: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: textLight,
                    fontFamily: 'Regular',
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // View photo in full screen
  void _viewPhoto(int index) {
    if (_userImages.isNotEmpty && index < _userImages.length) {
      Navigator.pushNamed(
        context,
        '/full-screen-image',
        arguments: {
          'imagePath': _userImages[index],
          'userName': _userName,
          'isNetworkImage': true,
        },
      );
    }
  }

  void _removePhoto(int index) async {
    if (_userImages.length > 1) {
      try {
        setState(() {
          _isUploading = true;
        });

        // Remove the photo from the list
        List<String> updatedImages = List.from(_userImages);
        updatedImages.removeAt(index);

        // Update Firestore with the new image list
        await _updateImagesInFirestore(updatedImages);

        // Update state
        setState(() {
          _userImages = updatedImages;
          _isUploading = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Photo removed successfully'),
              backgroundColor: primary,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        print('Error removing photo: $e');
        setState(() {
          _isUploading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to remove photo'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You need at least 1 photo'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  // Add photo functionality
  void _addPhoto() async {
    // Show options for adding a photo
    showModalBottomSheet(
      context: context,
      backgroundColor: surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: textGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Add Photo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textLight,
                  fontFamily: 'Bold',
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(FontAwesomeIcons.images, color: primary),
                title: const Text(
                  'Choose from Gallery',
                  style: TextStyle(
                    color: textLight,
                    fontFamily: 'Regular',
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.camera, color: primary),
                title: const Text(
                  'Take a Photo',
                  style: TextStyle(
                    color: textLight,
                    fontFamily: 'Regular',
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _takePhoto();
                },
              ),
              const Divider(color: textGrey),
              ListTile(
                leading: const Icon(FontAwesomeIcons.xmark, color: textGrey),
                title: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: textLight,
                    fontFamily: 'Regular',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Pick image from gallery
  void _pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        setState(() {
          _isUploading = true;
        });

        // Upload to Firebase Storage
        String imageUrl = await _uploadImageToFirebase(
          File(pickedFile.path),
          'photo',
          _userImages.length,
        );

        // Add to images list
        List<String> updatedImages = List.from(_userImages);
        updatedImages.add(imageUrl);

        // Update Firestore with the new image list
        await _updateImagesInFirestore(updatedImages);

        // Update state
        setState(() {
          _userImages = updatedImages;
          _isUploading = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Photo added successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
      setState(() {
        _isUploading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add photo'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  // Take photo
  void _takePhoto() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        setState(() {
          _isUploading = true;
        });

        // Upload to Firebase Storage
        String imageUrl = await _uploadImageToFirebase(
          File(pickedFile.path),
          'photo',
          _userImages.length,
        );

        // Add to images list
        List<String> updatedImages = List.from(_userImages);
        updatedImages.add(imageUrl);

        // Update Firestore with the new image list
        await _updateImagesInFirestore(updatedImages);

        // Update state
        setState(() {
          _userImages = updatedImages;
          _isUploading = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Photo added successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print('Error taking photo: $e');
      setState(() {
        _isUploading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add photo'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Widget _buildAddPhotoCard() {
    return GestureDetector(
      onTap: _addPhoto,
      child: Container(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: primary.withOpacity(0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              FontAwesomeIcons.camera,
              size: 35,
              color: primary,
            ),
            const SizedBox(height: 5),
            Text(
              'Add Photo',
              style: TextStyle(
                fontSize: 12,
                color: primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Upload image to Firebase Storage
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

  // Update images in Firestore
  Future<void> _updateImagesInFirestore(List<String> imageUrls) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && _userAvatar != null) {
        await _authService.saveUserImages(
          avatarUrl: _userAvatar!,
          imageUrls: imageUrls,
        );
      }
    } catch (e) {
      print('Error updating images in Firestore: $e');
      rethrow;
    }
  }

  // Function to update avatar
  void _updateAvatar() {
    // Show options for avatar update
    showModalBottomSheet(
      context: context,
      backgroundColor: surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: textGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Update Avatar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textLight,
                  fontFamily: 'Bold',
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(FontAwesomeIcons.images, color: primary),
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
                leading: const Icon(FontAwesomeIcons.camera, color: primary),
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
              const Divider(color: textGrey),
              ListTile(
                leading: const Icon(FontAwesomeIcons.xmark, color: textGrey),
                title: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: textLight,
                    fontFamily: 'Regular',
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Pick avatar from gallery
  void _pickAvatarFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        setState(() {
          _isUploading = true;
        });

        // Upload to Firebase Storage
        String avatarUrl = await _uploadImageToFirebase(
          File(pickedFile.path),
          'avatar',
          0,
        );

        // Update avatar URL in state
        setState(() {
          _userAvatar = avatarUrl;
          _isUploading = false;
        });

        // Update avatar URL in Firestore
        await _updateAvatarInFirestore(avatarUrl);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Avatar updated successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print('Error picking avatar from gallery: $e');
      setState(() {
        _isUploading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update avatar'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  // Take avatar photo
  void _takeAvatarPhoto() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        setState(() {
          _isUploading = true;
        });

        // Upload to Firebase Storage
        String avatarUrl = await _uploadImageToFirebase(
          File(pickedFile.path),
          'avatar',
          0,
        );

        // Update avatar URL in state
        setState(() {
          _userAvatar = avatarUrl;
          _isUploading = false;
        });

        // Update avatar URL in Firestore
        await _updateAvatarInFirestore(avatarUrl);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Avatar updated successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print('Error taking avatar photo: $e');
      setState(() {
        _isUploading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update avatar'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  // Update avatar URL in Firestore
  Future<void> _updateAvatarInFirestore(String avatarUrl) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _authService.saveUserImages(
          avatarUrl: avatarUrl,
          imageUrls: _userImages,
        );
      }
    } catch (e) {
      print('Error updating avatar in Firestore: $e');
      rethrow;
    }
  }

  // Logout function
  void _handleLogout() {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(
              color: textLight,
              fontFamily: 'Bold',
            ),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              color: textLight,
              fontFamily: 'Regular',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: textGrey,
                  fontFamily: 'Regular',
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                setState(() {
                  _isUploading = true;
                });

                try {
                  await _authService.signOut();
                  if (mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/landing', (route) => false);
                  }
                } catch (e) {
                  print('Error logging out: $e');
                  setState(() {
                    _isUploading = false;
                  });
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to logout. Please try again.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontFamily: 'Medium',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
