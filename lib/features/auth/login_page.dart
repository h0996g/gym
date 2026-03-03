import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../main.dart';
import 'cubit/auth_cubit.dart';
import 'cubit/auth_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go(AppRoutes.dashboard);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.darkBgBase,
          body: Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth >= 900) {
                    return _WideLayout(state: state);
                  }
                  return _NarrowLayout(state: state);
                },
              ),
              const Positioned(top: 16, right: 16, child: _ThemeToggleButton()),
            ],
          ),
        );
      },
    );
  }
}

// ─── Wide Layout (split panel) ───────────────────────────────────────────────

class _WideLayout extends StatelessWidget {
  final AuthState state;
  const _WideLayout({required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 5, child: const _LeftPanel()),
        Expanded(flex: 4, child: _RightPanel(state: state)),
      ],
    );
  }
}

// ─── Narrow Layout (centered card) ───────────────────────────────────────────

class _NarrowLayout extends StatelessWidget {
  final AuthState state;
  const _NarrowLayout({required this.state});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: _LoginCard(state: state),
          ),
        ),
      ),
    );
  }
}

// ─── Gym Title (animated gradient shimmer) ────────────────────────────────────

class _GymTitle extends StatefulWidget {
  const _GymTitle();

  @override
  State<_GymTitle> createState() => _GymTitleState();
}

class _GymTitleState extends State<_GymTitle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController;
  late final Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
    _shimmerAnimation = CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _shimmerAnimation,
          builder: (_, _) {
            final shift = _shimmerAnimation.value;
            return ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [
                  (shift - 0.4).clamp(0.0, 1.0),
                  shift.clamp(0.0, 1.0),
                  (shift + 0.4).clamp(0.0, 1.0),
                ],
                colors: const [
                  Colors.white,
                  Color(0xFFB8B0FF), // soft lavender highlight
                  Colors.white,
                ],
              ).createShader(bounds),
              child: const Text(
                'COLOSSUS',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 6,
                  height: 1.0,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        const Text(
          'GYM & FITNESS',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryLight,
            letterSpacing: 5,
          ),
        ),
      ],
    );
  }
}

// ─── Left Panel ──────────────────────────────────────────────────────────────

class _LeftPanel extends StatelessWidget {
  const _LeftPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.darkBgBase, AppColors.darkBgCard],
        ),
      ),
      child: Stack(
        children: [
          const _DecorativeShapes(),
          Column(
            children: [
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const _LogoWidget()
                            .animate()
                            .fadeIn(duration: 600.ms)
                            .scaleXY(
                              begin: 0.85,
                              end: 1.0,
                              curve: Curves.easeOutBack,
                            ),
                        const SizedBox(height: 15),
                        const _GymTitle()
                            .animate(delay: 200.ms)
                            .fadeIn(duration: 350.ms)
                            .slideY(begin: 0.15, end: 0, curve: Curves.easeOut),

                        // const Text(
                        //   'Train Hard. Live Strong.',
                        //   textAlign: TextAlign.center,
                        //   style: TextStyle(
                        //     fontFamily: 'Inter',
                        //     fontSize: 14,
                        //     fontWeight: FontWeight.w400,
                        //     color: AppColors.darkTextSecondary,
                        //     letterSpacing: 0.3,
                        //   ),
                        // )
                        //     .animate(delay: 380.ms)
                        //     .fadeIn(duration: 350.ms),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Text(
                  '© 2026 Colossus Gym & Fitness',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: AppColors.darkTextDisabled,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Logo Widget ─────────────────────────────────────────────────────────────

class _LogoWidget extends StatelessWidget {
  const _LogoWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.5),
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset('assets/images/logo/logo.jpg', fit: BoxFit.cover),
      ),
    );
  }
}

// ─── Decorative Background Shapes ────────────────────────────────────────────

class _DecorativeShapes extends StatelessWidget {
  const _DecorativeShapes();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(child: CustomPaint(painter: _ShapesPainter()));
  }
}

class _ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final circlePaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;

    // Large circle top-left
    canvas.drawCircle(
      Offset(-40, -60),
      200,
      circlePaint..color = AppColors.primary.withValues(alpha: 0.04),
    );
    // Medium circle top-right
    canvas.drawCircle(
      Offset(size.width + 80, 120),
      160,
      circlePaint..color = AppColors.primary.withValues(alpha: 0.06),
    );
    // Small circle bottom-left
    canvas.drawCircle(
      Offset(60, size.height - 80),
      100,
      circlePaint..color = AppColors.primary.withValues(alpha: 0.05),
    );
    // Medium circle bottom-right
    canvas.drawCircle(
      Offset(size.width - 40, size.height + 40),
      140,
      circlePaint..color = AppColors.primary.withValues(alpha: 0.03),
    );

    // Diagonal lines
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final angles = [25.0, 35.0, 50.0, 65.0];
    final offsets = [
      Offset(size.width * 0.2, 0),
      Offset(size.width * 0.5, 0),
      Offset(size.width * 0.75, 0),
      Offset(0, size.height * 0.3),
    ];

    for (int i = 0; i < angles.length; i++) {
      final angle = angles[i] * math.pi / 180;
      final start = offsets[i];
      final end = Offset(
        start.dx + math.cos(angle) * size.height * 1.5,
        start.dy + math.sin(angle) * size.height * 1.5,
      );
      canvas.drawLine(start, end, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Right Panel ─────────────────────────────────────────────────────────────

class _RightPanel extends StatelessWidget {
  final AuthState state;
  const _RightPanel({required this.state});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: _LoginCard(state: state),
          ),
        ),
      ),
    );
  }
}

