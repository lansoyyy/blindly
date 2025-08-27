import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/landing_screen.dart';
import '../screens/auth/account_setup_screen.dart';
import '../screens/auth/image_upload_screen.dart';
import '../screens/home_screen.dart';

class AuthStateWrapper extends StatefulWidget {
  final AuthService _authService = AuthService();

  AuthStateWrapper({super.key});

  @override
  State<AuthStateWrapper> createState() => _AuthStateWrapperState();
}

class _AuthStateWrapperState extends State<AuthStateWrapper> {
  bool _isCheckingSession = true;
  bool _shouldAutoLogin = false;

  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
    try {
      // Check if user has a valid persistent session
      bool hasValidSession = await widget._authService.hasValidSession();

      setState(() {
        _shouldAutoLogin = hasValidSession;
        _isCheckingSession = false;
      });
    } catch (e) {
      print('Error checking auto-login: $e');
      setState(() {
        _isCheckingSession = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show splash screen while checking session
    if (_isCheckingSession) {
      return const SplashScreen();
    }

    // If we should auto-login, attempt to sign in anonymously
    if (_shouldAutoLogin) {
      return FutureBuilder<UserCredential?>(
        future: widget._authService.signInAnonymously(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }

          if (snapshot.hasError || !snapshot.hasData) {
            // Auto-login failed, show landing screen
            return const LandingScreen();
          }

          // Auto-login successful, determine where to navigate
          return FutureBuilder<String>(
            future: _determineInitialRoute(),
            builder: (context, routeSnapshot) {
              if (routeSnapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen();
              }

              String initialRoute = routeSnapshot.data ?? '/landing';

              // Navigate to appropriate screen based on user setup status
              switch (initialRoute) {
                case '/setup':
                  return const AccountSetupScreen();
                case '/upload-images':
                  return const ImageUploadScreen();
                case '/home':
                  return const HomeScreen();
                default:
                  return const LandingScreen();
              }
            },
          );
        },
      );
    }

    // No auto-login, use normal auth state stream
    return StreamBuilder<User?>(
      stream: widget._authService.authStateChanges,
      builder: (context, snapshot) {
        // Show splash screen while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        // User is not authenticated - show landing screen
        if (!snapshot.hasData || snapshot.data == null) {
          return const LandingScreen();
        }

        // User is authenticated - determine where to navigate
        return FutureBuilder<String>(
          future: _determineInitialRoute(),
          builder: (context, routeSnapshot) {
            if (routeSnapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }

            String initialRoute = routeSnapshot.data ?? '/landing';

            // Navigate to appropriate screen based on user setup status
            switch (initialRoute) {
              case '/setup':
                return const AccountSetupScreen();
              case '/upload-images':
                return const ImageUploadScreen();
              case '/home':
                return const HomeScreen();
              default:
                return const LandingScreen();
            }
          },
        );
      },
    );
  }

  Future<String> _determineInitialRoute() async {
    try {
      // Check if user profile is set up
      bool profileSetup = await widget._authService.isProfileSetup();

      if (!profileSetup) {
        return '/setup';
      }

      // Check if user images are uploaded
      bool imagesUploaded = await widget._authService.areImagesUploaded();

      if (!imagesUploaded) {
        return '/upload-images';
      }

      // User is fully set up - go to home
      return '/home';
    } catch (e) {
      print('Error determining initial route: $e');
      return '/landing';
    }
  }
}
