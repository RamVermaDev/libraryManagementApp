import 'package:flutter_riverpod/legacy.dart';
import 'package:library_management/models/user_model.dart';

final userProvider = StateNotifierProvider<UserProvider, UserModel?>((ref) {
  return UserProvider();
});

class UserProvider extends StateNotifier<UserModel?> {
  UserProvider() : super(null);

  UserModel? get user => state;

  void setUser(String userJson) {
    state = UserModel.fromJson(userJson);
  }

  void clearUser() {
    state = null;
  }
}
