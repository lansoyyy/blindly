import 'package:flutter/material.dart';
import '../utils/colors.dart';

class UserProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const UserProfileScreen({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final List<String> _photos = [
    'assets/images/logo.png',
    'assets/images/logo.png',
    'assets/images/logo.png',
    'assets/images/logo.png',
  ];

  @override
  Widget build(BuildContext context) {
    final String name = widget.userData['name'] ?? 'Unknown';
    final String age = widget.userData['age'] ?? 'Unknown';
    final String city = widget.userData['city'] ?? 'Unknown';

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: textLight,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          name,
          style: const TextStyle(
            color: textLight,
            fontFamily: 'Bold',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Profile Picture
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primary,
                      boxShadow: [
                        BoxShadow(
                          color: primary.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person,
                      color: textLight,
                      size: 50,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Name and Age
                  Text(
                    name,
                    style: const TextStyle(
                      color: textLight,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Bold',
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    '$age years old',
                    style: const TextStyle(
                      color: textGrey,
                      fontSize: 16,
                      fontFamily: 'Regular',
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Location
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: accent,
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        city,
                        style: const TextStyle(
                          color: textGrey,
                          fontSize: 14,
                          fontFamily: 'Regular',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStat('Photos', _photos.length.toString()),
                      _buildStat('Active', '2 days'),
                      _buildStat('Verified', 'Yes'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Photos Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Photos',
                    style: TextStyle(
                      color: textLight,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Bold',
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Photo Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    itemCount: _photos.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: surface,
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
                          child: Image.asset(
                            _photos[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: textLight,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Bold',
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: textGrey,
            fontSize: 12,
            fontFamily: 'Regular',
          ),
        ),
      ],
    );
  }
}