// ─── Login Card ───────────────────────────────────────────────────────────────

class _LoginCard extends StatefulWidget {
  final AuthState state;
  const _LoginCard({required this.state});

  @override
  State<_LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<_LoginCard> {
  final _shakeKey = GlobalKey<_ShakeWidgetState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_LoginCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state is AuthError && oldWidget.state is! AuthError) {
      _shakeKey.currentState?.shake();
    }
  }

  void _handleLogin() {
    context.read<AuthCubit>().login(
      _usernameController.text,
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLoading = widget.state is AuthLoading;

    final cardColor = isDark ? AppColors.darkBgCard : AppColors.lightBgCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return _ShakeWidget(
      key: _shakeKey,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
              blurRadius: 40,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isDark)
                .animate(delay: 100.ms)
                .fadeIn(duration: 300.ms)
                .slideX(begin: 0.04, end: 0, curve: Curves.easeOut),
            const SizedBox(height: 32),
            _StyledTextField(
                  controller: _usernameController,
                  label: 'Username',
                  hint: 'Enter your username',
                  prefixIcon: Icons.person_outline_rounded,
                  textInputAction: TextInputAction.next,
                )
                .animate(delay: 200.ms)
                .fadeIn(duration: 300.ms)
                .slideX(begin: 0.04, end: 0, curve: Curves.easeOut),
            const SizedBox(height: 16),
            _StyledTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Enter your password',
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _handleLogin(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 18,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                )
                .animate(delay: 280.ms)
                .fadeIn(duration: 300.ms)
                .slideX(begin: 0.04, end: 0, curve: Curves.easeOut),
            if (widget.state is AuthError) ...[
              const SizedBox(height: 12),
              _ErrorMessage(message: (widget.state as AuthError).message),
            ],
            const SizedBox(height: 32),
            _LoginButton(isLoading: isLoading, onTap: _handleLogin)
                .animate(delay: 360.ms)
                .fadeIn(duration: 300.ms)
                .slideX(begin: 0.04, end: 0, curve: Curves.easeOut),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    final primaryText = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final secondaryText = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: primaryText,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Sign in to continue',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: secondaryText,
          ),
        ),
      ],
    );
  }
}

// ─── Shake Widget ─────────────────────────────────────────────────────────────

class _ShakeWidget extends StatefulWidget {
  final Widget child;
  const _ShakeWidget({super.key, required this.child});

  @override
  State<_ShakeWidget> createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<_ShakeWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -8.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: -6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6.0, end: 6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 6.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void shake() {
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, child) => Transform(
        transform: Matrix4.translationValues(_animation.value, 0, 0),
        child: child,
      ),
      child: widget.child,
    );
  }
}

// ─── Styled TextField ─────────────────────────────────────────────────────────

class _StyledTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;

  const _StyledTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
  });

  @override
  State<_StyledTextField> createState() => _StyledTextFieldState();
}

class _StyledTextFieldState extends State<_StyledTextField> {
  bool _hovered = false;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isFocused = _focusNode.hasFocus;
    final isActive = isFocused || _hovered;

    final bgColor = isDark
        ? AppColors.darkBgElevated
        : AppColors.lightBgElevated;
    final borderColor = isFocused
        ? AppColors.primary.withValues(alpha: 0.7)
        : isActive
        ? AppColors.primary.withValues(alpha: 0.4)
        : (isDark ? AppColors.darkBorder : AppColors.lightBorder);
    final labelColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final iconColor = isActive ? AppColors.primary : labelColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isFocused ? AppColors.primary : labelColor,
            ),
          ),
          const SizedBox(height: 6),
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: borderColor,
                width: isFocused ? 1.5 : 1.0,
              ),
              boxShadow: isFocused
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              obscureText: widget.obscureText,
              textInputAction: widget.textInputAction,
              onSubmitted: widget.onSubmitted,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: textColor,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: labelColor.withValues(alpha: 0.5),
                ),
                prefixIcon: Icon(widget.prefixIcon, size: 18, color: iconColor),
                suffixIcon: widget.suffixIcon,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Error Message ────────────────────────────────────────────────────────────

class _ErrorMessage extends StatelessWidget {
  final String message;
  const _ErrorMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.error.withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 16,
                color: AppColors.error,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 200.ms)
        .slideY(begin: 0.3, end: 0, curve: Curves.easeOut);
  }
}

// ─── Login Button ─────────────────────────────────────────────────────────────

class _LoginButton extends StatefulWidget {
  final bool isLoading;
  final VoidCallback onTap;
  const _LoginButton({required this.isLoading, required this.onTap});

  @override
  State<_LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<_LoginButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTap: widget.isLoading ? null : widget.onTap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _pressed ? 1.5 : 0.0, 0),
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _hovered
                  ? [AppColors.primaryLight, AppColors.primary]
                  : [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator.adaptive(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text(
                    'Sign In',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.2,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

// ─── Theme Toggle Button ──────────────────────────────────────────────────────

class _ThemeToggleButton extends StatefulWidget {
  const _ThemeToggleButton();

  @override
  State<_ThemeToggleButton> createState() => _ThemeToggleButtonState();
}

class _ThemeToggleButtonState extends State<_ThemeToggleButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () =>
            themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _hovered
                ? (isDark
                      ? AppColors.darkBgElevated
                      : AppColors.lightBgElevated)
                : (isDark
                      ? AppColors.darkBgCard.withValues(alpha: 0.8)
                      : AppColors.lightBgCard.withValues(alpha: 0.8)),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          child: Icon(
            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            size: 18,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
      ),
    );
  }
}
