import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../utils/colors.dart';

class AnonymousChatScreen extends StatefulWidget {
  const AnonymousChatScreen({super.key});

  @override
  State<AnonymousChatScreen> createState() => _AnonymousChatScreenState();
}

class _AnonymousChatScreenState extends State<AnonymousChatScreen>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _canReveal = true;
  bool _isRevealed = false;
  bool _isUserA = true; // Demo: current user is User A

  // Animation controllers for avatar reveal
  late AnimationController _avatarAnimationController;
  late AnimationController _pulseAnimationController;
  late Animation<double> _avatarScaleAnimation;
  late Animation<double> _avatarOpacityAnimation;
  late Animation<double> _pulseAnimation;
  bool _isAnimating = false;

  // Demo user data for reveal
  final String _userAName = "Sarah Garcia";
  final String _userAAge = "25";
  final String _userACity = "Manila";
  final String _userBName = "Michael Santos";
  final String _userBAge = "28";
  final String _userBCity = "Quezon City";

  // Demo chat messages
  List<ChatMessage> _messages = [
    ChatMessage(
      text: "Hi there! 👋",
      isFromUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    ChatMessage(
      text: "Hello! How are you doing?",
      isFromUser: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
    ),
    ChatMessage(
      text: "I'm doing great! Just finished reading a book. What about you?",
      isFromUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
    ),
    ChatMessage(
      text: "That sounds interesting! What book was it?",
      isFromUser: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _avatarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Setup animations
    _avatarScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _avatarAnimationController,
      curve: Curves.elasticOut,
    ));

    _avatarOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _avatarAnimationController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _avatarAnimationController.dispose();
    _pulseAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.arrowLeft,
              color: textLight, size: 20),
          onPressed: () => _showEndChatDialog(),
        ),
        title: Row(
          children: [
            // Other User Avatar (User B since current user is User A)
            GestureDetector(
              onTap: _isRevealed
                  ? () => _showUserProfile(_userBName, _userBAge, _userBCity)
                  : null,
              child: AnimatedBuilder(
                animation: _avatarAnimationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _isAnimating ? _avatarScaleAnimation.value : 1.0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accent.withOpacity(0.2),
                        border: Border.all(
                          color: accent,
                          width: 2,
                        ),
                        boxShadow: _isAnimating
                            ? [
                                BoxShadow(
                                  color: accent.withOpacity(0.4),
                                  blurRadius: 12,
                                  spreadRadius: 3,
                                ),
                              ]
                            : null,
                      ),
                      child: _isRevealed
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                color: accent,
                                child: const Icon(
                                  FontAwesomeIcons.user,
                                  color: textLight,
                                  size: 22,
                                ),
                              ),
                            )
                          : const Icon(
                              FontAwesomeIcons.user,
                              color: accent,
                              size: 22,
                            ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: 12),

            GestureDetector(
              onTap: _isRevealed
                  ? () => _showUserProfile(_userBName, _userBAge, _userBCity)
                  : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isRevealed ? _userBName : 'Anonymous',
                    style: TextStyle(
                      color: textLight,
                      fontFamily: 'Medium',
                      fontSize: 17,
                      decoration: _isRevealed
                          ? TextDecoration.underline
                          : TextDecoration.none,
                    ),
                  ),
                  Text(
                    'Online',
                    style: TextStyle(
                      color: _isRevealed ? primary : textGrey,
                      fontSize: 12,
                      fontFamily: 'Regular',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Reveal Button (if not revealed and can reveal)
          if (!_isRevealed && _canReveal)
            IconButton(
              icon: const Icon(FontAwesomeIcons.eye, color: accent, size: 20),
              onPressed: _showRevealDialog,
              tooltip: 'Reveal Identity',
            ),
          IconButton(
            icon: const Icon(FontAwesomeIcons.ellipsisVertical,
                color: textLight, size: 20),
            onPressed: () => _showChatOptions(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat Messages
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[_messages.length - 1 - index];
                  return _buildMessageBubble(message);
                },
              ),
            ),
          ),

          // Message Input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surface,
              border: Border(
                top: BorderSide(
                  color: primary.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: background,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: primary.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(
                        color: textLight,
                        fontFamily: 'Regular',
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(
                          color: textGrey,
                          fontFamily: 'Regular',
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                      ),
                      maxLines: null,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primary, primary.withOpacity(0.8)],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(
                      FontAwesomeIcons.paperPlane,
                      color: textLight,
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    bool isSystemMessage = message.isSystemMessage;

    if (isSystemMessage) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: primary.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Text(
              message.text,
              style: TextStyle(
                color: primary,
                fontFamily: 'Medium',
                fontSize: 13,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: message.isFromUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!message.isFromUser) ...[
            // Other user's avatar
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent.withOpacity(0.2),
                border: Border.all(
                  color: accent,
                  width: 1.5,
                ),
              ),
              child: _isRevealed
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        color: accent,
                        child: const Icon(
                          FontAwesomeIcons.user,
                          color: textLight,
                          size: 18,
                        ),
                      ),
                    )
                  : const Icon(
                      FontAwesomeIcons.user,
                      color: accent,
                      size: 18,
                    ),
            ),

            const SizedBox(width: 10),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: message.isFromUser ? primary : surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: message.isFromUser
                      ? Colors.transparent
                      : primary.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isFromUser ? textLight : textLight,
                  fontFamily: 'Regular',
                  fontSize: 15,
                ),
              ),
            ),
          ),
          if (message.isFromUser) ...[
            const SizedBox(width: 10),

            // Current user's avatar
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primary.withOpacity(0.2),
                border: Border.all(
                  color: primary,
                  width: 1.5,
                ),
              ),
              child: _isRevealed
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        color: primary,
                        child: const Icon(
                          FontAwesomeIcons.user,
                          color: textLight,
                          size: 18,
                        ),
                      ),
                    )
                  : const Icon(
                      FontAwesomeIcons.user,
                      color: primary,
                      size: 18,
                    ),
            ),
          ],
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(
          ChatMessage(
            text: _messageController.text.trim(),
            isFromUser: true,
            timestamp: DateTime.now(),
          ),
        );
      });

      _messageController.clear();

      // Scroll to bottom
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _showRevealDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Reveal Your Identity',
            style: TextStyle(
              color: textLight,
              fontFamily: 'Bold',
              fontSize: 20,
            ),
          ),
          content: const Text(
            'Are you sure you want to reveal your identity? This action cannot be undone and both users must accept to see real profiles.',
            style: TextStyle(
              color: textGrey,
              fontFamily: 'Regular',
              fontSize: 15,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: textGrey,
                  fontFamily: 'Medium',
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [accent, accent.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _sendRevealRequest();
                },
                child: const Text(
                  'Reveal',
                  style: TextStyle(
                    color: textLight,
                    fontFamily: 'Medium',
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _sendRevealRequest() {
    setState(() {
      _canReveal = false;
      _messages.add(
        ChatMessage(
          text: "🔍 Reveal request sent...",
          isFromUser: true,
          timestamp: DateTime.now(),
          isSystemMessage: true,
        ),
      );
    });

    // Simulate other user's response after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _showRevealResponseDialog();
      }
    });
  }

  void _showRevealResponseDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Reveal Request',
            style: TextStyle(
              color: textLight,
              fontFamily: 'Bold',
              fontSize: 20,
            ),
          ),
          content: const Text(
            'User A wants to reveal their identity. Both users must accept to see real profiles.',
            style: TextStyle(
              color: textGrey,
              fontFamily: 'Regular',
              fontSize: 15,
            ),
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.red,
                  width: 1,
                ),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _declineReveal();
                },
                child: const Text(
                  'Decline',
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'Medium',
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [accent, accent.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _acceptReveal();
                },
                child: const Text(
                  'Accept',
                  style: TextStyle(
                    color: textLight,
                    fontFamily: 'Medium',
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _acceptReveal() {
    setState(() {
      _isRevealed = true;
      _messages.add(
        ChatMessage(
          text: "🎉 Both users accepted! Identities revealed!",
          isFromUser: false,
          timestamp: DateTime.now(),
          isSystemMessage: true,
        ),
      );
    });

    // Start avatar animation
    _startAvatarAnimation();
  }

  void _startAvatarAnimation() {
    setState(() {
      _isAnimating = true;
    });

    // Start pulse animation
    _pulseAnimationController.repeat(reverse: true);

    // Start avatar reveal animation after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _avatarAnimationController.forward();

        // Stop pulse and show celebration dialog after animation
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (mounted) {
            _pulseAnimationController.stop();
            setState(() {
              _isAnimating = false;
            });

            // Show celebration screen
            _showCelebrationScreen();
          }
        });
      }
    });
  }

  void _declineReveal() {
    setState(() {
      _canReveal = true; // Reset to allow reveal again
      _messages.add(
        ChatMessage(
          text: "❌ Reveal request declined. You can try again later.",
          isFromUser: false,
          timestamp: DateTime.now(),
          isSystemMessage: true,
        ),
      );
    });
  }

  void _showCelebrationScreen() {
    Navigator.pushNamed(
      context,
      '/identities-revealed',
      arguments: {
        'userAName': _userAName,
        'userAAge': _userAAge,
        'userBName': _userBName,
        'userBAge': _userBAge,
      },
    );
  }

  void _showUserProfile(String name, String age, String city) {
    Navigator.pushNamed(
      context,
      '/user_profile',
      arguments: {
        'name': name,
        'age': age,
        'city': city,
      },
    );
  }

  void _showEndChatDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'End Chat',
            style: TextStyle(
              color: textLight,
              fontFamily: 'Bold',
              fontSize: 20,
            ),
          ),
          content: const Text(
            'Are you sure you want to end this chat? This action cannot be undone.',
            style: TextStyle(
              color: textGrey,
              fontFamily: 'Regular',
              fontSize: 15,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: textGrey,
                  fontFamily: 'Medium',
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red, Colors.red.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _endChat();
                },
                child: const Text(
                  'End Chat',
                  style: TextStyle(
                    color: textLight,
                    fontFamily: 'Medium',
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _endChat() {
    // Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chat ended'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 2),
      ),
    );

    // Navigate back to home
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
      (route) => false,
    );
  }

  void _showChatOptions() {
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
            Container(
              width: 45,
              height: 5,
              decoration: BoxDecoration(
                color: textGrey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 25),
            ListTile(
              leading: const Icon(FontAwesomeIcons.xmark,
                  color: textLight, size: 22),
              title: const Text(
                'End Chat',
                style: TextStyle(
                  color: textLight,
                  fontFamily: 'Medium',
                  fontSize: 17,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showEndChatDialog();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isFromUser;
  final DateTime timestamp;
  final bool isSystemMessage;

  ChatMessage({
    required this.text,
    required this.isFromUser,
    required this.timestamp,
    this.isSystemMessage = false,
  });
}
