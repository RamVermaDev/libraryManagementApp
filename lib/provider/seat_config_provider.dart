import 'package:flutter_riverpod/legacy.dart';
import 'package:library_management/models/seat_config_model.dart';

final seatConfigProvider =
    StateNotifierProvider<SeatConfigNotifier, SeatConfigModel?>((ref) {
  return SeatConfigNotifier();
});

class SeatConfigNotifier extends StateNotifier<SeatConfigModel?> {
  SeatConfigNotifier() : super(null);

  void setConfig(SeatConfigModel config) {
    state = config;
  }

  void clearConfig() {
    state = null;
  }
}
