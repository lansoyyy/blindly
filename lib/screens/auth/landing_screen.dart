import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../utils/colors.dart';
import '../../services/auth_service.dart';

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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const Spacer(flex: 1),

                // App Logo and Name
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 5,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    FontAwesomeIcons.heart,
                    size: 60,
                    color: textLight,
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  'Blindly',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: textLight,
                    fontFamily: 'Bold',
                  ),
                ),

                const SizedBox(height: 12),

                // Branding tagline
                const Text(
                  'Love comes unseen.',
                  style: TextStyle(
                    fontSize: 20,
                    color: textGrey,
                    fontFamily: 'Regular',
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 35),

                if (!_showMechanics) ...[
                  // Get Started Button
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primary, primary.withOpacity(0.8)],
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: primary.withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
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
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          color: buttonText,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Medium',
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Additional info
                  const Text(
                    'Start your journey to find meaningful connections',
                    style: TextStyle(
                      fontSize: 16,
                      color: textGrey,
                      fontFamily: 'Regular',
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const Spacer(flex: 2),
                ] else ...[
                  // Header Section
                  const Text(
                    'How Blindly Works',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: textLight,
                      fontFamily: 'Bold',
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'Discover meaningful connections through anonymous conversations',
                    style: TextStyle(
                      fontSize: 18,
                      color: textGrey,
                      fontFamily: 'Regular',
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 35),

                  // Mechanics Explanation
                  Expanded(
                    flex: 5,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Mechanics Cards
                          _buildMechanicsCard(
                            icon: FontAwesomeIcons.user,
                            title: 'Anonymous Chat',
                            description:
                                'Start conversations without revealing your identity. You\'ll be known as "User A" or "User B" until you choose to reveal.',
                          ),

                          const SizedBox(height: 25),

                          _buildMechanicsCard(
                            icon: FontAwesomeIcons.eye,
                            title: 'Reveal Your Identity',
                            description:
                                'Send a reveal request anytime during the conversation. Both users must accept to see real profiles.',
                          ),

                          const SizedBox(height: 25),

                          _buildMechanicsCard(
                            icon: FontAwesomeIcons.heart,
                            title: 'Meaningful Connections',
                            description:
                                'Focus on personality and conversation rather than appearances. Build genuine connections.',
                          ),

                          const SizedBox(height: 25),

                          _buildMechanicsCard(
                            icon: FontAwesomeIcons.shield,
                            title: 'Safe & Secure',
                            description:
                                'Your privacy is protected. You control when and if you want to reveal your identity.',
                          ),

                          const SizedBox(height: 30),

                          // Continue Button
                          Container(
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [accent, accent.withOpacity(0.8)],
                              ),
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: accent.withOpacity(0.4),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: TextButton(
                              onPressed: _isLoading ? null : _handleContinue,
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
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
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Medium',
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(flex: 1),
                ],
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
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: primary.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Container
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primary, primary.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: textLight,
              size: 35,
            ),
          ),
          const SizedBox(width: 20),
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textLight,
                    fontFamily: 'Bold',
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: textGrey,
                    fontFamily: 'Regular',
                    height: 1.5,
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
