import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';

// ── Fake data ──────────────────────────────────────────────────────────────────

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

const _revenueData = [
  185000,
  210000,
  198000,
  240000,
  275000,
  262000,
  290000,
  315000,
  298000,
  340000,
  378000,
  412000,
];

const _memberData = [42, 45, 51, 58, 63, 67, 72, 78, 81, 88, 94, 102];

const _topPlans = [
  ('Monthly Premium', 38, AppColors.primary),
  ('3-Month Pack', 27, Color(0xFF06B6D4)),
  ('Annual VIP', 19, AppColors.success),
  ('Daily Pass', 10, AppColors.accent),
  ('Student Plan', 6, AppColors.error),
];

const _recentSales = [
  ('Karim Bensalem', 'Monthly Premium', 4500, true),
  ('Sara Moussaoui', 'Annual VIP', 36000, true),
  ('Yacine Hamdi', '3-Month Pack', 10800, true),
  ('Nadia Larbi', 'Monthly Premium', 4500, false),
  ('Omar Fekkar', 'Daily Pass', 500, true),
  ('Amina Chali', 'Student Plan', 3200, true),
];

// ── Page ───────────────────────────────────────────────────────────────────────

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  int _selectedPeriod = 2; // 0=Week, 1=Month, 2=Year

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final secondaryText = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.contentPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                        'Statistics',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: primaryText,
                          letterSpacing: -0.4,
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 280.ms)
                      .slideY(begin: -0.06, end: 0, duration: 280.ms),
                  const SizedBox(height: 3),
                  Text(
                    'Revenue, members & sales overview',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color: secondaryText,
                    ),
                  ).animate().fadeIn(duration: 280.ms, delay: 80.ms),
                ],
              ),
              const Spacer(),
              _PeriodToggle(
                selected: _selectedPeriod,
                onChanged: (v) => setState(() => _selectedPeriod = v),
              ).animate().fadeIn(duration: 280.ms, delay: 120.ms),
            ],
          ),

          const SizedBox(height: 24),

          // ── KPI row ─────────────────────────────────────────────────────────
          const _KpiRow(),

          const SizedBox(height: 24),

          // ── Charts row ──────────────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: _RevenueChartCard(period: _selectedPeriod),
              ),
              const SizedBox(width: AppConstants.cardGap),
              Expanded(
                flex: 2,
                child: _MemberGrowthCard(period: _selectedPeriod),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.cardGap),

          // ── Bottom row ──────────────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _TopPlansCard()),
              const SizedBox(width: AppConstants.cardGap),
              Expanded(flex: 3, child: _RecentSalesCard()),
            ],
          ),

          const SizedBox(height: 28),
        ],
      ),
    );
  }
}

// ── Period Toggle ──────────────────────────────────────────────────────────────

