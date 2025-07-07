import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:wagbty/models/order_model.dart';

class MockOrderNotifier extends StateNotifier<AsyncValue<List<OrderModel>>>
    with Mock {
  MockOrderNotifier() : super(const AsyncValue.loading()) {
    // Initialize with some mock data
    state = AsyncValue.data([
      OrderModel(
        id: 'order1',
        userId: 'user1',
        chefId: 'chef1',
        chefName: 'Chef Ali',
        chefImageUrl: 'https://example.com/chef1.jpg',
        items: [
          OrderItem(
            id: 'item1',
            name: 'كبسة لحم',
            quantity: 2,
            price: 35.0,
          ),
          OrderItem(
            id: 'item2',
            name: 'سلطة',
            quantity: 1,
            price: 10.0,
          ),
        ],
        subtotal: 80.0,
        deliveryFee: 15.0,
        total: 95.0,
        status: OrderStatus.preparing,
        orderDate: DateTime.now().subtract(const Duration(hours: 2)),
        deliveryAddress: '123 شارع الرياض، الرياض 12345',
        paymentMethod: 'بطاقة ائتمانية',
        isPaid: true,
      ),
      OrderModel(
        id: 'order2',
        userId: 'user1',
        chefId: 'chef2',
        chefName: 'مطعم أم محمد',
        chefImageUrl: 'https://example.com/chef2.jpg',
        items: [
          OrderItem(
            id: 'item3',
            name: 'مندي دجاج',
            quantity: 1,
            price: 30.0,
          ),
        ],
        subtotal: 30.0,
        deliveryFee: 10.0,
        total: 40.0,
        status: OrderStatus.delivered,
        orderDate: DateTime.now().subtract(const Duration(days: 2)),
        deliveryDate: DateTime.now().subtract(const Duration(days: 1)),
        deliveryAddress: '456 شارع الملك فهد، جدة 23456',
        paymentMethod: 'نقداً عند الاستلام',
        isPaid: true,
      ),
    ]);
  }

  Future<void> addOrder(OrderModel order) async {
    final currentOrders = state.value ?? [];
    state = AsyncValue.data([...currentOrders, order]);
  }

  Future<void> updateOrder(OrderModel updatedOrder) async {
    final currentOrders = state.value ?? [];
    final index =
        currentOrders.indexWhere((order) => order.id == updatedOrder.id);
    if (index != -1) {
      final updatedOrders = List<OrderModel>.from(currentOrders);
      updatedOrders[index] = updatedOrder;
      state = AsyncValue.data(updatedOrders);
    }
  }

  Future<void> cancelOrder(String orderId) async {
    final currentOrders = state.value ?? [];
    final index = currentOrders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      final updatedOrder = currentOrders[index]
          .copyWith(status: OrderStatus.cancelled, rejectionReason: 'تم الإلغاء من قبل العميل');
      final updatedOrders = List<OrderModel>.from(currentOrders);
      updatedOrders[index] = updatedOrder;
      state = AsyncValue.data(updatedOrders);
    }
  }
}

final mockOrderProvider = StateNotifierProvider<MockOrderNotifier, AsyncValue<List<OrderModel>>>(
  (ref) => MockOrderNotifier(),
);
