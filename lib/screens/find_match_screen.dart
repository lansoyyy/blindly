import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/colors.dart';

class FindMatchScreen extends StatefulWidget {
  const FindMatchScreen({super.key});

  @override
  State<FindMatchScreen> createState() => _FindMatchScreenState();
}

class _FindMatchScreenState extends State<FindMatchScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  bool _isSearching = true;
  int _searchTime = 0;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    _pulseController.repeat(reverse: true);
    _rotationController.repeat();

    // Simulate search time
    _startSearchTimer();

    // Navigate to mechanics screen after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/mechanics');
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _startSearchTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _searchTime++;
        });
        _startSearchTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.arrowLeft, color: textLight),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Finding Match',
          style: TextStyle(
            color: textLight,
            fontFamily: 'Medium',
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isSearching ? _cancelSearch : null,
            child: Text(
              'Cancel',
              style: TextStyle(
                color: _isSearching ? accent : textGrey,
                fontFamily: 'Medium',
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Radar Icon
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            primary.withOpacity(0.3),
                            primary.withOpacity(0.1),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Center(
                        child: AnimatedBuilder(
                          animation: _rotationAnimation,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _rotationAnimation.value * 2 * 3.14159,
                              child: Icon(
                                FontAwesomeIcons.satellite,
                                size: 80,
                                color: primary,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              // Searching Text
              Text(
                'Searching...',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textLight,
                  fontFamily: 'Bold',
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Looking for someone special',
                style: TextStyle(
                  fontSize: 16,
                  color: textGrey,
                  fontFamily: 'Regular',
                ),
              ),

              const SizedBox(height: 30),

              // Progress Indicator
              Container(
                width: 200,
                child: LinearProgressIndicator(
                  backgroundColor: surface,
                  valueColor: AlwaysStoppedAnimation<Color>(primary),
                ),
              ),

              const SizedBox(height: 20),

              // Search Time
              Text(
                '${_searchTime}s',
                style: TextStyle(
                  fontSize: 14,
                  color: textGrey,
                  fontFamily: 'Regular',
                ),
              ),

              const SizedBox(height: 60),

              // Tips Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      FontAwesomeIcons.lightbulb,
                      color: accent,
                      size: 30,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Tip',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: textLight,
                        fontFamily: 'Medium',
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Be patient! Good matches take time. We\'re looking for someone who shares your interests and values.',
                      style: TextStyle(
                        fontSize: 14,
                        color: textGrey,
                        fontFamily: 'Regular',
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _cancelSearch() {
    setState(() {
      _isSearching = false;
    });

    // Stop animations
    _pulseController.stop();
    _rotationController.stop();

    // Navigate back
    Navigator.pop(context);
  }
}
