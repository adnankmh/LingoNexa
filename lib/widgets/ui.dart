import 'dart:math' as math;

import 'package:flutter/material.dart';

class ResponsivePage extends StatelessWidget {
  const ResponsivePage({
    required this.child,
    this.maxWidth = 1120,
    this.padding = const EdgeInsets.fromLTRB(18, 12, 18, 110),
    super.key,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

class BrandMark extends StatelessWidget {
  const BrandMark({this.size = 44, this.showShadow = true, super.key});

  final double size;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FCFF),
        borderRadius: BorderRadius.circular(size * .34),
        border:
            Border.all(color: const Color(0xFF0B68C8).withValues(alpha: .12)),
        boxShadow: showShadow
            ? [
                BoxShadow(
                    color: const Color(0xFF0757B8).withValues(alpha: .22),
                    blurRadius: 18,
                    offset: const Offset(0, 8))
              ]
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.all(size * .10),
        child: Image.asset('assets/branding/lingonexa_icon.png',
            fit: BoxFit.contain),
      ),
    );
  }
}

class LingoNexaLogo extends StatelessWidget {
  const LingoNexaLogo({this.height = 96, super.key});

  final double height;

  @override
  Widget build(BuildContext context) => Semantics(
        image: true,
        label: 'LingoNexa',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Image.asset(
            'assets/branding/lingonexa_logo.png',
            height: height,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
        ),
      );
}

class SectionHeading extends StatelessWidget {
  const SectionHeading(
      {required this.title, this.subtitle, this.action, super.key});

  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w900)),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ],
            ],
          ),
        ),
        if (action != null) action!,
      ],
    );
  }
}

class StatPill extends StatelessWidget {
  const StatPill(
      {required this.icon,
      required this.value,
      required this.label,
      this.color,
      super.key});

  final IconData icon;
  final String value;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tint = color ?? Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: tint, size: 20),
          const SizedBox(width: 7),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 12)),
        ],
      ),
    );
  }
}

class GradientPanel extends StatelessWidget {
  const GradientPanel(
      {required this.child,
      this.padding = const EdgeInsets.all(22),
      super.key});

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primary,
            Color.lerp(scheme.primary, scheme.tertiary, .72)!
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
              color: scheme.primary.withValues(alpha: .22),
              blurRadius: 28,
              offset: const Offset(0, 14))
        ],
      ),
      child: child,
    );
  }
}

class ProgressRing extends StatelessWidget {
  const ProgressRing(
      {required this.value, required this.label, this.size = 78, super.key});

  final double value;
  final String label;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: value.clamp(0, 1).toDouble(),
              strokeWidth: 8,
              strokeCap: StrokeCap.round,
              color: Colors.white,
              backgroundColor: Colors.white.withValues(alpha: .22),
            ),
          ),
          Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 14)),
        ],
      ),
    );
  }
}

class FeatureTile extends StatelessWidget {
  const FeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
    this.badge,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: color.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(17)),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                            child: Text(title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15))),
                        if (badge != null) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                                color: color.withValues(alpha: .13),
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(badge!,
                                style: TextStyle(
                                    color: color,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900)),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 12.5,
                            height: 1.35)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class SoftBackground extends StatelessWidget {
  const SoftBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
            child: CustomPaint(
                painter: _OrbsPainter(Theme.of(context).colorScheme))),
        child,
      ],
    );
  }
}

class _OrbsPainter extends CustomPainter {
  _OrbsPainter(this.scheme);

  final ColorScheme scheme;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 70);
    paint.color = scheme.primary.withValues(alpha: .06);
    canvas.drawCircle(
        Offset(size.width * .9, 60), math.min(size.width, 220) * .45, paint);
    paint.color = scheme.tertiary.withValues(alpha: .05);
    canvas.drawCircle(Offset(size.width * .08, size.height * .55),
        math.min(size.width, 260) * .42, paint);
  }

  @override
  bool shouldRepaint(covariant _OrbsPainter oldDelegate) =>
      oldDelegate.scheme != scheme;
}
