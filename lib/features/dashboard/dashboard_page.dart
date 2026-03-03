import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import 'cubit/dashboard_cubit.dart';
import 'cubit/dashboard_state.dart';
import 'widgets/quick_action_button.dart';
import 'widgets/recent_activity_feed.dart';
import 'widgets/stat_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardCubit()..loadDashboard(),
      child: const _DashboardContent(),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.contentPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _WelcomeHeader(),
              const SizedBox(height: 28),
              switch (state) {
                DashboardLoading() || DashboardInitial() => const _StatsRowSkeleton(),
                DashboardLoaded() => _StatsRow(state: state),
                DashboardError(:final message) => _ErrorCard(message: message),
              },
              const SizedBox(height: 28),
              const _QuickActionsSection(),
              const SizedBox(height: 28),
              if (state is DashboardLoaded)
                RecentActivityFeed(items: state.recentActivity),
            ],
          ),
        );
      },
    );
  }
}

// ── Welcome Header ────────────────────────────────────────────────────────────

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader();

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final secondaryText = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final dateStr = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$_greeting, Admin',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: primaryText,
                letterSpacing: -0.4,
              ),
            ).animate().fadeIn(duration: 280.ms, delay: 80.ms)
                .slideY(begin: -0.06, end: 0, duration: 280.ms, curve: Curves.easeOut),
            const SizedBox(height: 3),
            Text(
              dateStr,
              style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: secondaryText),
            ).animate().fadeIn(duration: 280.ms, delay: 160.ms),
          ],
        ),
        const Spacer(),
        const _NotificationBell(),
      ],
    );
  }
}

class _NotificationBell extends StatefulWidget {
  const _NotificationBell();

  @override
  State<_NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<_NotificationBell> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkBgCard : AppColors.lightBgCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final iconColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final iconHover = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final elevatedBg = isDark ? AppColors.darkBgElevated : AppColors.lightBgElevated;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _hovered ? elevatedBg : cardBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: border),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(Icons.notifications_outlined, size: 20,
                color: _hovered ? iconHover : iconColor),
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 280.ms, delay: 200.ms);
  }
}

// ── Stats Row ─────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final DashboardLoaded state;
  const _StatsRow({required this.state});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppConstants.cardGap,
      runSpacing: AppConstants.cardGap,
      children: [
        StatCard(
          label: 'ACTIVE MEMBERS',
          value: state.activeMembers,
          icon: Icons.people_outline_rounded,
          gradient: AppColors.gradientMembers,
          changeText: '+12%',
          heroTag: 'stat_members',
          animationDelayMs: 180,
        ),
        StatCard(
          label: "TODAY'S ENTRIES",
          value: state.todayEntries,
          icon: Icons.login_rounded,
          gradient: AppColors.gradientEntries,
          changeText: '+5%',
          heroTag: 'stat_entries',
          animationDelayMs: 260,
        ),
        StatCard(
          label: 'REVENUE THIS MONTH',
          value: state.revenueThisMonth.toInt(),
          icon: Icons.account_balance_wallet_outlined,
          gradient: AppColors.gradientRevenue,
          changeText: '+8%',
          heroTag: 'stat_revenue',
          formatter: (v) => '${NumberFormat('#,###').format(v)} DA',
          animationDelayMs: 340,
        ),
        StatCard(
          label: 'LOW STOCK ALERTS',
          value: state.lowStockAlerts,
          icon: Icons.inventory_2_outlined,
          gradient: AppColors.gradientStock,
          heroTag: 'stat_stock',
          animationDelayMs: 420,
        ),
      ],
    );
  }
}

class _StatsRowSkeleton extends StatelessWidget {
  const _StatsRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppConstants.cardGap,
      runSpacing: AppConstants.cardGap,
      children: List.generate(4, (_) => const StatCardSkeleton()),
    );
  }
}

// ── Quick Actions ─────────────────────────────────────────────────────────────

class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    final actions = [
      (Icons.qr_code_scanner_rounded, 'New Entry', () {}, AppColors.success),
      (Icons.person_add_outlined, 'New Member', () => context.go(AppRoutes.members), AppColors.primary),
      (Icons.point_of_sale_outlined, 'New Sale', () => context.go(AppRoutes.sales), AppColors.primary),
      (Icons.groups_outlined, 'New Group', () => context.go(AppRoutes.groups), AppColors.primaryLight),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: primaryText,
          ),
        ).animate().fadeIn(duration: 250.ms, delay: 650.ms),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: actions.indexed.map((e) {
            final (i, (icon, label, onTap, color)) = e;
            return QuickActionButton(
              icon: icon,
              label: label,
              onTap: onTap,
              accentColor: color,
            )
                .animate()
                .fadeIn(duration: 220.ms, delay: Duration(milliseconds: 700 + i * 55))
                .slideY(begin: 0.05, end: 0, duration: 220.ms);
          }).toList(),
        ),
      ],
    );
  }
}

// ── Error Card ────────────────────────────────────────────────────────────────

class _ErrorCard extends StatelessWidget {
  final String message;
  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => context.read<DashboardCubit>().loadDashboard(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
