class User {
  final int id;
  final String name;
  final String email;
  final String role; // pengguna, pengepul, admin
  final String? avatar;
  final String? phone;
  final String? bio;
  final String? address;
  final double? balance; // For pengepul
  final DateTime? emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.role = 'pengguna',
    this.avatar,
    this.phone,
    this.bio,
    this.address,
    this.balance,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'] ?? 'pengguna',
      avatar: json['avatar'],
      phone: json['phone'],
      bio: json['bio'],
      address: json['address'],
      balance: json['balance'] != null 
          ? double.parse(json['balance'].toString())
          : null,
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'avatar': avatar,
      'phone': phone,
      'bio': bio,
      'address': address,
      'balance': balance,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  bool get isAdmin => role == 'admin';
  bool get isPengepul => role == 'pengepul';
  bool get isPengguna => role == 'pengguna';
}
