import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_pti/pesanan/remote_orders_service.dart';

class Order {
  String id;
  String itemName;
  double weightKg;
  double pricePerKg;
  DateTime timestamp;
  bool completed;
  bool synced;

  Order({
    required this.id,
    required this.itemName,
    required this.weightKg,
    required this.pricePerKg,
    required this.timestamp,
    this.completed = false,
    this.synced = false,
  });

  double get total => weightKg * pricePerKg;

  factory Order.fromMap(Map<String, dynamic> m) => Order(
        id: m['id'].toString(),
        itemName: m['itemName']?.toString() ?? '',
        weightKg: (m['weightKg'] is num) ? (m['weightKg'] as num).toDouble() : double.tryParse(m['weightKg']?.toString() ?? '0') ?? 0,
        pricePerKg: (m['pricePerKg'] is num) ? (m['pricePerKg'] as num).toDouble() : double.tryParse(m['pricePerKg']?.toString() ?? '0') ?? 0,
        timestamp: DateTime.parse(m['timestamp'] as String),
        completed: m['completed'] as bool? ?? false,
        synced: m['synced'] as bool? ?? false,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'itemName': itemName,
        'weightKg': weightKg,
        'pricePerKg': pricePerKg,
        'timestamp': timestamp.toIso8601String(),
        'completed': completed,
        'synced': synced,
      };
}

class OrderService extends ChangeNotifier {
  OrderService._internal();
  static final OrderService instance = OrderService._internal();

  static const _kKey = 'orders_list';
  late SharedPreferences _prefs;

  List<Order> _orders = [];
  List<Order> get orders => List.unmodifiable(_orders);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs.getString(_kKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        final list = jsonDecode(raw) as List<dynamic>;
        _orders = list.map((e) => Order.fromMap(Map<String, dynamic>.from(e as Map))).toList();
      } catch (_) {
        _orders = [];
      }
    }
    notifyListeners();
  }

  Future<void> _save() async {
    final encoded = jsonEncode(_orders.map((e) => e.toMap()).toList());
    await _prefs.setString(_kKey, encoded);
  }

  Future<void> addOrder({required String itemName, required double weightKg, required double pricePerKg}) async {
    final o = Order(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      itemName: itemName,
      weightKg: weightKg,
      pricePerKg: pricePerKg,
      timestamp: DateTime.now(),
      completed: false,
      synced: false,
    );
    _orders.insert(0, o);
    await _save();
    notifyListeners();
    // attempt sync
    try {
      await RemoteOrdersService.instance.postOrder(o.toMap());
      // if success mark synced
      o.synced = true;
      await _save();
      notifyListeners();
    } catch (_) {
      // leave as not synced
    }
  }

  Future<void> remove(String id) async {
    _orders.removeWhere((e) => e.id == id);
    await _save();
    notifyListeners();
  }

  Future<void> markCompleted(String id, {bool completed = true}) async {
    final idx = _orders.indexWhere((e) => e.id == id);
    if (idx != -1) {
      _orders[idx].completed = completed;
      await _save();
      notifyListeners();
    }
  }

  /// Attempt to sync unsynced orders to remote; returns number of synced orders.
  Future<int> syncPending() async {
    int syncedCount = 0;
    for (final o in List<Order>.from(_orders)) {
      if (o.synced) continue;
      try {
        await RemoteOrdersService.instance.postOrder(o.toMap());
        o.synced = true;
        syncedCount++;
      } catch (_) {
        // stop or continue? we continue to attempt others
      }
    }
    if (syncedCount > 0) {
      await _save();
      notifyListeners();
    }
    return syncedCount;
  }

  Future<void> clearAll() async {
    _orders.clear();
    await _prefs.remove(_kKey);
    notifyListeners();
  }
}
