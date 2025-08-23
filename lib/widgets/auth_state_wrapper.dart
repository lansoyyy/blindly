import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../screens/splash_screen.dart';
import '../screens/landing_screen.dart';
import '../screens/account_setup_screen.dart';
import '../screens/image_upload_screen.dart';
import '../screens/home_screen.dart';

class AuthStateWrapper extends StatelessWidget {
  final AuthService _authService = AuthService();

  AuthStateWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
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
      bool profileSetup = await _authService.isProfileSetup();

      if (!profileSetup) {
        return '/setup';
      }

      // Check if user images are uploaded
      bool imagesUploaded = await _authService.areImagesUploaded();

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