class _PeriodToggle extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;
  const _PeriodToggle({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBgCard : AppColors.lightBgCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final labels = ['Week', 'Month', 'Year'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final active = selected == i;
          return GestureDetector(
            onTap: () => onChanged(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: active ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Text(
                labels[i],
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: active
                      ? Colors.white
                      : isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ── KPI Row ────────────────────────────────────────────────────────────────────

class _KpiRow extends StatelessWidget {
  const _KpiRow();

  @override
  Widget build(BuildContext context) {
    final kpis = [
      (
        'Total Revenue',
        '3,203,000 DA',
        '+18.4%',
        Icons.trending_up_rounded,
        AppColors.gradientRevenue,
        true,
      ),
      (
        'New Members',
        '102',
        '+12.1%',
        Icons.person_add_outlined,
        AppColors.gradientMembers,
        true,
      ),
      (
        'Avg. Session/Day',
        '47',
        '+5.3%',
        Icons.fitness_center_rounded,
        AppColors.gradientEntries,
        true,
      ),
      (
        'Churn Rate',
        '3.2%',
        '-1.1%',
        Icons.person_remove_outlined,
        AppColors.gradientStock,
        false,
      ),
    ];

    return Row(
      children: kpis.indexed.map((e) {
        final (i, (label, value, change, icon, grad, positive)) = e;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: i < kpis.length - 1 ? AppConstants.cardGap : 0,
            ),
            child: _KpiCard(
              label: label,
              value: value,
              change: change,
              icon: icon,
              gradient: grad,
              positive: positive,
              delay: 150 + i * 70,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _KpiCard extends StatefulWidget {
  final String label;
  final String value;
  final String change;
  final IconData icon;
  final List<Color> gradient;
  final bool positive;
  final int delay;

  const _KpiCard({
    required this.label,
    required this.value,
    required this.change,
    required this.icon,
    required this.gradient,
    required this.positive,
    required this.delay,
  });

  @override
  State<_KpiCard> createState() => _KpiCardState();
}

class _KpiCardState extends State<_KpiCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkBgCard : AppColors.lightBgCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final primaryText = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final secondaryText = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            transform: Matrix4.translationValues(0, _hovered ? -3.0 : 0.0, 0),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(
                AppConstants.cardBorderRadius,
              ),
              border: Border.all(
                color: _hovered
                    ? widget.gradient.first.withValues(alpha: 0.4)
                    : border,
              ),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: widget.gradient.first.withValues(alpha: 0.12),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : [],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: widget.gradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Icon(widget.icon, color: Colors.white, size: 17),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: widget.positive
                            ? AppColors.success.withValues(alpha: 0.12)
                            : AppColors.error.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.positive
                                ? Icons.arrow_upward_rounded
                                : Icons.arrow_downward_rounded,
                            size: 9,
                            color: widget.positive
                                ? AppColors.success
                                : AppColors.error,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            widget.change
                                .replaceAll('+', '')
                                .replaceAll('-', ''),
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: widget.positive
                                  ? AppColors.success
                                  : AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  widget.value,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: primaryText,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: secondaryText,
                  ),
                ),
              ],
            ),
          ),
        )
        .animate(delay: Duration(milliseconds: widget.delay))
        .fadeIn(duration: 320.ms)
        .slideY(begin: 0.06, end: 0, duration: 320.ms, curve: Curves.easeOut);
  }
}

// ── Revenue Chart Card ─────────────────────────────────────────────────────────

class _RevenueChartCard extends StatelessWidget {
  final int period;
  const _RevenueChartCard({required this.period});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkBgCard : AppColors.lightBgCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final primaryText = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final secondaryText = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final gridColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
            border: Border.all(color: border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Revenue Overview',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: primaryText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Monthly breakdown — 2024',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          color: secondaryText,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: AppColors.gradientRevenue,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '412,000 DA',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 180,
                child: _BarChart(
                  values: _revenueData.map((v) => v.toDouble()).toList(),
                  labels: _months,
                  color: AppColors.primary,
                  gridColor: gridColor,
                  secondaryText: secondaryText,
                ),
              ),
            ],
          ),
        )
        .animate(delay: 400.ms)
        .fadeIn(duration: 350.ms)
        .slideY(begin: 0.05, end: 0, duration: 350.ms, curve: Curves.easeOut);
  }
}

// ── Bar Chart ──────────────────────────────────────────────────────────────────

class _BarChart extends StatefulWidget {
  final List<double> values;
  final List<String> labels;
  final Color color;
  final Color gridColor;
  final Color secondaryText;

  const _BarChart({
    required this.values,
    required this.labels,
    required this.color,
    required this.gridColor,
    required this.secondaryText,
  });

