import 'package:flutter_riverpod/legacy.dart';

final currentLibraryProvider =
    StateNotifierProvider<CurrentLibraryNotifier, String?>((ref) {
      return CurrentLibraryNotifier();
    });

class CurrentLibraryNotifier extends StateNotifier<String?> {
  CurrentLibraryNotifier() : super(null);

  void setLibrary(String? id) {
    state = id;
  }

  void clear() {
    state = null;
  }

  String? getCurrentLibrary() {
    return state;
  }
}
