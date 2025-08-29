import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/colors.dart';

class MechanicsScreen extends StatelessWidget {
  const MechanicsScreen({super.key});

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
          'Chat Rules',
          style: TextStyle(
            color: textLight,
            fontFamily: 'Medium',
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'How Anonymous Chat Works',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textLight,
                  fontFamily: 'Bold',
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Understand the rules before starting your conversation',
                style: TextStyle(
                  fontSize: 14,
                  color: textGrey,
                  fontFamily: 'Regular',
                ),
              ),

              const SizedBox(height: 30),

              // Rules Cards
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildRuleCard(
                        icon: FontAwesomeIcons.user,
                        title: 'Anonymous Identities',
                        description:
                            'You\'ll be known as "User A" and your match as "User B" until you choose to reveal your real identity.',
                        color: primary,
                      ),

                      const SizedBox(height: 20),

                      _buildRuleCard(
                        icon: FontAwesomeIcons.eye,
                        title: 'Reveal Your Identity',
                        description:
                            'Send a reveal request anytime during the conversation. Both users must accept to see real profiles and continue chatting.',
                        color: accent,
                      ),

                      const SizedBox(height: 20),

                      _buildRuleCard(
                        icon: FontAwesomeIcons.handshake,
                        title: 'Mutual Agreement',
                        description:
                            'Both users must accept the reveal request to see real profiles. If declined, you can try again later.',
                        color: primary,
                      ),

                      const SizedBox(height: 20),

                      _buildRuleCard(
                        icon: FontAwesomeIcons.shield,
                        title: 'Privacy First',
                        description:
                            'Your personal information stays hidden until you choose to reveal. You control your privacy completely.',
                        color: accent,
                      ),

                      const SizedBox(height: 20),

                      _buildRuleCard(
                        icon: FontAwesomeIcons.message,
                        title: 'Meaningful Conversations',
                        description:
                            'Focus on personality and connection rather than appearance. Build genuine relationships through conversation.',
                        color: primary,
                      ),

                      const SizedBox(height: 20),

                      _buildRuleCard(
                        icon: FontAwesomeIcons.ban,
                        title: 'Respect & Safety',
                        description:
                            'Be respectful and kind. Report inappropriate behavior. Your safety and comfort are our priority.',
                        color: accent,
                      ),

                      const SizedBox(height: 40),

                      // Important Notice
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: accent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: accent.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              FontAwesomeIcons.circleInfo,
                              color: accent,
                              size: 30,
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              'Important',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: textLight,
                                fontFamily: 'Medium',
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'You can send reveal requests multiple times. Both users must accept to see real profiles. Take your time to build a connection first.',
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

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              // Start Chat Button
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
                    // Navigate to anonymous chat screen
                    Navigator.pushNamed(context, '/anonymous-chat');
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Start Chat',
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

  Widget _buildRuleCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textLight,
                    fontFamily: 'Medium',
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
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
}