  @override
  State<_BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<_BarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  int? _hoveredBar;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, _) => CustomPaint(
        painter: _BarChartPainter(
          values: widget.values,
          labels: widget.labels,
          color: widget.color,
          gridColor: widget.gridColor,
          secondaryText: widget.secondaryText,
          progress: _anim.value,
          hoveredBar: _hoveredBar,
        ),
        child: MouseRegion(
          onHover: (event) {
            final barCount = widget.values.length;
            final relX = event.localPosition.dx;
            final width = context.size?.width ?? 1;
            final idx = (relX / width * barCount).floor().clamp(
              0,
              barCount - 1,
            );
            if (_hoveredBar != idx) setState(() => _hoveredBar = idx);
          },
          onExit: (_) => setState(() => _hoveredBar = null),
        ),
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<double> values;
  final List<String> labels;
  final Color color;
  final Color gridColor;
  final Color secondaryText;
  final double progress;
  final int? hoveredBar;

  _BarChartPainter({
    required this.values,
    required this.labels,
    required this.color,
    required this.gridColor,
    required this.secondaryText,
    required this.progress,
    required this.hoveredBar,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final maxVal = values.reduce((a, b) => a > b ? a : b);
    final chartH = size.height - 28; // 28 for labels
    final barW = (size.width / values.length) * 0.5;
    final gap = size.width / values.length;

    // Grid lines
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5;
    for (int i = 0; i <= 4; i++) {
      final y = chartH * (1 - i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Bars
    for (int i = 0; i < values.length; i++) {
      final frac = (values[i] / maxVal) * progress;
      final barH = chartH * frac;
      final x = gap * i + gap / 2 - barW / 2;
      final y = chartH - barH;
      final isHovered = hoveredBar == i;
      final isLast = i == values.length - 1;

      final rect = RRect.fromRectAndCorners(
        Rect.fromLTWH(x, y, barW, barH),
        topLeft: const Radius.circular(5),
        topRight: const Radius.circular(5),
      );

      // Bar fill
      final paint = Paint()
        ..shader = LinearGradient(
          colors: isHovered || isLast
              ? [color, color.withValues(alpha: 0.6)]
              : [color.withValues(alpha: 0.55), color.withValues(alpha: 0.25)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(x, y, barW, barH));
      canvas.drawRRect(rect, paint);

      // Hover tooltip
      if (isHovered) {
        final val = NumberFormat('#,###').format(values[i].toInt());
        final tp = TextPainter(
          text: TextSpan(
            text: '$val DA',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          textDirection: ui.TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(x + barW / 2 - tp.width / 2, y - 16));
      }

      // Month label
      final lp = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 9.5,
            fontWeight: FontWeight.w500,
            color: secondaryText,
          ),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();
      lp.paint(canvas, Offset(gap * i + gap / 2 - lp.width / 2, chartH + 8));
    }
  }

  @override
  bool shouldRepaint(_BarChartPainter old) =>
      old.progress != progress || old.hoveredBar != hoveredBar;
}

// ── Member Growth Card ─────────────────────────────────────────────────────────

class _MemberGrowthCard extends StatelessWidget {
  final int period;
  const _MemberGrowthCard({required this.period});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkBgCard : AppColors.lightBgCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final primaryText = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final secondaryText = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final gridColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
            border: Border.all(color: border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Member Growth',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: primaryText,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Cumulative active members',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  color: secondaryText,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '102',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: primaryText,
                      letterSpacing: -1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6, left: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_upward_rounded,
                            size: 9,
                            color: AppColors.success,
                          ),
                          SizedBox(width: 2),
                          Text(
                            '12.1%',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 120,
                child: _LineChart(
                  values: _memberData.map((v) => v.toDouble()).toList(),
                  color: AppColors.primary,
                  gridColor: gridColor,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _months
                    .where(
                      (m) => ['Jan', 'Apr', 'Jul', 'Oct', 'Dec'].contains(m),
                    )
                    .map((m) {
                      return Text(
                        m,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 9.5,
                          color: secondaryText,
                        ),
                      );
                    })
                    .toList(),
              ),
            ],
          ),
        )
        .animate(delay: 450.ms)
        .fadeIn(duration: 350.ms)
        .slideY(begin: 0.05, end: 0, duration: 350.ms, curve: Curves.easeOut);
  }
}

