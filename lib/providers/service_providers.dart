import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/index.dart';

// Service Providers
final localStorageServiceProvider = Provider((ref) {
  return LocalStorageService();
});

final authServiceProvider = Provider((ref) {
  return AuthService(
    serverClientId:
        '509566537943-u20s3f0mq3lg98kr0qb589hu47odb6ba.apps.googleusercontent.com',
  );
});

final outletServiceProvider = Provider((ref) {
  return OutletService();
});

final menuServiceProvider = Provider((ref) {
  return MenuService();
});

final orderServiceProvider = Provider((ref) {
  final outletService = ref.watch(outletServiceProvider);
  return OrderService(outletService);
});

final paymentServiceProvider = Provider((ref) {
  return PaymentService();
});

final userServiceProvider = Provider((ref) {
  return UserService();
});

final notificationServiceProvider = Provider((ref) {
  return NotificationService();
});
