import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final bool isEmailVerified;
  final String role;
  final String status;
  final List<String> libraries;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.isEmailVerified,
    required this.role,
    required this.status,
    required this.libraries,
  });

  Map<String, dynamic> toMap() {
    return {
      "_id": id,
      "name": name,
      "email": email,
      "password": password,
      "isEmailVerified": isEmailVerified,
      "role": role,
      "status": status,
      "libraries": libraries,
    };
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map["_id"] ?? map["id"] ?? "",
      name: map["name"] ?? "",
      email: map["email"] ?? "",
      password: map["password"] ?? "",
      isEmailVerified: map["isEmailVerified"] ?? false,
      role: map["role"] ?? "user",
      status: map["status"] ?? "active",
      libraries: List<String>.from(map['libraries'] ?? []),
    );
  }

  factory UserModel.fromJson(String source) {
    return UserModel.fromMap(jsonDecode(source));
  }
}