// ── Line Chart ─────────────────────────────────────────────────────────────────

class _LineChart extends StatefulWidget {
  final List<double> values;
  final Color color;
  final Color gridColor;

  const _LineChart({
    required this.values,
    required this.color,
    required this.gridColor,
  });

  @override
  State<_LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<_LineChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, _) => CustomPaint(
        size: const Size(double.infinity, 120),
        painter: _LineChartPainter(
          values: widget.values,
          color: widget.color,
          gridColor: widget.gridColor,
          progress: _anim.value,
        ),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> values;
  final Color color;
  final Color gridColor;
  final double progress;

  _LineChartPainter({
    required this.values,
    required this.color,
    required this.gridColor,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final minVal = values.reduce((a, b) => a < b ? a : b) - 5;
    final maxVal = values.reduce((a, b) => a > b ? a : b);
    final range = maxVal - minVal;
    final count = values.length;
    final stepX = size.width / (count - 1);

    Offset pointAt(int i) {
      final x = stepX * i;
      final y = size.height * (1 - (values[i] - minVal) / range);
      return Offset(x, y);
    }

    // Clip progress
    final endIndex = (progress * (count - 1)).floor();
    final frac = (progress * (count - 1)) - endIndex;

    final visiblePoints = <Offset>[];
    for (int i = 0; i <= endIndex && i < count; i++) {
      visiblePoints.add(pointAt(i));
    }
    if (endIndex < count - 1) {
      final p0 = pointAt(endIndex);
      final p1 = pointAt(endIndex + 1);
      visiblePoints.add(Offset.lerp(p0, p1, frac)!);
    }

    if (visiblePoints.length < 2) return;

    // Fill area
    final fillPath = Path();
    fillPath.moveTo(visiblePoints.first.dx, size.height);
    for (final p in visiblePoints) {
      fillPath.lineTo(p.dx, p.dy);
    }
    fillPath.lineTo(visiblePoints.last.dx, size.height);
    fillPath.close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          colors: [color.withValues(alpha: 0.25), color.withValues(alpha: 0.0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Line
    final linePath = Path();
    linePath.moveTo(visiblePoints.first.dx, visiblePoints.first.dy);
    for (int i = 1; i < visiblePoints.length; i++) {
      final prev = visiblePoints[i - 1];
      final curr = visiblePoints[i];
      final cpx = (prev.dx + curr.dx) / 2;
      linePath.cubicTo(cpx, prev.dy, cpx, curr.dy, curr.dx, curr.dy);
    }

    canvas.drawPath(
      linePath,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );

    // End dot
    if (visiblePoints.isNotEmpty) {
      final last = visiblePoints.last;
      canvas.drawCircle(last, 4, Paint()..color = color);
      canvas.drawCircle(last, 2.5, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(_LineChartPainter old) => old.progress != progress;
}

// ── Top Plans Card ─────────────────────────────────────────────────────────────

class _TopPlansCard extends StatelessWidget {
  const _TopPlansCard();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkBgCard : AppColors.lightBgCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final primaryText = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final secondaryText = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final trackBg = isDark
        ? AppColors.darkBgElevated
        : AppColors.lightBgElevated;

    return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
            border: Border.all(color: border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Top Plans',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: primaryText,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'By subscriber count',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  color: secondaryText,
                ),
              ),
              const SizedBox(height: 20),
              ..._topPlans.indexed.map((e) {
                final (i, (name, pct, color)) = e;
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: i < _topPlans.length - 1 ? 16 : 0,
                  ),
                  child: _PlanRow(
                    name: name,
                    percent: pct,
                    color: color,
                    trackBg: trackBg,
                    secondaryText: secondaryText,
                    primaryText: primaryText,
                    delay: 550 + i * 60,
                  ),
                );
              }),
            ],
          ),
        )
        .animate(delay: 500.ms)
        .fadeIn(duration: 350.ms)
        .slideY(begin: 0.05, end: 0, duration: 350.ms, curve: Curves.easeOut);
  }
}

