import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../main.dart';
import '../router/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class _NavItem {
  final IconData icon;
  final IconData iconFilled;
  final String label;
  final String route;
  const _NavItem({
    required this.icon,
    required this.iconFilled,
    required this.label,
    required this.route,
  });
}

const _navItems = [
  _NavItem(icon: Icons.dashboard_outlined, iconFilled: Icons.dashboard_rounded, label: 'Dashboard', route: AppRoutes.dashboard),
  _NavItem(icon: Icons.people_outline_rounded, iconFilled: Icons.people_rounded, label: 'Members', route: AppRoutes.members),
  _NavItem(icon: Icons.card_membership_outlined, iconFilled: Icons.card_membership, label: 'Subscriptions', route: AppRoutes.subscriptions),
  _NavItem(icon: Icons.groups_outlined, iconFilled: Icons.groups_rounded, label: 'Groups', route: AppRoutes.groups),
  _NavItem(icon: Icons.inventory_2_outlined, iconFilled: Icons.inventory_2_rounded, label: 'Products', route: AppRoutes.products),
  _NavItem(icon: Icons.point_of_sale_outlined, iconFilled: Icons.point_of_sale_rounded, label: 'Sales', route: AppRoutes.sales),
  _NavItem(icon: Icons.bar_chart_outlined, iconFilled: Icons.bar_chart_rounded, label: 'Statistics', route: AppRoutes.statistics),
];

class SideNavRail extends StatelessWidget {
  final bool expanded;
  final VoidCallback onToggle;

  const SideNavRail({super.key, required this.expanded, required this.onToggle});

  bool _isActive(String location, String route) {
    if (route == AppRoutes.dashboard) return location == '/';
    return location.startsWith(route);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sidebarBg = isDark ? AppColors.darkBgSidebar : AppColors.lightBgSidebar;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final location = GoRouterState.of(context).uri.toString();

    return Container(
      color: sidebarBg,
      child: Column(
        children: [
          _BrandHeader(expanded: expanded, isDark: isDark),
          Divider(height: 1, thickness: 1, color: borderColor),
          const SizedBox(height: 4),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                children: _navItems.map((item) {
                  final active = _isActive(location, item.route);
                  return _NavTile(
                    item: item,
                    active: active,
                    expanded: expanded,
                    isDark: isDark,
                    primaryColor: cs.primary,
                    onTap: () => context.go(item.route),
                  );
                }).toList(),
              ),
            ),
          ),
          Divider(height: 1, thickness: 1, color: borderColor),
          _BottomActions(expanded: expanded, onToggle: onToggle, isDark: isDark),
        ],
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  final bool expanded;
  final bool isDark;
  const _BrandHeader({required this.expanded, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: expanded ? 18 : 0),
        child: Row(
          mainAxisAlignment: expanded ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo/logo.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (expanded) ...[
              const SizedBox(width: 10),
              Text(
                'Colossus',
                style: AppTextStyles.titleLarge.copyWith(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NavTile extends StatefulWidget {
  final _NavItem item;
  final bool active;
  final bool expanded;
  final bool isDark;
  final Color primaryColor;
  final VoidCallback onTap;

  const _NavTile({
    required this.item,
    required this.active,
    required this.expanded,
    required this.isDark,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  State<_NavTile> createState() => _NavTileState();
}

class _NavTileState extends State<_NavTile> {
  bool _hovered = false;

  Color get _textColor {
    if (widget.active) return widget.primaryColor;
    if (_hovered) return widget.isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    return widget.isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
  }

  @override
  Widget build(BuildContext context) {
    final elevatedBg = widget.isDark ? AppColors.darkBgElevated : AppColors.lightBgElevated;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(vertical: 2),
          padding: EdgeInsets.symmetric(
            horizontal: widget.expanded ? 12 : 0,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: widget.active
                ? widget.primaryColor.withValues(alpha: 0.1)
                : _hovered
                    ? elevatedBg
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: widget.expanded ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              Icon(
                widget.active ? widget.item.iconFilled : widget.item.icon,
                size: 20,
                color: _textColor,
              ),
              if (widget.expanded) ...[
                const SizedBox(width: 11),
                Expanded(
                  child: Text(
                    widget.item.label,
                    style: AppTextStyles.navLabel.copyWith(
                      color: _textColor,
                      fontWeight: widget.active ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
                if (widget.active)
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: widget.primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  final bool expanded;
  final VoidCallback onToggle;
  final bool isDark;

  const _BottomActions({required this.expanded, required this.onToggle, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: expanded
          ? Row(
              children: [
                _IconBtn(
                  icon: isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                  isDark: isDark,
                  tooltip: isDark ? 'Light mode' : 'Dark mode',
                  onTap: () => themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark,
                ),
                const Spacer(),
                _IconBtn(
                  icon: Icons.chevron_left_rounded,
                  isDark: isDark,
                  onTap: onToggle,
                  tooltip: 'Collapse',
                ),
              ],
            )
          : Column(
              children: [
                _IconBtn(
                  icon: isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                  isDark: isDark,
                  onTap: () => themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark,
                ),
                const SizedBox(height: 4),
                _IconBtn(
                  icon: Icons.chevron_right_rounded,
                  isDark: isDark,
                  onTap: onToggle,
                  tooltip: 'Expand',
                ),
              ],
            ),
    );
  }
}

class _IconBtn extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;
  final bool isDark;

  const _IconBtn({required this.icon, required this.onTap, required this.isDark, this.tooltip});

  @override
  State<_IconBtn> createState() => _IconBtnState();
}

class _IconBtnState extends State<_IconBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final elevatedBg = widget.isDark ? AppColors.darkBgElevated : AppColors.lightBgElevated;
    final iconColor = widget.isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final iconHoverColor = widget.isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Tooltip(
        message: widget.tooltip ?? '',
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: _hovered ? elevatedBg : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              widget.icon,
              size: 18,
              color: _hovered ? iconHoverColor : iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
