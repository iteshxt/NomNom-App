import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/index.dart';
import '../services/index.dart';
import 'service_providers.dart';

// Auth State Provider
final authStateProvider = StateNotifierProvider<AuthStateNotifier, User?>((
  ref,
) {
  final authService = ref.watch(authServiceProvider);
  final userService = ref.watch(userServiceProvider);
  return AuthStateNotifier(authService, userService);
});

// Guest Mode Provider
final isGuestModeProvider = StateProvider<bool>((ref) {
  return false;
});

// Auth State Notifier
class AuthStateNotifier extends StateNotifier<User?> {
  final AuthService _authService;
  final UserService _userService;

  AuthStateNotifier(this._authService, this._userService) : super(null) {
    _initializeAuth();
  }

  void _initializeAuth() {
    // Listen to Firebase auth changes reactively
    _authService.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser != null) {
        // First get the basic profile from Firebase
        final baseUser = await _authService.getCurrentUser();
        if (baseUser != null) {
          // Then fetch/sync with MongoDB
          var mongoUser = await _userService.getUser(baseUser.id);
          mongoUser ??= await _userService.updateProfile(
            userId: baseUser.id,
            name: baseUser.name,
            profilePhoto: baseUser.profilePhoto,
          );
          state = mongoUser ?? baseUser;
        }
        debugPrint('AuthStateNotifier: User logged in - ${state?.id}');
      } else {
        state = null;
        debugPrint('AuthStateNotifier: User logged out');
      }
    });
  }

  Future<void> loginWithEmail(String email, String password) async {
    try {
      await _authService.loginWithEmail(email, password);
      // State is updated by the stream listener
    } catch (e) {
      debugPrint('AuthStateNotifier Error: $e');
      rethrow;
    }
  }

  Future<void> signup(String email, String password, String name) async {
    try {
      await _authService.signup(email, password, name);
      // State is updated by the stream listener
    } catch (e) {
      debugPrint('AuthStateNotifier Error: $e');
      rethrow;
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      await _authService.loginWithGoogle();
      // State is updated by the stream listener
    } catch (e) {
      debugPrint('AuthStateNotifier Error: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    state = null;
  }

  Future<void> forgotPassword(String email) async {
    await _authService.forgotPassword(email);
  }

  bool get isLoggedIn => state != null;
  bool get isGuest => _authService.isGuestMode;
}
