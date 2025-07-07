import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wagbty/models/order_model.dart';

class OrderNotifier extends StateNotifier<AsyncValue<List<OrderModel>>> {
  final SharedPreferences prefs;
  static const String _ordersKey = 'user_orders';

  OrderNotifier(this.prefs) : super(const AsyncValue.loading()) {
    loadOrders();
  }

  // Made public for testing purposes
  Future<void> loadOrders() async {
    try {
      state = const AsyncValue.loading();
      final ordersJson = prefs.getStringList(_ordersKey) ?? [];
      final orders = ordersJson
          .map((json) => OrderModel.fromJson(json is String ? jsonDecode(json) : json))
          .toList();
      
      // Sort orders by date (newest first)
      orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
      
      state = AsyncValue.data(orders);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> _saveOrders(List<OrderModel> orders) async {
    final ordersJson = orders
        .map((order) => jsonEncode(order.toJson()))
        .toList();
    await prefs.setStringList(_ordersKey, List<String>.from(ordersJson));
    state = AsyncValue.data(orders);
  }

  Future<void> addOrder(OrderModel order) async {
    final currentOrders = state.value ?? [];
    await _saveOrders([...currentOrders, order]);
  }

  Future<void> updateOrder(OrderModel updatedOrder) async {
    final currentOrders = state.value ?? [];
    final index = currentOrders.indexWhere((order) => order.id == updatedOrder.id);
    if (index != -1) {
      final updatedOrders = List<OrderModel>.from(currentOrders);
      updatedOrders[index] = updatedOrder;
      await _saveOrders(updatedOrders);
    }
  }

  Future<void> cancelOrder(String orderId) async {
    final currentOrders = state.value ?? [];
    final index = currentOrders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      final updatedOrder = currentOrders[index].copyWith(
        status: OrderStatus.cancelled,
      );
      await updateOrder(updatedOrder);
    }
  }

  List<OrderModel> getOrdersByStatus(OrderStatus status) {
    final orders = state.value ?? [];
    return orders.where((order) => order.status == status).toList();
  }
}

final orderProvider = StateNotifierProvider<OrderNotifier, AsyncValue<List<OrderModel>>>(
  (ref) {
    throw UnimplementedError('orderProvider should be overridden in main.dart');
  },
);
