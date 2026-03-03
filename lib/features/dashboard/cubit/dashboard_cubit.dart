import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(const DashboardInitial());

  Future<void> loadDashboard() async {
    emit(const DashboardLoading());
    // Simulate a short data fetch delay
    await Future.delayed(const Duration(milliseconds: 700));
    emit(const DashboardLoaded(
      activeMembers: 347,
      todayEntries: 28,
      revenueThisMonth: 125000.0,
      lowStockAlerts: 3,
      recentActivity: [
        ActivityItem(
          description: 'Ahmed Karim entered the gym',
          timeAgo: '2 min ago',
          type: ActivityType.entry,
        ),
        ActivityItem(
          description: 'Sale #1042 — Protein Whey x2',
          timeAgo: '5 min ago',
          type: ActivityType.sale,
        ),
        ActivityItem(
          description: 'New member: Sara Mansouri registered',
          timeAgo: '12 min ago',
          type: ActivityType.newMember,
        ),
        ActivityItem(
          description: 'Youssef Belaid — entry refused (expired)',
          timeAgo: '18 min ago',
          type: ActivityType.refusal,
        ),
        ActivityItem(
          description: 'Sale #1041 — Gym Gloves x1',
          timeAgo: '25 min ago',
          type: ActivityType.sale,
        ),
        ActivityItem(
          description: 'Fatima Zohra entered the gym',
          timeAgo: '31 min ago',
          type: ActivityType.entry,
        ),
      ],
    ));
  }
}
