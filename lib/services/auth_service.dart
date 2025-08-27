import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finger_on_the_app/services/session_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SessionService _sessionService = SessionService();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Check if user is authenticated
  bool get isAuthenticated => _auth.currentUser != null;

  // Check if user has valid persistent session
  Future<bool> hasValidSession() async {
    // Check if we have a saved login state
    if (!_sessionService.isLoggedIn()) {
      return false;
    }

    // Check if user still exists in Firebase
    String? userId = _sessionService.getUserId();
    if (userId == null) {
      return false;
    }

    try {
      // Try to get the user document from Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      return userDoc.exists;
    } catch (e) {
      print('Error checking user document: $e');
      return false;
    }
  }

  // Anonymous sign in
  Future<UserCredential?> signInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;

      if (user != null) {
        // Create user document in Firestore if it doesn't exist
        await _createUserDocument(user);

        // Save login state to persistent storage
        await _sessionService.saveLoginState(user.uid);

        return result;
      }
      return null;
    } catch (e) {
      print('Error signing in anonymously: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();

      // Clear login state from persistent storage
      await _sessionService.clearLoginState();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Create user document in Firestore
  Future<void> _createUserDocument(User user) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'isAnonymous': user.isAnonymous,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLoginAt': FieldValue.serverTimestamp(),
          'profileSetup': false,
          'imagesUploaded': false,
        });
      } else {
        // Update last login time
        await _firestore.collection('users').doc(user.uid).update({
          'lastLoginAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error creating user document: $e');
    }
  }

  // Check if user profile is set up
  Future<bool> isProfileSetup() async {
    try {
      if (currentUser == null) return false;

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser!.uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        return userData['profileSetup'] ?? false;
      }
      return false;
    } catch (e) {
      print('Error checking profile setup: $e');
      return false;
    }
  }

  // Check if user images are uploaded
  Future<bool> areImagesUploaded() async {
    try {
      if (currentUser == null) return false;

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser!.uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        return userData['imagesUploaded'] ?? false;
      }
      return false;
    } catch (e) {
      print('Error checking images uploaded: $e');
      return false;
    }
  }

  // Update profile setup status
  Future<void> markProfileAsSetup() async {
    try {
      if (currentUser != null) {
        await _firestore.collection('users').doc(currentUser!.uid).update({
          'profileSetup': true,
          'profileSetupAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error marking profile as setup: $e');
    }
  }

  // Update images uploaded status
  Future<void> markImagesAsUploaded() async {
    try {
      if (currentUser != null) {
        await _firestore.collection('users').doc(currentUser!.uid).update({
          'imagesUploaded': true,
          'imagesUploadedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error marking images as uploaded: $e');
    }
  }

  // Save user profile data
  Future<void> saveUserProfile({
    required String name,
    required String age,
    required String gender,
    required String preference,
    required String city,
    String? bio,
  }) async {
    try {
      if (currentUser != null) {
        await _firestore.collection('users').doc(currentUser!.uid).update({
          'name': name,
          'age': age,
          'gender': gender,
          'preference': preference,
          'city': city,
          'bio': bio ?? '',
          'profileSetup': true,
          'profileSetupAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error saving user profile: $e');
    }
  }

  // Save user image URLs to Firestore
  Future<void> saveUserImages({
    required String avatarUrl,
    required List<String> imageUrls,
  }) async {
    try {
      print('Saving user images to Firestore:');
      print('Avatar URL: $avatarUrl');
      print('Image URLs: $imageUrls');

      if (currentUser != null) {
        await _firestore.collection('users').doc(currentUser!.uid).update({
          'avatarUrl': avatarUrl,
          'imageUrls': imageUrls,
          'imagesUploaded': true,
          'imagesUploadedAt': FieldValue.serverTimestamp(),
        });
        print('User images saved successfully');
      }
    } catch (e) {
      print('Error saving user images: $e');
    }
  }

  // Get user profile data
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      if (currentUser == null) return null;

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser!.uid).get();

      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  // Delete user account
  Future<void> deleteAccount() async {
    try {
      if (currentUser != null) {
        String uid = currentUser!.uid;

        // Delete user document from Firestore
        await _firestore.collection('users').doc(uid).delete();

        // Delete user from Auth
        await currentUser!.delete();

        // Clear login state from persistent storage
        await _sessionService.clearLoginState();
      }
    } catch (e) {
      print('Error deleting account: $e');
    }
  }
}
