import 'package:go_router/go_router.dart';
import '../features/home/home_screen.dart';
import '../features/chefs/chefs_list_screen.dart';
import '../features/chefs/chef_details_screen.dart';
import '../features/dishes/dishes_list_screen.dart';
import '../features/dishes/dish_details_screen.dart';
import '../features/favorites/favorites_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/community/community_screen.dart';
import '../features/order/order_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/signup_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/chefs',
      builder: (context, state) => const ChefsListScreen(),
      routes: [
        GoRoute(
          path: ':id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return ChefDetailsScreen(id: id);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/dishes',
      builder: (context, state) => const DishesListScreen(),
      routes: [
        GoRoute(
          path: ':id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return DishDetailsScreen(id: id);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/favorites',
      builder: (context, state) => const FavoritesScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/community',
      builder: (context, state) => const CommunityScreen(),
    ),
    GoRoute(
      path: '/order',
      builder: (context, state) => const OrderScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
  ],
);
