import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String email;
  final bool isEmailVerified;
  final String role;
  final String status;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.isEmailVerified,
    required this.role,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      "_id": id,
      "name": name,
      "email": email,
      "isEmailVerified": isEmailVerified,
      "role": role,
      "status": status,
    };
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map["_id"] ?? "",
      name: map["name"] ?? "",
      email: map["email"] ?? "",
      isEmailVerified: map["isEmailVerified"] ?? false,
      role: map["role"] ?? "user",
      status: map["status"] ?? "active",
    );
  }

  factory UserModel.fromJson(String source){
    return UserModel.fromMap(jsonDecode(source));
  }
  
}
