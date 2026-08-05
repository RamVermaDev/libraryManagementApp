import 'package:flutter_riverpod/legacy.dart';
import 'package:library_management/local_storage.dart';

enum AppMode { admin, reception, general }

extension AppModeExtension on AppMode {
  String get key {
    switch (this) {
      case AppMode.admin:
        return 'admin';
      case AppMode.reception:
        return 'reception';
      case AppMode.general:
        return 'general';
    }
  }

  String get label {
    switch (this) {
      case AppMode.admin:
        return 'ADMIN';
      case AppMode.reception:
        return 'RECEPTION';
      case AppMode.general:
        return 'GENERAL';
    }
  }

  static AppMode fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'reception':
        return AppMode.reception;
      case 'general':
        return AppMode.general;
      case 'admin':
      default:
        return AppMode.admin;
    }
  }
}

class AppModeNotifier extends StateNotifier<AppMode> {
  AppModeNotifier() : super(AppMode.admin) {
    _loadSavedMode();
  }

  Future<void> _loadSavedMode() async {
    try {
      final savedStr = await LocalStorage.getAppMode();
      if (savedStr != null) {
        state = AppModeExtension.fromString(savedStr);
      } else {
        state = AppMode.admin;
        await LocalStorage.saveAppMode(AppMode.admin.key);
      }
    } catch (_) {}
  }

  Future<void> setMode(AppMode newMode) async {
    state = newMode;
    try {
      await LocalStorage.saveAppMode(newMode.key);
    } catch (_) {}
  }
}

final appModeProvider = StateNotifierProvider<AppModeNotifier, AppMode>(
  (ref) => AppModeNotifier(),
);
