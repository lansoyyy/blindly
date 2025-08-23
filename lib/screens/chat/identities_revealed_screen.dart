import 'package:flutter/material.dart';
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
  late AnimationController _sparkleController;
  late AnimationController _avatarController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _heartAnimation;
  late Animation<double> _sparkleAnimation;
  late Animation<double> _avatarAnimation;

  @override
  void initState() {
    super.initState();

    // Main animation controller
    _mainAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Heart animation controller
    _heartController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Sparkle animation controller
    _sparkleController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Avatar animation controller
    _avatarController = AnimationController(
      duration: const Duration(milliseconds: 1500),
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
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    _heartAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _heartController,
      curve: Curves.easeInOut,
    ));

    _sparkleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _sparkleController,
      curve: Curves.easeInOut,
    ));

    _avatarAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _avatarController,
      curve: Curves.bounceOut,
    ));

    // Start animations
    _startAnimations();
  }

  void _startAnimations() async {
    // Start main animation
    _mainAnimationController.forward();

    // Start heart beating animation with delay
    await Future.delayed(const Duration(milliseconds: 800));
    _heartController.repeat(reverse: true);

    // Start sparkle animation
    await Future.delayed(const Duration(milliseconds: 400));
    _sparkleController.repeat();

    // Start avatar animation
    await Future.delayed(const Duration(milliseconds: 200));
    _avatarController.forward();
  }

  @override
  void dispose() {
    _mainAnimationController.dispose();
    _heartController.dispose();
    _sparkleController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primary.withOpacity(0.9),
              accent.withOpacity(0.8),
              primary.withOpacity(0.7),
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
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          const Spacer(),

                          // Sparkle Effects
                          _buildSparkleEffects(),

                          const SizedBox(height: 20),

                          // Celebration Icon
                          AnimatedBuilder(
                            animation: _sparkleController,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _sparkleAnimation.value * 0.1,
                                child: Icon(
                                  Icons.celebration,
                                  color: Colors.amber,
                                  size: 64 + (_sparkleAnimation.value * 8),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 32),

                          // Main Title
                          const Text(
                            'Identities Revealed!',
                            style: TextStyle(
                              color: textLight,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Bold',
                              letterSpacing: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 16),

                          // Subtitle
                          const Text(
                            'You can now see each other\'s real profiles!',
                            style: TextStyle(
                              color: textLight,
                              fontSize: 18,
                              fontFamily: 'Regular',
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 48),

                          // Avatars and Heart Section
                          _buildAvatarsSection(),

                          const SizedBox(height: 48),

                          // Connection Message
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: const Text(
                              '💫 A new connection has been made! 💫',
                              style: TextStyle(
                                color: textLight,
                                fontSize: 16,
                                fontFamily: 'Medium',
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          const Spacer(),

                          // Continue Button
                          _buildContinueButton(),

                          const SizedBox(height: 24),
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

  Widget _buildSparkleEffects() {
    return AnimatedBuilder(
      animation: _sparkleController,
      builder: (context, child) {
        return SizedBox(
          height: 100,
          child: Stack(
            children: [
              // Floating sparkles
              ...List.generate(6, (index) {
                final offset = Offset(
                  (index * 60.0) +
                      (_sparkleAnimation.value *
                          20 *
                          (index % 2 == 0 ? 1 : -1)),
                  20 + (_sparkleAnimation.value * 30 * (index % 3)),
                );
                return Positioned(
                  left: offset.dx,
                  top: offset.dy,
                  child: Transform.scale(
                    scale: 0.5 + (_sparkleAnimation.value * 0.5),
                    child: Icon(
                      Icons.auto_awesome,
                      color: Colors.white
                          .withOpacity(0.3 + (_sparkleAnimation.value * 0.4)),
                      size: 16 + (index % 3) * 4,
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
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
                color: primary,
                isLeft: true,
              ),
            ),

            // Animated Heart
            AnimatedBuilder(
              animation: _heartController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _heartAnimation.value,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.pink.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.pinkAccent,
                      size: 48,
                    ),
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
                color: accent,
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
    required Color color,
    required bool isLeft,
  }) {
    return Column(
      children: [
        // Avatar with glow effect
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.6),
                blurRadius: 20,
                spreadRadius: 4,
              ),
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 40,
                spreadRadius: 8,
              ),
            ],
          ),
          child: const Icon(
            Icons.person,
            color: textLight,
            size: 50,
          ),
        ),

        const SizedBox(height: 16),

        // Name with background
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Text(
            name,
            style: const TextStyle(
              color: textLight,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Bold',
            ),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 4),

        // Age
        Text(
          age,
          style: TextStyle(
            color: textLight.withOpacity(0.8),
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
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.9),
            Colors.white.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 6),
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
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat,
              color: primary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Continue Chat',
              style: TextStyle(
                color: primary,
                fontFamily: 'Bold',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
