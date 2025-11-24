class Transaction {
  final int id;
  final int boxId;
  final int penggunaId;
  final int? pengepulId;
  final String status; // pending, accepted, rejected, completed, cancelled
  final double totalPrice;
  final double adminFee;
  final double pengepulEarnings;
  final String? notes;
  final DateTime? acceptedAt;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Relationships
  final Map<String, dynamic>? box;
  final Map<String, dynamic>? pengguna;
  final Map<String, dynamic>? pengepul;

  Transaction({
    required this.id,
    required this.boxId,
    required this.penggunaId,
    this.pengepulId,
    required this.status,
    required this.totalPrice,
    required this.adminFee,
    required this.pengepulEarnings,
    this.notes,
    this.acceptedAt,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
    this.box,
    this.pengguna,
    this.pengepul,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      boxId: json['box_id'],
      penggunaId: json['pengguna_id'],
      pengepulId: json['pengepul_id'],
      status: json['status'],
      totalPrice: double.parse(json['total_price'].toString()),
      adminFee: double.parse(json['admin_fee'].toString()),
      pengepulEarnings: double.parse(json['pengepul_earnings'].toString()),
      notes: json['notes'],
      acceptedAt: json['accepted_at'] != null
          ? DateTime.parse(json['accepted_at'])
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      box: json['box'],
      pengguna: json['pengguna'],
      pengepul: json['pengepul'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'box_id': boxId,
      'pengguna_id': penggunaId,
      'pengepul_id': pengepulId,
      'status': status,
      'total_price': totalPrice,
      'admin_fee': adminFee,
      'pengepul_earnings': pengepulEarnings,
      'notes': notes,
      'accepted_at': acceptedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  bool get isPending => status == 'pending';
  bool get isAccepted => status == 'accepted';
  bool get isCompleted => status == 'completed';
  bool get isRejected => status == 'rejected';
  bool get isCancelled => status == 'cancelled';

  String get statusText {
    switch (status) {
      case 'pending':
        return 'Menunggu';
      case 'accepted':
        return 'Diterima';
      case 'completed':
        return 'Selesai';
      case 'rejected':
        return 'Ditolak';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return status;
    }
  }
}
