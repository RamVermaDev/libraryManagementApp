import 'package:flutter_riverpod/legacy.dart';

final currentLibraryProvider =
    StateNotifierProvider<CurrentLibraryNotifier, String?>((ref) {
      return CurrentLibraryNotifier();
    });

final currentLibraryNameProvider =
    StateNotifierProvider<CurrentLibraryNameNotifier, String?>((ref) {
      return CurrentLibraryNameNotifier();
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

class CurrentLibraryNameNotifier extends StateNotifier<String?> {
  CurrentLibraryNameNotifier() : super(null);

  void setLibraryName(String? name) {
    state = name;
  }

  void clear() {
    state = null;
  }

  String? getCurrentLibraryName() {
    return state;
  }
}
