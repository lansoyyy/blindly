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
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Profile Header (Instagram Style)
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Info Row
                  Row(
                    children: [
                      // Profile Picture
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primary,
                          boxShadow: [
                            BoxShadow(
                              color: primary.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 40,
                          color: textLight,
                        ),
                      ),

                      const SizedBox(width: 20),

                      // Profile Stats
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatColumn('${_userImages.length}', 'Photos'),
                            _buildStatColumn('1', 'Active Chat'),
                            _buildStatColumn('0', 'Days'),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Name and Age
                  Text(
                    '$_userName, $_userAge',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textLight,
                      fontFamily: 'Bold',
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Bio
                  Text(
                    _userBio,
                    style: const TextStyle(
                      fontSize: 14,
                      color: textLight,
                      fontFamily: 'Regular',
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 35,
                          decoration: BoxDecoration(
                            color: surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: primary.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: TextButton(
                            onPressed: _addPhoto,
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Add Photo',
                              style: TextStyle(
                                color: primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Medium',
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 35,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [primary, primary.withOpacity(0.8)],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/find-match');
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Find Match',
                              style: TextStyle(
                                color: buttonText,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Medium',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Divider
            Container(
              height: 1,
              color: surface,
            ),

            // Photos Grid (Instagram Style)
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(1),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                ),
                itemCount:
                    _userImages.length + (_userImages.length < 6 ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _userImages.length) {
                    // Add photo button
                    return _buildAddPhotoTile();
                  } else {
                    // Photo tile
                    return _buildPhotoTile(index);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textLight,
            fontFamily: 'Bold',
          ),
        ),
        const SizedBox(height: 2),
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

  Widget _buildPhotoTile(int index) {
    return GestureDetector(
      onTap: () => _showPhotoOptions(index),
      child: Container(
        color: surface,
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
              top: 5,
              right: 5,
              child: GestureDetector(
                onTap: () => _removePhoto(index),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: textLight,
                    size: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddPhotoTile() {
    return GestureDetector(
      onTap: _addPhoto,
      child: Container(
        color: surface,
        child: Center(
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: primary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.add,
              color: primary,
              size: 20,
            ),
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: textGrey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
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
            ListTile(
              leading: const Icon(Icons.edit, color: primary),
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
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximum 6 photos allowed'),
          backgroundColor: Colors.orange,
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
          backgroundColor: Colors.orange,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You need at least 1 photo'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
