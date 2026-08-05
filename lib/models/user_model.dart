import 'dart:convert';

// Nested subscription model — mirrors backend userModel.subscription schema
class SubscriptionModel {
  final String plan;
  final String status;
  final DateTime? startAt;
  final DateTime? endAt;

  const SubscriptionModel({
    required this.plan,
    required this.status,
    this.startAt,
    this.endAt,
  });

  /// Days remaining from now until endAt. Returns 0 if expired or no endAt.
  int get daysRemaining {
    if (endAt == null) return 0;
    final diff = endAt!.difference(DateTime.now()).inHours;
    final days = (diff / 24).ceil();
    return days > 0 ? days : 0;
  }

  bool get isExpired => daysRemaining <= 0;
  bool get isTrial => status == 'trial';
  bool get isActive => status == 'active';

  Map<String, dynamic> toMap() {
    return {
      'plan': plan,
      'status': status,
      'startAt': startAt?.toIso8601String(),
      'endAt': endAt?.toIso8601String(),
    };
  }

  factory SubscriptionModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionModel(
      plan: map['plan'] ?? 'trial',
      status: map['status'] ?? 'trial',
      startAt: map['startAt'] != null
          ? DateTime.tryParse(map['startAt'].toString())?.toLocal()
          : null,
      endAt: map['endAt'] != null
          ? DateTime.tryParse(map['endAt'].toString())?.toLocal()
          : null,
    );
  }

  /// Default trial subscription — used as fallback when no data from server yet
  factory SubscriptionModel.defaultTrial() {
    return const SubscriptionModel(
      plan: 'trial',
      status: 'trial',
      startAt: null,
      endAt: null,
    );
  }
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final bool isEmailVerified;
  final String role;
  final String status;
  final List<String> libraries;
  final DateTime? createdAt;
  final SubscriptionModel subscription;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.isEmailVerified,
    required this.role,
    required this.status,
    required this.libraries,
    this.createdAt,
    SubscriptionModel? subscription,
  }) : subscription =
           subscription ??
           const SubscriptionModel(plan: 'trial', status: 'trial');

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
      "createdAt": createdAt?.toIso8601String(),
      "subscription": subscription.toMap(),
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
      createdAt: map["createdAt"] != null
          ? DateTime.tryParse(map["createdAt"].toString())?.toLocal()
          : null,
      subscription: map["subscription"] != null
          ? SubscriptionModel.fromMap(
              Map<String, dynamic>.from(map["subscription"]),
            )
          : SubscriptionModel.defaultTrial(),
    );
  }

  factory UserModel.fromJson(String source) {
    return UserModel.fromMap(jsonDecode(source));
  }
}
