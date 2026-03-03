import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../cubit/dashboard_state.dart';

class ActivityTile extends StatelessWidget {
  final ActivityItem item;

  const ActivityTile({super.key, required this.item});

  (IconData, Color) get _iconAndColor => switch (item.type) {
        ActivityType.entry => (Icons.login_rounded, AppColors.success),
        ActivityType.sale => (Icons.shopping_bag_outlined, AppColors.primary),
        ActivityType.newMember => (Icons.person_add_outlined, AppColors.primary),
        ActivityType.refusal => (Icons.block_outlined, AppColors.error),
      };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (icon, color) = _iconAndColor;
    final cardBg = isDark ? AppColors.darkBgCard : AppColors.lightBgCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final primaryText = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final disabledText = isDark ? AppColors.darkTextDisabled : AppColors.lightTextDisabled;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item.description,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: primaryText,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            item.timeAgo,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: disabledText,
            ),
          ),
        ],
      ),
    );
  }
}
