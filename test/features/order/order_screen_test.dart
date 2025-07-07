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
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => MainScaffold(
              currentIndex: 0,
              body: Container(),
              appBar: AppBar(title: const Text('Test AppBar')),
            ),
          ),
        ),
      ),
    );

    // Verify MainScaffold is found
    expect(find.byType(MainScaffold), findsOneWidget);
  });

  testWidgets('OrderScreen renders without errors', (WidgetTester tester) async {
    // Create a minimal test
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => const OrderScreen(),
          ),
        ),
      ),
    );
    
    // Verify the widget tree doesn't throw any errors
    expect(find.byType(OrderScreen), findsOneWidget);
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
    print('\n=== STARTING TEST: OrderScreen shows order list ===');
    
    // Create a test order with a shorter ID for easier testing
    final testOrder = OrderModel(
      id: 'ORDER123', // Shorter ID for testing
      userId: 'user123',
      chefId: 'chef456',
      chefName: 'Test Chef',
      chefImageUrl: 'https://example.com/chef.jpg',
      items: [
        OrderItem(
          id: 'item1',
          name: 'Test Dish',
          quantity: 2,
          price: 50.0,
          imageUrl: 'https://example.com/dish.jpg',
        ),
      ],
      status: OrderStatus.pending,
      orderDate: DateTime(2023, 1, 1, 12, 0), // Fixed date for consistent testing
      deliveryAddress: '123 Test St, Test City',
      paymentMethod: 'Cash on Delivery',
      subtotal: 100.0,
      deliveryFee: 10.0,
      total: 110.0,
    );
    
    // Print test order details
    print('Test order created with ID: ${testOrder.id}');
    
    // Create a mock notifier with test order
    final mockNotifier = MockOrderNotifier()
      ..setTestState(AsyncValue.data([testOrder]));
    
    // Print provider state before building the widget
    print('\n=== PROVIDER STATE BEFORE BUILD ===');
    print('Has value: ${mockNotifier.state.hasValue}');
    if (mockNotifier.state.hasValue) {
      print('Number of orders: ${mockNotifier.state.value?.length ?? 0}');
      if (mockNotifier.state.value != null) {
        for (var order in mockNotifier.state.value!) {
          print('Order ID: ${order.id}, Status: ${order.status}');
        }
      }
    }
    
    // Build our app with the mock notifier and proper provider overrides
    print('\n=== BUILDING WIDGET TREE ===');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          orderProvider.overrideWith((ref) => mockNotifier),
        ],
        child: MaterialApp(
          home: const OrderScreen(),
          // Ensure proper text direction for RTL
          builder: (context, child) => Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          ),
        ),
      ),
    );
    
    // Print widget tree after initial build
    print('\n=== WIDGET TREE AFTER INITIAL BUILD ===');
    debugDumpApp();
    
    // Pump again to ensure all async operations complete
    print('\n=== PUMPING TO SETTLE ASYNC OPERATIONS ===');
    await tester.pumpAndSettle();
    // Print widget tree after settling
    print('\n=== WIDGET TREE AFTER SETTLING ===');

  // Verify MainScaffold is rendered
  print('\n=== VERIFYING MAIN SCAFFOLD ===');
  final mainScaffoldFinder = find.byType(MainScaffold);
  expect(
    mainScaffoldFinder,
    findsOneWidget,
    reason: 'MainScaffold should be present',
  );
  
  // Get the MainScaffold widget to inspect its properties
  final mainScaffoldElement = tester.element(mainScaffoldFinder);
  print('MainScaffold found with type: ${mainScaffoldElement.widget.runtimeType}');
  
  // Verify the app bar title
  final appBarFinder = find.byType(AppBar);
  expect(
    appBarFinder,
    findsOneWidget,
    reason: 'AppBar should be present',
  );
  
  // Print the widget tree for debugging
  print('\n=== WIDGET TREE ===');
  debugDumpApp();
  
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
print('\n=== STARTING TEST: OrderScreen shows order list ===');
  
// Create a test order with a shorter ID for easier testing
final testOrder = OrderModel(
  id: 'ORDER123', // Shorter ID for testing
  userId: 'user123',
  chefId: 'chef456',
  chefName: 'Test Chef',
  chefImageUrl: 'https://example.com/chef.jpg',
  items: [
    OrderItem(
      id: 'item1',
      name: 'Test Dish',
      quantity: 2,
      price: 50.0,
      imageUrl: 'https://example.com/dish.jpg',
    ),
  ],
  status: OrderStatus.pending,
  orderDate: DateTime(2023, 1, 1, 12, 0), // Fixed date for consistent testing
  deliveryAddress: '123 Test St, Test City',
  paymentMethod: 'Cash on Delivery',
  subtotal: 100.0,
  deliveryFee: 10.0,
  total: 110.0,
);
  
// Print test order details
print('Test order created with ID: ${testOrder.id}');
  
// Create a mock notifier with test order
final mockNotifier = MockOrderNotifier()
  ..setTestState(AsyncValue.data([testOrder]));
  
// Print provider state before building the widget
print('\n=== PROVIDER STATE BEFORE BUILD ===');
print('Has value: ${mockNotifier.state.hasValue}');
if (mockNotifier.state.hasValue) {
  print('Number of orders: ${mockNotifier.state.value?.length ?? 0}');
  if (mockNotifier.state.value != null) {
    for (var order in mockNotifier.state.value!) {
      print('Order ID: ${order.id}, Status: ${order.status}');
    }
  }
}
  
