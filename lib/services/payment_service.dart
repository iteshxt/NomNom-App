class PaymentService {
  // Mock payment processing
  Future<bool> processPayment({
    required String orderId,
    required double amount,
    required String paymentMethod,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock: 90% success rate for demo purposes
    final isSuccess = DateTime.now().millisecond % 10 != 0;
    return isSuccess;
  }

  Future<bool> validatePaymentMethod(String method) async {
    // Validate payment method
    final validMethods = ['card', 'upi', 'wallet', 'mock'];
    return validMethods.contains(method);
  }

  Future<String> getPaymentStatus(String orderId) async {
    // Return mock payment status
    return 'completed';
  }
}
