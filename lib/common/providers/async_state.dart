import 'package:flutter_riverpod/flutter_riverpod.dart';

final asyncStateProvider =
    StateNotifierProvider<AsyncState, bool>((ref) => AsyncState());

class AsyncState extends StateNotifier<bool> {
  AsyncState() : super(false);

  bool toggle() => state = !state;
}
