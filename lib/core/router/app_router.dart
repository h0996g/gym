import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/app_scaffold.dart';
import '../../features/dashboard/dashboard_page.dart';
import '../../features/members/members_page.dart';
import '../../features/subscriptions/subscriptions_page.dart';
import '../../features/groups/groups_page.dart';
import '../../features/products/products_page.dart';
import '../../features/sales/sales_page.dart';
import '../../features/statistics/statistics_page.dart';
import 'app_routes.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.dashboard,
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppScaffold(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.dashboard,
          name: 'dashboard',
          pageBuilder: (context, state) =>
              _fadePage(state, const DashboardPage()),
        ),
        GoRoute(
          path: AppRoutes.members,
          name: 'members',
          pageBuilder: (context, state) =>
              _fadePage(state, const MembersPage()),
        ),
        GoRoute(
          path: AppRoutes.subscriptions,
          name: 'subscriptions',
          pageBuilder: (context, state) =>
              _fadePage(state, const SubscriptionsPage()),
        ),
        GoRoute(
          path: AppRoutes.groups,
          name: 'groups',
          pageBuilder: (context, state) =>
              _fadePage(state, const GroupsPage()),
        ),
        GoRoute(
          path: AppRoutes.products,
          name: 'products',
          pageBuilder: (context, state) =>
              _fadePage(state, const ProductsPage()),
        ),
        GoRoute(
          path: AppRoutes.sales,
          name: 'sales',
          pageBuilder: (context, state) =>
              _fadePage(state, const SalesPage()),
        ),
        GoRoute(
          path: AppRoutes.statistics,
          name: 'statistics',
          pageBuilder: (context, state) =>
              _fadePage(state, const StatisticsPage()),
        ),
      ],
    ),
  ],
);

CustomTransitionPage<void> _fadePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 220),
    reverseTransitionDuration: const Duration(milliseconds: 180),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final fade = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      );
      final slide = Tween<Offset>(
        begin: const Offset(0.015, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      ));
      return FadeTransition(
        opacity: fade,
        child: SlideTransition(position: slide, child: child),
      );
    },
  );
}
