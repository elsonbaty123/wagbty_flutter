import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wagbty/features/order/order_screen.dart';
import 'package:wagbty/models/order_model.dart';
import 'package:wagbty/providers/order_provider.dart';

// Mock SharedPreferences for testing
class MockSharedPreferences extends Mock implements SharedPreferences {
  final Map<String, dynamic> _storage = {};

  @override
  List<String>? getStringList(String key) => _storage[key] as List<String>?;

  @override
  Future<bool> setStringList(String key, List<String> value) async {
    _storage[key] = List<String>.from(value);
    return true;
  }
}

// Create a test order
final testOrder = OrderModel(
  id: 'order1234',
  userId: 'user123',
  chefId: 'chef123',
  chefName: 'Test Chef',
  items: [
    OrderItem(
      id: 'item1',
      name: 'Test Dish',
      quantity: 2,
      price: 50.0,
      imageUrl: '',
    ),
  ],
  status: OrderStatus.pending,
  orderDate: DateTime.now(),
  deliveryAddress: '123 Test St',
  paymentMethod: 'Cash on Delivery',
  subtotal: 100.0,
  deliveryFee: 10.0,
  total: 110.0,
);

// Mock OrderNotifier for testing
class MockOrderNotifier extends OrderNotifier {
  MockOrderNotifier() : super(MockSharedPreferences()) {
    state = const AsyncValue.data([]);
  }
  
  // Helper method to set state for testing
  void setTestState(AsyncValue<List<OrderModel>> newState) {
    state = newState;
  }
  
  @override
  Future<void> loadOrders() async {
    if (state.hasValue && state.value != null && state.value!.isNotEmpty) {
      return;
    }
    state = AsyncValue.data([testOrder]);
  }
}


void main() {
  testWidgets('OrderScreen shows order list', (tester) async {
    final mockNotifier = MockOrderNotifier();
    mockNotifier.setTestState(AsyncValue.data([testOrder]));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          orderProvider.overrideWith((ref) => mockNotifier),
        ],
        child: MaterialApp(
          home: Builder(
            builder: (context) => Directionality(
              textDirection: TextDirection.rtl,
              child: OrderScreen(),
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    
    final container = ProviderContainer(
      overrides: [
        orderProvider.overrideWith((ref) => mockNotifier),
      ],
    );
    final currentState = container.read(orderProvider);
    
    expect(currentState.hasValue, true);
    expect(currentState.value!.length, 1);
    expect(currentState.value!.first.id, testOrder.id);
    
    await tester.pumpAndSettle();
    final expectedOrderId = testOrder.id.substring(0, 8).toUpperCase();
    final expectedArabicPrefix = 'طلب #';
    final expectedFullOrderIdText = '$expectedArabicPrefix$expectedOrderId';

    expect(find.text(expectedFullOrderIdText), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('حدث خطأ في تحميل الطلبات'), findsNothing);
    expect(find.text('لا توجد طلبات سابقة'), findsNothing);
  });
}
