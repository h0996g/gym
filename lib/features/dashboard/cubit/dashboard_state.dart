import 'package:equatable/equatable.dart';

class ActivityItem extends Equatable {
  final String description;
  final String timeAgo;
  final ActivityType type;

  const ActivityItem({
    required this.description,
    required this.timeAgo,
    required this.type,
  });

  @override
  List<Object?> get props => [description, timeAgo, type];
}

enum ActivityType { entry, sale, newMember, refusal }

sealed class DashboardState extends Equatable {
  const DashboardState();
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
  @override
  List<Object?> get props => [];
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
  @override
  List<Object?> get props => [];
}

class DashboardLoaded extends DashboardState {
  final int activeMembers;
  final int todayEntries;
  final double revenueThisMonth;
  final int lowStockAlerts;
  final List<ActivityItem> recentActivity;

  const DashboardLoaded({
    required this.activeMembers,
    required this.todayEntries,
    required this.revenueThisMonth,
    required this.lowStockAlerts,
    required this.recentActivity,
  });

  @override
  List<Object?> get props => [
        activeMembers,
        todayEntries,
        revenueThisMonth,
        lowStockAlerts,
        recentActivity,
      ];
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);
  @override
  List<Object?> get props => [message];
}
