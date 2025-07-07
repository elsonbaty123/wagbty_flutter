import 'package:flutter/material.dart';
import 'dart:convert';

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  readyForPickup,
  onTheWay,
  delivered,
  cancelled,
  rejected
}

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'قيد الانتظار';
      case OrderStatus.confirmed:
        return 'تم التأكيد';
      case OrderStatus.preparing:
        return 'قيد التحضير';
      case OrderStatus.readyForPickup:
        return 'جاهز للتسليم';
      case OrderStatus.onTheWay:
        return 'في الطريق';
      case OrderStatus.delivered:
        return 'تم التسليم';
      case OrderStatus.cancelled:
        return 'ملغي';
      case OrderStatus.rejected:
        return 'مرفوض';
    }
  }

  Color get statusColor {
    switch (this) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.preparing:
        return Colors.blueAccent;
      case OrderStatus.readyForPickup:
        return Colors.green;
      case OrderStatus.onTheWay:
        return Colors.lightGreen;
      case OrderStatus.delivered:
        return Colors.green[700]!;
      case OrderStatus.cancelled:
      case OrderStatus.rejected:
        return Colors.red;
    }
  }

  IconData get statusIcon {
    switch (this) {
      case OrderStatus.pending:
        return Icons.access_time;
      case OrderStatus.confirmed:
        return Icons.check_circle_outline;
      case OrderStatus.preparing:
        return Icons.restaurant_menu;
      case OrderStatus.readyForPickup:
        return Icons.delivery_dining;
      case OrderStatus.onTheWay:
        return Icons.directions_bike;
      case OrderStatus.delivered:
        return Icons.check_circle;
      case OrderStatus.cancelled:
      case OrderStatus.rejected:
        return Icons.cancel;
    }
  }
}

class OrderItem {
  final String id;
  final String name;
  final int quantity;
  final double price;
  final String? notes;
  final String? imageUrl;

  OrderItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    this.notes,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'quantity': quantity,
        'price': price,
        'notes': notes,
        'imageUrl': imageUrl,
      };

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json['id'],
        name: json['name'],
        quantity: json['quantity'],
        price: json['price']?.toDouble() ?? 0.0,
        notes: json['notes'],
        imageUrl: json['imageUrl'],
      );
}

class OrderModel {
  final String id;
  final String userId;
  final String chefId;
  final String chefName;
  final String? chefImageUrl;
  final List<OrderItem> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final OrderStatus status;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final String deliveryAddress;
  final String? specialInstructions;
  final String? rejectionReason;
  final String? paymentMethod;
  final bool isPaid;

  OrderModel({
    required this.id,
    required this.userId,
    required this.chefId,
    required this.chefName,
    this.chefImageUrl,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.status,
    required this.orderDate,
    this.deliveryDate,
    required this.deliveryAddress,
    this.specialInstructions,
    this.rejectionReason,
    this.paymentMethod,
    this.isPaid = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'chefId': chefId,
        'chefName': chefName,
        'chefImageUrl': chefImageUrl,
        'items': items.map((item) => item.toJson()).toList(),
        'subtotal': subtotal,
        'deliveryFee': deliveryFee,
        'total': total,
        'status': status.index,
        'orderDate': orderDate.toIso8601String(),
        'deliveryDate': deliveryDate?.toIso8601String(),
        'deliveryAddress': deliveryAddress,
        'specialInstructions': specialInstructions,
        'rejectionReason': rejectionReason,
        'paymentMethod': paymentMethod,
        'isPaid': isPaid,
      };

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json['id'],
        userId: json['userId'],
        chefId: json['chefId'],
        chefName: json['chefName'],
        chefImageUrl: json['chefImageUrl'],
        items: (json['items'] as List)
            .map((item) => OrderItem.fromJson(item))
            .toList(),
        subtotal: json['subtotal']?.toDouble() ?? 0.0,
        deliveryFee: json['deliveryFee']?.toDouble() ?? 0.0,
        total: json['total']?.toDouble() ?? 0.0,
        status: OrderStatus.values[json['status'] ?? 0],
        orderDate: DateTime.parse(json['orderDate']),
        deliveryDate: json['deliveryDate'] != null
            ? DateTime.parse(json['deliveryDate'])
            : null,
        deliveryAddress: json['deliveryAddress'],
        specialInstructions: json['specialInstructions'],
        rejectionReason: json['rejectionReason'],
        paymentMethod: json['paymentMethod'],
        isPaid: json['isPaid'] ?? false,
      );

  OrderModel copyWith({
    String? id,
    String? userId,
    String? chefId,
    String? chefName,
    String? chefImageUrl,
    List<OrderItem>? items,
    double? subtotal,
    double? deliveryFee,
    double? total,
    OrderStatus? status,
    DateTime? orderDate,
    DateTime? deliveryDate,
    String? deliveryAddress,
    String? specialInstructions,
    String? rejectionReason,
    String? paymentMethod,
    bool? isPaid,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      chefId: chefId ?? this.chefId,
      chefName: chefName ?? this.chefName,
      chefImageUrl: chefImageUrl ?? this.chefImageUrl,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isPaid: isPaid ?? this.isPaid,
    );
  }
}
