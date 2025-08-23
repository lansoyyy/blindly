import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../services/auth_service.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final AuthService _authService = AuthService();
  bool _showMechanics = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              background,
              surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const Spacer(),

                // App Logo and Name
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite,
                    size: 50,
                    color: textLight,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Blindly',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: textLight,
                    fontFamily: 'Bold',
                  ),
                ),

                const SizedBox(height: 10),

                // Branding tagline
                const Text(
                  'Love comes unseen.',
                  style: TextStyle(
                    fontSize: 18,
                    color: textGrey,
                    fontFamily: 'Regular',
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                if (!_showMechanics) ...[
                  // Get Started Button
                  Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primary, primary.withOpacity(0.8)],
                      ),
                      borderRadius: BorderRadius.circular(15),
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
                        setState(() {
                          _showMechanics = true;
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          color: buttonText,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Medium',
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Additional info
                  const Text(
                    'Start your journey to find meaningful connections',
                    style: TextStyle(
                      fontSize: 14,
                      color: textGrey,
                      fontFamily: 'Regular',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ] else ...[
                  // Header Section
                  const Text(
                    'How Blindly Works',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: textLight,
                      fontFamily: 'Bold',
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Discover meaningful connections through anonymous conversations',
                    style: TextStyle(
                      fontSize: 16,
                      color: textGrey,
                      fontFamily: 'Regular',
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 30),

                  // Mechanics Explanation
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Mechanics Cards
                          _buildMechanicsCard(
                            icon: Icons.person,
                            title: 'Anonymous Chat',
                            description:
                                'Start conversations without revealing your identity. You\'ll be known as "User A" or "User B" until you choose to reveal.',
                          ),

                          const SizedBox(height: 25),

                          _buildMechanicsCard(
                            icon: Icons.visibility,
                            title: 'Reveal Your Identity',
                            description:
                                'Send a reveal request anytime during the conversation. Both users must accept to see real profiles.',
                          ),

                          const SizedBox(height: 25),

                          _buildMechanicsCard(
                            icon: Icons.favorite,
                            title: 'Meaningful Connections',
                            description:
                                'Focus on personality and conversation rather than appearances. Build genuine connections.',
                          ),

                          const SizedBox(height: 25),

                          _buildMechanicsCard(
                            icon: Icons.security,
                            title: 'Safe & Secure',
                            description:
                                'Your privacy is protected. You control when and if you want to reveal your identity.',
                          ),

                          const SizedBox(height: 40),

                          // Continue Button
                          Container(
                            width: double.infinity,
                            height: 55,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [accent, accent.withOpacity(0.8)],
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: accent.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: TextButton(
                              onPressed: _isLoading ? null : _handleContinue,
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          buttonText,
                                        ),
                                      ),
                                    )
                                  : const Text(
                                      'Continue',
                                      style: TextStyle(
                                        color: buttonText,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Medium',
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMechanicsCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primary.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: primary,
              size: 30,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: textLight,
                    fontFamily: 'Medium',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 15,
                    color: textGrey,
                    fontFamily: 'Regular',
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleContinue() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Sign in anonymously
      final result = await _authService.signInAnonymously();

      if (result != null) {
        // AuthStateWrapper will handle navigation automatically
        // based on user's setup status
        print('User signed in anonymously: ${result.user?.uid}');
      } else {
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to sign in. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('Error signing in: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
