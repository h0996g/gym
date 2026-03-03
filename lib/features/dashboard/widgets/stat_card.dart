import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import 'animated_counter.dart';

class StatCard extends StatefulWidget {
  final String label;
  final int value;
  final String? changeText;
  final IconData icon;
  final List<Color> gradient;
  final String? heroTag;
  final String Function(int)? formatter;
  final int animationDelayMs;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.gradient,
    this.changeText,
    this.heroTag,
    this.formatter,
    this.animationDelayMs = 0,
  });

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _hovered ? -4.0 : 0.0, 0),
        child: Hero(
          tag: widget.heroTag ?? widget.label,
          child: Container(
            width: AppConstants.statCardWidth,
            height: AppConstants.statCardHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
              boxShadow: [
                BoxShadow(
                  color: widget.gradient.first.withValues(alpha: _hovered ? 0.45 : 0.22),
                  blurRadius: _hovered ? 28 : 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Subtle decorative circle in top-right
                Positioned(
                  top: -20,
                  right: -20,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.07),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -30,
                  right: 20,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                ),
                // Main content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // Top row: icon + change badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _IconBadge(icon: widget.icon),
                          if (widget.changeText != null)
                            _ChangeBadge(text: widget.changeText!),
                        ],
                      ),
                      const Spacer(),
                      // Value
                      AnimatedCounter(
                        value: widget.value,
                        formatter: widget.formatter,
                        style: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 3),
                      // Label
                      Text(
                        widget.label,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: widget.animationDelayMs))
        .fadeIn(duration: 350.ms, curve: Curves.easeOut)
        .scaleXY(begin: 0.92, end: 1.0, duration: 400.ms, curve: Curves.easeOutBack);
  }
}

class _IconBadge extends StatelessWidget {
  final IconData icon;
  const _IconBadge({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }
}

class _ChangeBadge extends StatelessWidget {
  final String text;
  const _ChangeBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    final isPositive = text.startsWith('+');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: isPositive
            ? Colors.white.withValues(alpha: 0.2)
            : Colors.black.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
            color: Colors.white,
            size: 9,
          ),
          const SizedBox(width: 2),
          Text(
            text.replaceAll('+', '').replaceAll('-', ''),
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class StatCardSkeleton extends StatelessWidget {
  const StatCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? AppColors.darkBgCard : AppColors.lightBgCard;
    final highlight = isDark ? AppColors.darkBgElevated : AppColors.lightBgElevated;

    return Container(
      width: AppConstants.statCardWidth,
      height: AppConstants.statCardHeight,
      decoration: BoxDecoration(
        color: base,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
    ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms, color: highlight);
  }
}
