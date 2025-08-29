import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../utils/colors.dart';

class IdentitiesRevealedScreen extends StatefulWidget {
  final String userAName;
  final String userAAge;
  final String userBName;
  final String userBAge;

  const IdentitiesRevealedScreen({
    super.key,
    required this.userAName,
    required this.userAAge,
    required this.userBName,
    required this.userBAge,
  });

  @override
  State<IdentitiesRevealedScreen> createState() =>
      _IdentitiesRevealedScreenState();
}

class _IdentitiesRevealedScreenState extends State<IdentitiesRevealedScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainAnimationController;
  late AnimationController _heartController;
  late AnimationController _avatarController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _heartAnimation;
  late Animation<double> _avatarAnimation;

  @override
  void initState() {
    super.initState();

    // Main animation controller
    _mainAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Heart animation controller
    _heartController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Avatar animation controller
    _avatarController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Setup animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    _slideAnimation = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    _heartAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _heartController,
      curve: Curves.easeInOut,
    ));

    _avatarAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _avatarController,
      curve: Curves.easeOut,
    ));

    // Start animations
    _startAnimations();
  }

  void _startAnimations() async {
    // Start main animation
    _mainAnimationController.forward();

    // Start heart beating animation with delay
    await Future.delayed(const Duration(milliseconds: 600));
    _heartController.repeat(reverse: true);

    // Start avatar animation
    await Future.delayed(const Duration(milliseconds: 300));
    _avatarController.forward();
  }

  @override
  void dispose() {
    _mainAnimationController.dispose();
    _heartController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: AnimatedBuilder(
            animation: _mainAnimationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Main Title
                          const Text(
                            'Identities Revealed!',
                            style: TextStyle(
                              color: textLight,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Bold',
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 12),

                          // Subtitle
                          const Text(
                            'You can now see each other\'s real profiles',
                            style: TextStyle(
                              color: textGrey,
                              fontSize: 16,
                              fontFamily: 'Regular',
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 40),

                          // Avatars and Heart Section
                          _buildAvatarsSection(),

                          const SizedBox(height: 30),

                          // Connection Message
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              'A new connection has been made!',
                              style: TextStyle(
                                color: primary,
                                fontSize: 15,
                                fontFamily: 'Medium',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Continue Button
                          _buildContinueButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarsSection() {
    return AnimatedBuilder(
      animation: _avatarController,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // User A Avatar
            Transform.scale(
              scale: _avatarAnimation.value,
              child: _buildUserAvatar(
                name: widget.userAName,
                age: widget.userAAge,
                isLeft: true,
              ),
            ),

            // Animated Heart
            AnimatedBuilder(
              animation: _heartController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _heartAnimation.value,
                  child: const Icon(
                    FontAwesomeIcons.heart,
                    color: primary,
                    size: 32,
                  ),
                );
              },
            ),

            // User B Avatar
            Transform.scale(
              scale: _avatarAnimation.value,
              child: _buildUserAvatar(
                name: widget.userBName,
                age: widget.userBAge,
                isLeft: false,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUserAvatar({
    required String name,
    required String age,
    required bool isLeft,
  }) {
    return Column(
      children: [
        // Avatar with subtle glow
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: surface,
            border: Border.all(
              color: primary.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: const Icon(
            FontAwesomeIcons.user,
            color: primary,
            size: 58,
          ),
        ),

        const SizedBox(height: 12),

        // Name
        Text(
          name,
          style: const TextStyle(
            color: textLight,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Bold',
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 4),

        // Age
        Text(
          '$age years old',
          style: TextStyle(
            color: textGrey,
            fontSize: 14,
            fontFamily: 'Regular',
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              FontAwesomeIcons.message,
              color: buttonText,
              size: 18,
            ),
            const SizedBox(width: 10),
            const Text(
              'Continue Chat',
              style: TextStyle(
                color: buttonText,
                fontFamily: 'Bold',
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
