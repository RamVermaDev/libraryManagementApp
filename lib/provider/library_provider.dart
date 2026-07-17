import 'package:flutter_riverpod/legacy.dart';
import 'package:library_management/models/library_model.dart';

final libraryProvider =
    StateNotifierProvider<LibraryProvider, List<LibraryModel>>((ref) {
      return LibraryProvider();
    });

class LibraryProvider extends StateNotifier<List<LibraryModel>> {
  LibraryProvider() : super([]);

  void setLibraries(List<LibraryModel> libraries) {
    state = libraries;
  }

  void addLibrary(LibraryModel library) {
    state = [library, ...state];
  }

  void updateLibrary(LibraryModel updatedLibrary) {
    state = [
      for (final library in state)
        if (library.id == updatedLibrary.id) updatedLibrary else library,
    ];
  }

  void clearLibraries() {
    state = [];
  }
}
