import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();

  // User data will be loaded from Firebase
  String _userName = "Loading...";
  String _userAge = "--";
  String _userBio = "Loading...";
  List<String> _userImages = [
    'assets/images/demo_user_1.jpg',
    'assets/images/demo_user_2.jpg',
    'assets/images/demo_user_3.jpg',
    'assets/images/demo_user_4.jpg',
  ];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await _authService.getUserProfile();
      if (userData != null && mounted) {
        setState(() {
          _userName = userData['name'] ?? 'Anonymous User';
          _userAge = userData['age']?.toString() ?? '--';
          _userBio = userData['bio'] ?? 'No bio available';
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
            icon: const Icon(Icons.settings, color: textLight),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
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
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
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
              // Profile Picture
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [primary, primary.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person,
                  size: 60,
                  color: textLight,
                ),
              ),
              // Online Indicator
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accent,
                    border: Border.all(color: background, width: 3),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Name and Age
          Text(
            '$_userName, $_userAge',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textLight,
              fontFamily: 'Bold',
            ),
          ),

          const SizedBox(height: 10),

          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                icon: Icons.photo_library,
                count: '${_userImages.length}',
                label: 'Photos',
                color: primary,
              ),
              _buildStatItem(
                icon: Icons.chat_bubble,
                count: '1',
                label: 'Chats',
                color: accent,
              ),
              _buildStatItem(
                icon: Icons.favorite,
                count: '0',
                label: 'Likes',
                color: Colors.pinkAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String count,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.1),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          count,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textLight,
            fontFamily: 'Bold',
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: textGrey,
            fontFamily: 'Regular',
          ),
        ),
      ],
    );
  }

  Widget _buildBioSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About Me',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textLight,
              fontFamily: 'Bold',
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: primary.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Text(
              _userBio,
              style: const TextStyle(
                fontSize: 14,
                color: textLight,
                fontFamily: 'Regular',
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Edit Profile Button
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: primary.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: TextButton(
                onPressed: () {
                  // Navigate to edit profile
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Medium',
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          // Find Match Button
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primary, primary.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: primary.withOpacity(0.3),
                    blurRadius: 10,
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Find Match',
                  style: TextStyle(
                    color: buttonText,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Medium',
                  ),
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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Photos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textLight,
              fontFamily: 'Bold',
            ),
          ),
          const SizedBox(height: 15),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemCount: _userImages.length + 1,
            itemBuilder: (context, index) {
              if (index == _userImages.length) {
                // Add photo button
                return _buildAddPhotoCard();
              } else {
                // Photo card
                return _buildPhotoCard(index);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoCard(int index) {
    return GestureDetector(
      onTap: () => _showPhotoOptions(index),
      child: Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              // Photo placeholder
              Container(
                width: double.infinity,
                height: double.infinity,
                color: surface,
                child: Center(
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: primary.withOpacity(0.6),
                  ),
                ),
              ),

              // Remove button
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => _removePhoto(index),
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: textLight,
                      size: 16,
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

  Widget _buildAddPhotoCard() {
    return GestureDetector(
      onTap: _addPhoto,
      child: Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: primary.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_a_photo,
                color: primary,
                size: 30,
              ),
              const SizedBox(height: 5),
              Text(
                'Add Photo',
                style: TextStyle(
                  color: primary,
                  fontSize: 12,
                  fontFamily: 'Medium',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPhotoOptions(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: textGrey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 25),

            // Title
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

            // Options
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.visibility, color: primary),
              ),
              title: const Text(
                'View Photo',
                style: TextStyle(
                  color: textLight,
                  fontFamily: 'Medium',
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // Show photo in full screen
              },
            ),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.edit, color: Colors.orange),
              ),
              title: const Text(
                'Edit Photo',
                style: TextStyle(
                  color: textLight,
                  fontFamily: 'Medium',
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigate to edit photo
              },
            ),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.delete, color: Colors.red),
              ),
              title: const Text(
                'Remove Photo',
                style: TextStyle(
                  color: Colors.red,
                  fontFamily: 'Medium',
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _removePhoto(index);
              },
            ),
            const SizedBox(height: 10),

            // Cancel button
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: textGrey.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: textGrey,
                    fontSize: 16,
                    fontFamily: 'Medium',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addPhoto() {
    if (_userImages.length < 6) {
      setState(() {
        _userImages
            .add('assets/images/demo_user_${_userImages.length + 1}.jpg');
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Photo added successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximum 6 photos allowed'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _removePhoto(int index) {
    if (_userImages.length > 1) {
      setState(() {
        _userImages.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Photo removed'),
          backgroundColor: primary,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
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
