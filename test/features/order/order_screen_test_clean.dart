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
    // Print test start
    print('\n=== STARTING TEST ===');
    
    // Create a mock notifier
    final mockNotifier = MockOrderNotifier();
    
    // Set up the initial state with our test order
    mockNotifier.setTestState(AsyncValue.data([testOrder]));
    
    // Print test order details
    print('Test order ID: ${testOrder.id}');
    print('Expected order ID in UI: ${testOrder.id.substring(0, 8).toUpperCase()}');

    // Build our app with ProviderScope and MaterialApp
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          orderProvider.overrideWith((ref) => mockNotifier),
        ],
        child: MaterialApp(
          home: Builder(
            builder: (context) => Directionality(
              textDirection: TextDirection.rtl, // Ensure RTL for Arabic text
              child: OrderScreen(),
            ),
          ),
        ),
      ),
    );
    
    // First pump to build the widget
    await tester.pump();
    
    // Print the current state of the provider
    final container = ProviderContainer(
      overrides: [
        orderProvider.overrideWith((ref) => mockNotifier),
      ],
    );
    final currentState = container.read(orderProvider);
    print('\n=== PROVIDER STATE ===');
    print('Has value: ${currentState.hasValue}');
    if (currentState.hasValue) {
      print('Number of orders: ${currentState.value!.length}');
      for (var i = 0; i < currentState.value!.length; i++) {
        final order = currentState.value![i];
        print('Order $i:');
        print('  - ID: ${order.id}');
        print('  - Status: ${order.status}');
        print('  - Date: ${order.orderDate}');
      }
    } else if (currentState.hasError) {
      print('Error: ${currentState.error}');
      print('Stack: ${currentState.stackTrace}');
    }

    // Let the async operations complete
    print('\n=== PUMPING AND SETTLING ===');
    await tester.pumpAndSettle();
    
    // Print the widget tree for debugging
    print('\n=== WIDGET TREE ===');
    debugDumpApp();
    
    // Print the widget tree structure with more details
    print('\n=== DETAILED WIDGET TREE ===');
    void printTree(Element element, {int depth = 0}) {
      final widget = element.widget;
      final indent = '  ' * depth;
      final keyStr = widget.key != null ? ' (key: ${widget.key})' : '';
      
      // Print widget type and key
      print('$indent${widget.runtimeType}$keyStr');
      
      // Print text content if this is a Text widget
      if (widget is Text) {
        final text = widget.data ?? widget.textSpan?.toPlainText() ?? '';
        print('$indent  Text: "$text"');
        print('$indent  Style: ${widget.style}');
      }
      
      // Print Card properties if this is a Card
      if (widget is Card) {
        print('$indent  Elevation: ${widget.elevation}');
        print('$indent  Margin: ${widget.margin}');
        print('$indent  Child: ${widget.child.runtimeType}');
      }
      
      // Print MainScaffold if found
      if (widget.runtimeType.toString() == 'MainScaffold') {
        print('$indent  MainScaffold');
        try {
          final currentIndex = (widget as dynamic).currentIndex;
          print('$indent  Current Index: $currentIndex');
        } catch (e) {
          print('$indent  Could not access currentIndex: $e');
        }
      }
      
      // Print ConsumerWidget if found
      if (widget is ConsumerWidget) {
        print('$indent  ConsumerWidget: ${widget.runtimeType}');
      }
      
      // Print ListView if found
      if (widget is ListView) {
        print('$indent  ListView (has builder: ${widget.childrenDelegate != null})');
      }
      
      // Print ProviderScope if found
      if (widget is ProviderScope) {
        print('$indent  ProviderScope with ${widget.overrides?.length ?? 0} overrides');
      }
      
      // Print MaterialApp if found
      if (widget is MaterialApp) {
        print('$indent  MaterialApp (${widget.title})');
      }
      
      // Recursively print children
      element.visitChildren((child) => printTree(child, depth: depth + 1));
    }
    
    // Print the widget tree starting from MaterialApp
    final materialAppElement = tester.element(find.byType(MaterialApp));
    printTree(materialAppElement);
    
    // Print all text widgets in the tree with their full details
    print('\n=== ALL TEXT WIDGETS WITH DETAILS ===');
    final allTexts = find.byType(Text).evaluate();
    for (final element in allTexts) {
      if (element.widget is Text) {
        final textWidget = element.widget as Text;
        final text = textWidget.data ?? textWidget.textSpan?.toPlainText() ?? '';
        final style = textWidget.style;
        final styleStr = style != null ? 
          ' (color: ${style.color}, font size: ${style.fontSize}, weight: ${style.fontWeight})' : '';
        print('Text: "$text"$styleStr');
        

      }
    }
    
    // Print all Card widgets and their contents
    print('\n=== ALL CARD WIDGETS WITH CONTENTS ===');
    final cardWidgets = find.byType(Card).evaluate();
    for (final element in cardWidgets) {
      final card = element.widget as Card;
      print('Card: ${card.runtimeType}');
      
      // Print all text within this card
      final cardTexts = find.descendant(
        of: find.byWidget(card),
        matching: find.byType(Text),
      ).evaluate();
      
      if (cardTexts.isNotEmpty) {
        for (final textElement in cardTexts) {
          if (textElement.widget is Text) {
            final textWidget = textElement.widget as Text;
            final text = textWidget.data ?? textWidget.textSpan?.toPlainText() ?? '';
            print('  Text: "$text"');
          }
        }
      } else {
        print('  No text found in card');
      }
    }
    
    // Print all widgets that might contain order information
    print('\n=== WIDGETS THAT MIGHT CONTAIN ORDER INFO ===');
    final allWidgets = find.byType(Widget).evaluate();
    for (final element in allWidgets) {
      final widget = element.widget;
      if (widget is Text) {
        final text = widget.data ?? widget.textSpan?.toPlainText() ?? '';
        if (text.contains('طلب') || text.contains('ORDER') || text.contains('order')) {
          print('Found potential order text: "$text" (${widget.runtimeType})');
        }
      }
    }
    
    // Print all text widgets in the tree
    print('\n=== ALL TEXT WIDGETS ===');
    final textWidgets = find.byType(Text).evaluate();
    for (var i = 0; i < textWidgets.length; i++) {
      final element = textWidgets.elementAt(i);
      final textWidget = element.widget as Text;
      final text = textWidget.data ?? textWidget.textSpan?.toPlainText() ?? '';
      final style = textWidget.style;
      final fontSize = style?.fontSize;
      final fontWeight = style?.fontWeight;
      print('Text $i: "$text" (size: $fontSize, weight: $fontWeight)');
    }
    
    // Try to find the order card using multiple strategies
    final cardFinder = find.byType(Card);
    final containerFinder = find.byType(Container);
    final columnFinder = find.byType(Column);
    
    print('\n=== WIDGET COUNTS ===');
    print('Found ${cardFinder.evaluate().length} Card widgets');
    print('Found ${containerFinder.evaluate().length} Container widgets');
    print('Found ${columnFinder.evaluate().length} Column widgets');
    

    
    // Try to find the order ID using multiple approaches
    final expectedOrderId = testOrder.id.substring(0, 8).toUpperCase();
    final expectedPartialId = testOrder.id.substring(0, 8).toUpperCase();
    final expectedArabicPrefix = 'طلب #';
    final expectedFullOrderIdText = '$expectedArabicPrefix$expectedPartialId';
    
    print('\n=== SEARCHING FOR ORDER ID ===');
    print('Looking for: "$expectedFullOrderIdText" or any part of it');
    
    // Print all text in the widget tree for debugging
    print('\n=== ALL TEXT IN WIDGET TREE ===');
    final allText = find.byType(Text);
    bool foundMatchingText = false;
    
    for (var element in allText.evaluate()) {
      final widget = element.widget as Text;
      final text = widget.data ?? widget.textSpan?.toPlainText() ?? '';
      print('Found text: "$text"');
      
      // Check if this text matches our expected format
      if (text.contains(expectedArabicPrefix) || 
          text.contains(expectedOrderId) || 
          text.contains(expectedPartialId)) {
        print('  ^^^ POTENTIAL MATCH ^^^');
        foundMatchingText = true;
      }
    }
    
    if (!foundMatchingText) {
      print('\n=== WARNING: No text matching order ID pattern found in the widget tree ===');
      print('This suggests the OrderScreen is not rendering the order card as expected.');
      print('Possible issues:');
      print('1. The order data might not be available in the provider');
      print('2. The _buildOrderCard method might not be called');
      print('3. The widget tree structure might be different than expected');
      
      // Print the widget tree structure to help diagnose
      print('\n=== WIDGET TREE STRUCTURE ===');
      void printWidgetTree(Element element, {int depth = 0}) {
        final widget = element.widget;
        final indent = '  ' * depth;
        
        // Print widget type and key
        print('$indent${widget.runtimeType}');
        
        // Print text content if this is a Text widget
        if (widget is Text) {
          final text = widget.data ?? widget.textSpan?.toPlainText() ?? '';
          print('$indent  Text: "$text"');
        }
        
        // Recursively print children
        element.visitChildren((child) => printWidgetTree(child, depth: depth + 1));
      }
      
      final rootElement = tester.element(find.byType(MaterialApp));
      printWidgetTree(rootElement);
    }
    
    // Try different finders
    final finders = [
      find.text(expectedFullOrderIdText),  // Exact match for the order ID text
      find.textContaining(expectedArabicPrefix),
      find.textContaining(expectedOrderId),
      find.textContaining(expectedPartialId),
      find.byWidgetPredicate(
        (widget) => widget is Text && 
          (widget.data ?? widget.textSpan?.toPlainText() ?? '').contains(expectedOrderId),
        description: 'Text widget containing $expectedOrderId',
      ),
      find.byWidgetPredicate(
        (widget) => widget is Text && 
          (widget.data ?? widget.textSpan?.toPlainText() ?? '').contains(expectedPartialId),
        description: 'Text widget containing $expectedPartialId',
      ),
      find.byWidgetPredicate(
        (widget) => widget is Text && 
          (widget.data ?? widget.textSpan?.toPlainText() ?? '').contains(expectedArabicPrefix),
        description: 'Text widget containing $expectedArabicPrefix',
      ),
    ];
    
    // Print finder results
    bool foundMatch = false;
    print('\n=== FINDER RESULTS ===');
    for (var i = 0; i < finders.length; i++) {
      final finder = finders[i];
      final matches = finder.evaluate();
      print('Finder $i (${finder.description}): ${matches.length} matches');
      
      for (var element in matches) {
        final widget = element.widget;
        if (widget is Text) {
          final text = widget.data ?? widget.textSpan?.toPlainText() ?? '';
          print('  - Match: "$text" (${widget.runtimeType})');
          foundMatch = true;
        } else {
          print('  - Match: ${widget.runtimeType}');
        }
      }
    }
    
    // Verify we found the order ID
    expect(
      foundMatch,
      true,
      reason: 'Expected to find order ID "$expectedOrderId" or "$expectedPartialId" in the widget tree',
    );
  });
}
