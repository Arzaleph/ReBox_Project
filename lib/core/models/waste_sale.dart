class WasteSale {
  final int? id;
  final int userId;
  final String wasteType;
  final double weight;
  final double pricePerKg;
  final double totalPrice;
  final String? description;
  final String? photoPath;
  final String status;
  final String? adminNotes;
  final DateTime? approvedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WasteSale({
    this.id,
    required this.userId,
    required this.wasteType,
    required this.weight,
    required this.pricePerKg,
    required this.totalPrice,
    this.description,
    this.photoPath,
    this.status = 'pending',
    this.adminNotes,
    this.approvedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory WasteSale.fromJson(Map<String, dynamic> json) {
    return WasteSale(
      id: json['id'],
      userId: json['user_id'],
      wasteType: json['waste_type'],
      weight: double.parse(json['weight'].toString()),
      pricePerKg: double.parse(json['price_per_kg'].toString()),
      totalPrice: double.parse(json['total_price'].toString()),
      description: json['description'],
      photoPath: json['photo_path'],
      status: json['status'] ?? 'pending',
      adminNotes: json['admin_notes'],
      approvedAt: json['approved_at'] != null 
          ? DateTime.parse(json['approved_at']) 
          : null,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'waste_type': wasteType,
      'weight': weight,
      'price_per_kg': pricePerKg,
      'total_price': totalPrice,
      'description': description,
      'photo_path': photoPath,
      'status': status,
      'admin_notes': adminNotes,
      'approved_at': approvedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  String getStatusText() {
    switch (status) {
      case 'pending':
        return 'Menunggu';
      case 'approved':
        return 'Disetujui';
      case 'rejected':
        return 'Ditolak';
      case 'completed':
        return 'Selesai';
      default:
        return status;
    }
  }

  String getWasteTypeText() {
    switch (wasteType) {
      case 'plastik':
        return 'Plastik';
      case 'kertas':
        return 'Kertas';
      case 'logam':
        return 'Logam';
      case 'kaca':
        return 'Kaca';
      case 'organik':
        return 'Organik';
      case 'elektronik':
        return 'Elektronik';
      default:
        return wasteType;
    }
  }
}
