import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/api/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

class AuthController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // Initial state is null (data)
    return null;
  }

  Future<void> loginWithGoogle() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(authServiceProvider).signInWithGoogle(),
    );
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref
          .read(authServiceProvider)
          .signInWithEmailAndPassword(email, password),
    );
  }

  Future<void> signup(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref
          .read(authServiceProvider)
          .createUserWithEmailAndPassword(email, password),
    );
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(authServiceProvider).signOut(),
    );
  }

  Future<void> forgotPassword(String email) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(authServiceProvider).sendPasswordResetEmail(email),
    );
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(
  AuthController.new,
);
