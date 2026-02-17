import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:google_sign_in/google_sign_in.dart';
import '../models/index.dart';

class AuthService {
  final firebase.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthService({
    firebase.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    this.serverClientId,
  })  : _firebaseAuth = firebaseAuth ?? firebase.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final String? serverClientId;
  bool _isGuestMode = false;
  User? _currentUser;
  bool _isInitialized = false;

  bool get isGuestMode => _isGuestMode;
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null && !_isGuestMode;

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      try {
        await _googleSignIn.initialize(serverClientId: serverClientId);
      } catch (e) {
        debugPrint('GoogleSignIn initialization warning: $e');
      }
      _isInitialized = true;
    }
  }

  // Login with email and password
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      debugPrint('Attempting email login for: $email');
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;
      if (user != null) {
        _currentUser = _mapFirebaseUser(user);
        _isGuestMode = false;
        debugPrint('Email login successful: ${_currentUser?.id}');
        return _currentUser;
      }
      debugPrint('Email login failed: Firebase user is null');
      return null;
    } catch (e) {
      debugPrint('Error during email login: $e');
      rethrow;
    }
  }

  // Signup with email and password
  Future<User?> signup(String email, String password, String name) async {
    try {
      debugPrint('Attempting email signup for: $email');
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;
      if (user != null) {
        await user.updateDisplayName(name);
        await user.reload();

        final updatedUser = _firebaseAuth.currentUser;
        _currentUser = _mapFirebaseUser(updatedUser!);
        _isGuestMode = false;
        debugPrint('Email signup successful: ${_currentUser?.id}');
        return _currentUser;
      }
      debugPrint('Email signup failed: Firebase user is null');
      return null;
    } catch (e) {
      debugPrint('Error during signup: $e');
      rethrow;
    }
  }

  // Login with Google
  Future<User?> loginWithGoogle() async {
    try {
      debugPrint('Attempting Google login...');
      await _ensureInitialized();

      // In google_sign_in 7.x, authenticate() is preferred if configured
      // but signIn() still works on many platforms if standard initialization is used.
      // However, the error suggests serverClientId is missing.
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final String? idToken = googleAuth.idToken;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: null,
        idToken: idToken,
      );

      final UserCredential result = await _firebaseAuth.signInWithCredential(
        credential,
      );
      final user = result.user;

      if (user != null) {
        _currentUser = _mapFirebaseUser(user);
        _isGuestMode = false;
        debugPrint('Google login successful: ${_currentUser?.id}');
        return _currentUser;
      }
      debugPrint('Google login failed: Firebase user is null');
      return null;
    } catch (e) {
      debugPrint('Error during Google login: $e');
      if (e.toString().contains('serverClientId')) {
        debugPrint(
          'FIX: You must provide a serverClientId for Google Sign-In on Android. '
          'Find it in Firebase Console -> Project Settings -> General -> Your Apps (Web client ID).',
        );
      }
      rethrow;
    }
  }

  // Guest mode
  Future<void> enterGuestMode() async {
    debugPrint('Entering guest mode');
    _isGuestMode = true;
    _currentUser = null;
  }

  // Logout
  Future<void> logout() async {
    try {
      debugPrint('Logging out');
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      _currentUser = null;
      _isGuestMode = false;
    } catch (e) {
      debugPrint('Error during logout: $e');
      rethrow;
    }
  }

  // Forgot password
  Future<void> forgotPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint('Error during forgot password: $e');
      rethrow;
    }
  }

  // Get current user from Firebase
  Future<User?> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null) {
      _currentUser = _mapFirebaseUser(firebaseUser);
      _isGuestMode = false;
      return _currentUser;
    }
    return null;
  }

  // Verify email
  Future<void> verifyEmail() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      debugPrint('Error during email verification: $e');
      rethrow;
    }
  }

  // Listen to auth state changes
  Stream<firebase.User?> authStateChanges() => _firebaseAuth.authStateChanges();

  User _mapFirebaseUser(firebase.User user) {
    return User(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? 'User',
      phone: user.phoneNumber ?? '',
      profilePhoto: user.photoURL,
      pushNotificationEnabled: true,
    );
  }
}

typedef AuthCredential = firebase.AuthCredential;
typedef UserCredential = firebase.UserCredential;
typedef GoogleAuthProvider = firebase.GoogleAuthProvider;
