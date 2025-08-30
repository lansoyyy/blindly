import 'package:finger_on_the_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'widgets/auth_state_wrapper.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/auth/landing_screen.dart';
import 'screens/auth/account_setup_screen.dart';
import 'screens/auth/image_upload_screen.dart';
import 'screens/home_screen.dart';
import 'screens/find_match_screen.dart';
import 'screens/mechanics_screen.dart';
import 'screens/chat/anonymous_chat_screen.dart';
import 'screens/user_profile_screen.dart';
import 'screens/chat/identities_revealed_screen.dart';
import 'screens/full_screen_image_viewer.dart';
import 'utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'blindly-bd0d3',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize GetStorage for persistent session management
  await GetStorage.init();

  runApp(const BlindlyApp());
}

class BlindlyApp extends StatelessWidget {
  const BlindlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blindly',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Regular',
        scaffoldBackgroundColor: background,
      ),
      home: AuthStateWrapper(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/landing': (context) => const LandingScreen(),
        '/setup': (context) => const AccountSetupScreen(),
        '/upload-images': (context) => const ImageUploadScreen(),
        '/home': (context) => const HomeScreen(),
        '/find-match': (context) => const FindMatchScreen(),
        '/mechanics': (context) => const MechanicsScreen(),
        '/anonymous-chat': (context) => const AnonymousChatScreen(),
        '/user_profile': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return UserProfileScreen(userData: args);
        },
        '/identities-revealed': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return IdentitiesRevealedScreen(
            userAName: args['userAName'],
            userAAge: args['userAAge'],
            userBName: args['userBName'],
            userBAge: args['userBAge'],
          );
        },
        '/full-screen-image': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return FullScreenImageViewer(
            imagePath: args['imagePath'],
            userName: args['userName'],
            isNetworkImage: args['isNetworkImage'] ?? false,
          );
        },
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
