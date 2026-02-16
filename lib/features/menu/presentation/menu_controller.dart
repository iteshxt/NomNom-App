import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedOutletIdNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String id) {
    state = id;
  }
}

final selectedOutletIdProvider =
    NotifierProvider<SelectedOutletIdNotifier, String?>(
      SelectedOutletIdNotifier.new,
    );
