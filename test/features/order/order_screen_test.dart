import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wagbty/features/order/order_screen.dart';
import 'package:wagbty/models/order_model.dart';
import 'package:wagbty/providers/order_provider.dart';
import 'package:wagbty/widgets/main_scaffold.dart';

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
  id: 'ORDER12345678',
  userId: 'user123',
  chefId: 'chef456',
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
  deliveryAddress: '123 Test St, Test City',
  paymentMethod: 'Cash on Delivery',
  subtotal: 100.0,
  deliveryFee: 10.0,
  total: 110.0,
);

// Mock OrderNotifier for testing
class MockOrderNotifier extends OrderNotifier {
  MockOrderNotifier() : super(MockSharedPreferences()) {
    // Initialize with empty list
    state = const AsyncValue.data([]);
  }
  
  // Helper method to set state for testing
  void setTestState(AsyncValue<List<OrderModel>> newState) {
    state = newState;
  }
  
  @override
  Future<void> loadOrders() async {
    // Keep the current state if it's already set
    if (state.hasValue && state.value != null && state.value!.isNotEmpty) {
      return;
    }
    state = const AsyncValue.data([]);
  }
  
  @override
  Future<void> cancelOrder(String orderId) async {
    final currentOrders = state.value ?? [];
    final index = currentOrders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final updatedOrder = currentOrders[index].copyWith(
        status: OrderStatus.cancelled,
        rejectionReason: 'تم الإلغاء من قبل العميل',
      );
      final updatedOrders = List<OrderModel>.from(currentOrders);
      updatedOrders[index] = updatedOrder;
      state = AsyncValue.data(updatedOrders);
    }
  }
}

// Provider for testing
final orderProvider = StateNotifierProvider<OrderNotifier, AsyncValue<List<OrderModel>>>(
  (ref) => throw UnimplementedError('orderProvider should be overridden in tests'),
);

void main() {
  testWidgets('OrderScreen shows loading indicator when loading',
      (WidgetTester tester) async {
    // Create a mock notifier with loading state
    final mockNotifier = MockOrderNotifier()
      ..setTestState(const AsyncValue.loading());

    // Build our app and trigger a frame
    await tester.pumpWidget(
      MaterialApp(
        home: ProviderScope(
          overrides: [
            orderProvider.overrideWith((ref) => mockNotifier),
          ],
          child: const OrderScreen(),
        ),
      ),
    );

    // Verify loading indicator is shown
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('OrderScreen shows error message when error occurs',
      (WidgetTester tester) async {
    // Create a mock notifier with error state
    final mockNotifier = MockOrderNotifier()
      ..setTestState(AsyncValue.error('Test error', StackTrace.current));

    await tester.pumpWidget(
      MaterialApp(
        home: ProviderScope(
          overrides: [
            orderProvider.overrideWith((ref) => mockNotifier),
          ],
          child: const OrderScreen(),
        ),
      ),
    );

    // Verify error message is shown
    expect(find.text('حدث خطأ في تحميل الطلبات'), findsOneWidget);
  });

  testWidgets('OrderScreen renders without errors', (WidgetTester tester) async {
    final mockNotifier = MockOrderNotifier();

    await tester.pumpWidget(
      MaterialApp(
        home: ProviderScope(
          overrides: [
            orderProvider.overrideWith((ref) => mockNotifier),
          ],
          child: const OrderScreen(),
        ),
      ),
    );

    // Verify the widget tree doesn't throw any errors
    expect(find.byType(OrderScreen), findsOneWidget);
  });
  
  testWidgets('OrderScreen shows empty state', (WidgetTester tester) async {
    // Create a mock notifier that returns an empty list
    final mockNotifier = MockOrderNotifier()..setTestState(const AsyncValue.data([]));

    await tester.pumpWidget(
      MaterialApp(
        home: ProviderScope(
          overrides: [
            orderProvider.overrideWith((ref) => mockNotifier),
          ],
          child: const OrderScreen(),
        ),
      ),
    );

    // Verify empty state message is shown
    expect(find.text('لا توجد طلبات سابقة'), findsOneWidget);
  });

  testWidgets('OrderScreen shows loading state', (WidgetTester tester) async {
    // Create a mock notifier that returns loading state
    final mockNotifier = MockOrderNotifier()
      ..setTestState(const AsyncValue.loading());
    
    await tester.pumpWidget(
      MaterialApp(
        home: ProviderScope(
          overrides: [
            orderProvider.overrideWith((ref) => mockNotifier),
          ],
          child: const OrderScreen(),
        ),
      ),
    );
    
    // Verify loading indicator is shown
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
  
  testWidgets('OrderScreen shows error state', (WidgetTester tester) async {
    // Create a mock notifier that returns an error
    final mockNotifier = MockOrderNotifier()
      ..setTestState(AsyncValue.error('Test error', StackTrace.current));
    
    await tester.pumpWidget(
      MaterialApp(
        home: ProviderScope(
          overrides: [
            orderProvider.overrideWith((ref) => mockNotifier),
          ],
          child: const OrderScreen(),
        ),
      ),
    );
    
    // Verify error message is shown
    expect(find.text('حدث خطأ في تحميل الطلبات'), findsOneWidget);
  });
  
  testWidgets('OrderScreen shows order list', (WidgetTester tester) async {
    final testOrder = OrderModel(
      id: 'ORDER12345678',
      userId: 'user123',
      chefId: 'chef456',
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
      deliveryAddress: '123 Test St, Test City',
      paymentMethod: 'Cash on Delivery',
      subtotal: 100.0,
      deliveryFee: 10.0,
      total: 110.0,
    );

    final mockNotifier = MockOrderNotifier()..setTestState(AsyncValue.data([testOrder]));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          orderProvider.overrideWith((ref) => mockNotifier),
        ],
        child: MaterialApp(
          home: const OrderScreen(),
          builder: (context, child) => Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(MainScaffold), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('طلباتي'), findsOneWidget);
    expect(find.text('طلب #${testOrder.id.substring(0, 8).toUpperCase()}'), findsOneWidget);
    expect(find.text(testOrder.chefName), findsOneWidget);
    expect(find.textContaining('Pending'), findsOneWidget);
  });
}
