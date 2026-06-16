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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      isEmailVerified: json["isEmailVerified"] ?? false,
      role: json["role"] ?? "user",
      status: json["status"] ?? "active",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "email": email,
      "isEmailVerified": isEmailVerified,
      "role": role,
      "status": status,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    bool? isEmailVerified,
    String? role,
    String? status,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      role: role ?? this.role,
      status: status ?? this.status,
    );
  }
}