class _PlanRow extends StatefulWidget {
  final String name;
  final int percent;
  final Color color;
  final Color trackBg;
  final Color secondaryText;
  final Color primaryText;
  final int delay;

  const _PlanRow({
    required this.name,
    required this.percent,
    required this.color,
    required this.trackBg,
    required this.secondaryText,
    required this.primaryText,
    required this.delay,
  });

  @override
  State<_PlanRow> createState() => _PlanRowState();
}

class _PlanRowState extends State<_PlanRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.name,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: widget.primaryText,
                ),
              ),
            ),
            Text(
              '${widget.percent}%',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: widget.color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Stack(
            children: [
              Container(height: 5, color: widget.trackBg),
              AnimatedBuilder(
                animation: _anim,
                builder: (_, _) => FractionallySizedBox(
                  widthFactor: widget.percent / 100 * _anim.value,
                  child: Container(
                    height: 5,
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Recent Sales Card ──────────────────────────────────────────────────────────

class _RecentSalesCard extends StatelessWidget {
  const _RecentSalesCard();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkBgCard : AppColors.lightBgCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final primaryText = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final secondaryText = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final rowDivider = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
            border: Border.all(color: border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Recent Sales',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: primaryText,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '6',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'View all',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Table header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'MEMBER',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          color: secondaryText,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'PLAN',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          color: secondaryText,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'AMOUNT',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          color: secondaryText,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 50),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ..._recentSales.indexed.map((e) {
                final (i, (member, plan, amount, paid)) = e;
                return Column(
                  children: [
                    if (i > 0)
                      Divider(height: 1, thickness: 0.5, color: rowDivider),
                    _SaleRow(
                      member: member,
                      plan: plan,
                      amount: amount,
                      paid: paid,
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                      delay: 550 + i * 55,
                    ),
                  ],
                );
              }),
            ],
          ),
        )
        .animate(delay: 530.ms)
        .fadeIn(duration: 350.ms)
        .slideY(begin: 0.05, end: 0, duration: 350.ms, curve: Curves.easeOut);
  }
}

class _SaleRow extends StatefulWidget {
  final String member;
  final String plan;
  final int amount;
  final bool paid;
  final Color primaryText;
  final Color secondaryText;
  final int delay;

  const _SaleRow({
    required this.member,
    required this.plan,
    required this.amount,
    required this.paid,
    required this.primaryText,
    required this.secondaryText,
    required this.delay,
  });

  @override
  State<_SaleRow> createState() => _SaleRowState();
}

class _SaleRowState extends State<_SaleRow> {
  bool _hovered = false;

  String get _initials {
    final parts = widget.member.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}';
    return parts[0][0];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            decoration: BoxDecoration(
              color: _hovered
                  ? (isDark
                        ? AppColors.darkBgElevated.withValues(alpha: 0.5)
                        : AppColors.lightBgElevated.withValues(alpha: 0.6))
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                // Avatar
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: AppColors.gradientMembers,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            _initials,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          widget.member,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: widget.primaryText,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                // Plan
                Expanded(
                  flex: 3,
                  child: Text(
                    widget.plan,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: widget.secondaryText,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Amount
                Expanded(
                  flex: 2,
                  child: Text(
                    '${NumberFormat('#,###').format(widget.amount)} DA',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: widget.primaryText,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: widget.paid
                        ? AppColors.success.withValues(alpha: 0.12)
                        : AppColors.error.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.paid ? 'Paid' : 'Pending',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: widget.paid ? AppColors.success : AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .animate(delay: Duration(milliseconds: widget.delay))
        .fadeIn(duration: 260.ms)
        .slideX(begin: -0.02, end: 0, duration: 260.ms, curve: Curves.easeOut);
  }
}