// Build our app with the mock notifier and proper provider overrides
print('\n=== BUILDING WIDGET TREE ===');
await tester.pumpWidget(
  ProviderScope(
    overrides: [
      orderProvider.overrideWith((ref) => mockNotifier),
    ],
    child: MaterialApp(
      home: const OrderScreen(),
      // Ensure proper text direction for RTL
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child!,
      ),
    ),
  ),
);
  
// Print widget tree after initial build
print('\n=== WIDGET TREE AFTER INITIAL BUILD ===');
debugDumpApp();
  
// Pump again to ensure all async operations complete
print('\n=== PUMPING TO SETTLE ASYNC OPERATIONS ===');
await tester.pumpAndSettle();
// Print widget tree after settling
print('\n=== WIDGET TREE AFTER SETTLING ===');

// The order ID is displayed as 'طلب #' followed by the first 8 characters of the order ID in uppercase
final displayedOrderId = 'طلب #${testOrder.id.substring(0, 8).toUpperCase()}';
print('\n=== LOOKING FOR ORDER ID ===');
print('Expected order ID text: "$displayedOrderId"');
  
// Print all text widgets with their properties and hierarchy
print('\n=== ALL TEXT WIDGETS WITH HIERARCHY ===');
final allTexts = find.byType(Text).evaluate();
for (var i = 0; i < allTexts.length; i++) {
  final element = allTexts.elementAt(i);
  final textWidget = element.widget as Text;
  
  // Get the widget's position in the tree
  final List<String> widgetPath = [];
  element.visitAncestorElements((parent) {
    widgetPath.add(parent.widget.runtimeType.toString());
    return true; // Continue visiting ancestors
  });
  
  // Print text with its widget hierarchy
  if (textWidget.data != null) {
    print('Text $i: "${textWidget.data}"');
    print('  - Type: ${textWidget.runtimeType}');
    print('  - Style: ${textWidget.style}');
    print('  - TextAlign: ${textWidget.textAlign}');
    print('  - TextDirection: ${textWidget.textDirection}');
    print('  - Locale: ${textWidget.locale}');
    print('  - MaxLines: ${textWidget.maxLines}');
    print('  - Overflow: ${textWidget.overflow}');
    print('  - Widget hierarchy (bottom to top):');
    for (var widgetType in widgetPath.take(5)) { // Limit to 5 levels to avoid too much output
      print('    - $widgetType');
    }
  }
}
  
// Try to find the exact text that's displayed in the UI
final orderIdFinder = find.text(displayedOrderId);
  
// Print the widget tree for the OrderScreen
print('\n=== ORDER SCREEN WIDGET TREE ===');
final orderScreenFinder = find.byType(OrderScreen);
if (orderScreenFinder.evaluate().isNotEmpty) {
  final orderScreenElement = orderScreenFinder.evaluate().first;
  print('OrderScreen found with ${orderScreenElement.children.length} children');
  
  // Print all Card widgets in the OrderScreen
  final cardFinder = find.descendant(
    of: orderScreenFinder,
    matching: find.byType(Card),
  );
  
  final cards = cardFinder.evaluate();
  print('Found ${cards.length} Card widgets in OrderScreen');
  
  for (var i = 0; i < cards.length; i++) {
    final card = cards.elementAt(i);
    print('\nCard $i:');
    
    // Print all text in this card
    final textFinder = find.descendant(
      of: find.byWidgetPredicate((widget) => widget == card.widget),
      matching: find.byType(Text),
    );
    
    final textWidgets = textFinder.evaluate();
    for (var j = 0; j < textWidgets.length; j++) {
      final textElement = textWidgets.elementAt(j);
      final textWidget = textElement.widget as Text;
      final text = textWidget.data ?? textWidget.textSpan?.toPlainText() ?? 'N/A';
      print('  Text $j: "$text"');
    }
  }
} else {
  print('OrderScreen not found in widget tree!');
}
  
// Verify the order ID is displayed
expect(
  orderIdFinder,
  findsOneWidget,
      }
    }
    
    // Try to find the Card that should contain our order
    final cards = find.byType(Card).evaluate();
    print('\n=== FOUND ${cards.length} CARDS ===');
    for (var i = 0; i < cards.length; i++) {
      final card = cards.elementAt(i);
      print('Card $i:');
      
      // Print all text in this card with full widget hierarchy
      print('  Full widget tree for Card $i:');
      
      void printElementTree(Element element, {int level = 0}) {
        final indent = '  ' * (level + 1);
        final widget = element.widget;
        
        // Print widget type and key
        print('$indent- ${widget.runtimeType}');
        
        // Print text content if this is a Text widget
        if (widget is Text) {
          final text = widget.data ?? widget.textSpan?.toPlainText() ?? 'N/A';
          print('$indent  Text: "$text"');
          
          // Check if this is our target text
          if (text.contains('ORDER123')) {
            print('$indent  !!! FOUND TARGET TEXT !!!');
          }
        }
        
        // Print properties for specific widget types
        if (widget is Card) {
          print('$indent  Elevation: ${widget.elevation}');
        }
        
        // Recursively print children
        element.visitChildren((child) => printElementTree(child, level: level + 1));
      }
      
      printElementTree(card);
      
      // Also collect all text for easier searching
      final allText = StringBuffer();
      void collectAllText(Element element) {
        final widget = element.widget;
        if (widget is Text) {
          final text = widget.data ?? widget.textSpan?.toPlainText() ?? '';
          allText.writeln(text);
        }
        element.visitChildren(collectAllText);
      }
      collectAllText(card);
      
      print('  All text in card:');
      print('  -----------------');
      print('  ${allText.toString().replaceAll('\n', '\n  ')}');
      print('  -----------------');
    }
    
  reason: 'Order ID "$displayedOrderId" should be displayed in the card',
);
  
print('\n=== TEST COMPLETED SUCCESSFULLY ===');
});
}
