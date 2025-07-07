import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:wagbty/models/order_model.dart';
import 'package:wagbty/providers/order_provider.dart';
import 'package:wagbty/widgets/main_scaffold.dart';

class OrderScreen extends ConsumerWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(orderProvider);

    return MainScaffold(
      currentIndex: 4, // Assuming 4 is the index for orders in the bottom nav
      appBar: AppBar(
        title: const Text('طلباتي'),
        centerTitle: true,
      ),
      body: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 60),
              const SizedBox(height: 16),
              const Text('حدث خطأ في تحميل الطلبات'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.refresh(orderProvider),
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
        data: (orders) {
          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary.withAlpha((255 * 0.5).round()),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد طلبات سابقة',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'عند قيامك بالطلب الأول، ستظهر تفاصيله هنا',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go('/'),
                    child: const Text('تصفح المطاعم'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              // Invalidate the provider to trigger a refresh
              ref.invalidate(orderProvider);
              // Wait for the next frame to ensure the provider is rebuilt
              await Future.delayed(Duration.zero);
              // Wait for the provider to finish loading
              final notifier = ref.read(orderProvider.notifier);
              await notifier.loadOrders();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return _buildOrderCard(context, order, ref);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dateFormat = DateFormat('dd/MM/yyyy - hh:mm a');
    final orderDate = dateFormat.format(order.orderDate);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outline.withAlpha(25),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to order details
          context.push('/orders/${order.id}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order header
              Row(
                children: [
                  // Status indicator
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: order.status.statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Order ID and date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'طلب #${order.id.substring(0, 8).toUpperCase()}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          orderDate,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodySmall?.color?.withAlpha((255 * 0.7).round()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: order.status.statusColor.withAlpha((255 * 0.1).round()),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: order.status.statusColor.withAlpha((255 * 0.3).round()),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      order.status.displayName,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: order.status.statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Chef info
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: colorScheme.primary.withAlpha((255 * 0.1).round()),
                    backgroundImage: order.chefImageUrl != null
                        ? NetworkImage(order.chefImageUrl!)
                        : null,
                    child: order.chefImageUrl == null
                        ? Icon(
                            Icons.restaurant,
                            size: 20,
                            color: colorScheme.primary,
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.chefName,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Item count and total
                        Text(
                          '${order.items.length} ${order.items.length == 1 ? 'صنف' : 'أصناف'} • ${order.total.toStringAsFixed(2)} ر.س',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodySmall?.color?.withAlpha(179), // 0.7 * 255 = 178.5
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Action buttons
              if (order.status == OrderStatus.pending ||
                  order.status == OrderStatus.confirmed)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Cancel order
                          _showCancelDialog(context, ref, order);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(
                            color: colorScheme.error.withAlpha(128), // 0.5 * 255 = 127.5
                          ),
                        ),
                        child: Text(
                          'إلغاء الطلب',
                          style: TextStyle(color: colorScheme.error),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Track order
                          context.push('/orders/${order.id}/track');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('تتبع الطلب'),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context, WidgetRef ref, OrderModel order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إلغاء الطلب'),
        content: const Text('هل أنت متأكد من رغبتك في إلغاء هذا الطلب؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('تراجع'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              // Cancel the order
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              try {
                await ref.read(orderProvider.notifier).cancelOrder(order.id);
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('تم إلغاء الطلب بنجاح')),
                );
              } catch (e) {
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text('حدث خطأ أثناء إلغاء الطلب'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('نعم، إلغاء الطلب'),
          ),
        ],
      ),
    );
  }
}
