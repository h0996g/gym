import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'side_nav_rail.dart';

class AppScaffold extends StatefulWidget {
  final Widget child;
  const AppScaffold({super.key, required this.child});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold>
    with SingleTickerProviderStateMixin {
  bool _expanded = true;

  late final AnimationController _sidebarController;
  late final Animation<double> _sidebarAnimation;

  @override
  void initState() {
    super.initState();
    _sidebarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      value: 1.0,
    );
    _sidebarAnimation = CurvedAnimation(
      parent: _sidebarController,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _sidebarController.dispose();
    super.dispose();
  }

  void _toggleSidebar() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _sidebarController.forward();
      } else {
        _sidebarController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dividerColor = Theme.of(context).dividerColor;

    return Scaffold(
      body: Row(
        children: [
          AnimatedBuilder(
            animation: _sidebarAnimation,
            builder: (context, _) {
              final width = AppConstants.sidebarCollapsedWidth +
                  (_sidebarAnimation.value *
                      (AppConstants.sidebarExpandedWidth -
                          AppConstants.sidebarCollapsedWidth));
              return SizedBox(
                width: width,
                child: SideNavRail(
                  expanded: _expanded,
                  onToggle: _toggleSidebar,
                ),
              );
            },
          ),
          VerticalDivider(width: 1, thickness: 1, color: dividerColor),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
