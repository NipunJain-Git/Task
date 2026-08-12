export 'ks_text.dart';
import 'ks_text.dart';
// Shared widgets for KaamSetu
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import '../core/domain.dart';
import '../data/models.dart';

// ─── KaamSetu Logo / Wordmark ────────────────────────────────────────────────
class KaamSetuLogo extends StatelessWidget {
  final double size;
  const KaamSetuLogo({super.key, this.size = 28});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo.png',
          width: size * 1.55,
          height: size,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            KsText(
              'KaamSetu',
              style: GoogleFonts.notoSans(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: size * 0.55,
                fontWeight: FontWeight.w800,
                height: 1.1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Skill Icon (emoji-based) ─────────────────────────────────────────────────
class SkillIcon extends StatelessWidget {
  final String skill;
  final double size;
  const SkillIcon({super.key, required this.skill, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return KsText(skillEmoji(skill), style: TextStyle(fontSize: size * 0.85));
  }
}

// ─── Verified Badge ───────────────────────────────────────────────────────────
class VerifiedBadge extends StatelessWidget {
  final bool verified;
  const VerifiedBadge({super.key, required this.verified});

  @override
  Widget build(BuildContext context) {
    if (!verified) return const SizedBox.shrink();
    return const Icon(Icons.verified, size: 14, color: AppTheme.primary);
  }
}

// ─── Trust Meter ─────────────────────────────────────────────────────────────
class TrustMeter extends StatelessWidget {
  final int score;
  const TrustMeter({super.key, required this.score});

  Color get _color {
    if (score >= 80) return AppTheme.success;
    if (score >= 55) return AppTheme.accent;
    return AppTheme.destructive;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 48,
          height: 8,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score / 100,
              backgroundColor: AppTheme.muted,
              valueColor: AlwaysStoppedAnimation<Color>(_color),
            ),
          ),
        ),
        const SizedBox(width: 6),
        KsText(
          '$score',
          style: GoogleFonts.notoSans(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: _color,
          ),
        ),
      ],
    );
  }
}

// ─── Live Dot ─────────────────────────────────────────────────────────────────
class LiveDot extends StatelessWidget {
  const LiveDot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: AppTheme.success,
        shape: BoxShape.circle,
      ),
    );
  }
}

// ─── Section Title ────────────────────────────────────────────────────────────
class SectionTitle extends StatelessWidget {
  final String title;
  final Widget? action;
  const SectionTitle({super.key, required this.title, this.action});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: KsText(
              title,
              style: GoogleFonts.notoSans(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}

// ─── Wage Tag ─────────────────────────────────────────────────────────────────
class WageTag extends StatelessWidget {
  final int amount;
  const WageTag({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return KsText(
      rupees(amount),
      style: GoogleFonts.notoSans(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: AppTheme.primary,
        fontFeatures: [const FontFeature.tabularFigures()],
      ),
    );
  }
}

// ─── Distance Chip ────────────────────────────────────────────────────────────
class DistanceChip extends StatelessWidget {
  final double km;
  const DistanceChip({super.key, required this.km});

  @override
  Widget build(BuildContext context) {
    final label = km < 1
        ? '${(km * 1000).round()} m'
        : '${km.toStringAsFixed(1)} km';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.secondary,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.location_on,
            size: 11,
            color: AppTheme.mutedForeground,
          ),
          const SizedBox(width: 2),
          KsText(
            label,
            style: GoogleFonts.notoSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppTheme.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────
class EmptyState extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String body;
  final Widget? action;
  const EmptyState({
    super.key,
    this.icon,
    required this.title,
    required this.body,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.muted.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 36, color: AppTheme.mutedForeground),
            const SizedBox(height: 12),
          ],
          KsText(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          KsText(
            body,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSans(
              fontSize: 12,
              color: AppTheme.mutedForeground,
              height: 1.5,
            ),
          ),
          if (action != null) ...[const SizedBox(height: 16), action!],
        ],
      ),
    );
  }
}

// ─── Urgency badge ────────────────────────────────────────────────────────────
class UrgentBadge extends StatelessWidget {
  const UrgentBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.destructive.withOpacity(0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department,
            size: 11,
            color: AppTheme.destructive,
          ),
          const SizedBox(width: 3),
          KsText(
            'Urgent',
            style: GoogleFonts.notoSans(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppTheme.destructive,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Chip Button ──────────────────────────────────────────────────────────────
class ChipButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget? icon;
  const ChipButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary.withOpacity(0.1) : AppTheme.card,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? AppTheme.primary : AppTheme.border,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[icon!, const SizedBox(width: 6)],
            KsText(
              label,
              style: GoogleFonts.notoSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? AppTheme.primary : AppTheme.foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Progress Bar ─────────────────────────────────────────────────────────────
class StepProgressBar extends StatelessWidget {
  final int total;
  final int current;
  const StepProgressBar({
    super.key,
    required this.total,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        return Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(left: i == 0 ? 0 : 4),
            decoration: BoxDecoration(
              color: i <= current ? AppTheme.primary : AppTheme.muted,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}

// ─── KS Primary Button ───────────────────────────────────────────────────────
class KsPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final Widget? icon;
  const KsPrimaryButton({
    super.key,
    required this.label,
    this.onTap,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  KsText(label),
                  if (icon != null) ...[const SizedBox(width: 8), icon!],
                ],
              ),
      ),
    );
  }
}

// ─── Status Pill ─────────────────────────────────────────────────────────────
class StatusPill extends StatelessWidget {
  final String status;
  const StatusPill({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (status) {
      'open' => (AppTheme.secondary, AppTheme.secondaryForeground),
      'assigned' => (AppTheme.primary, AppTheme.primaryForeground),
      'in_progress' => (AppTheme.accent, AppTheme.accentForeground),
      'completed' => (AppTheme.success, Colors.white),
      'cancelled' => (AppTheme.muted, AppTheme.mutedForeground),
      _ => (AppTheme.muted, AppTheme.mutedForeground),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: KsText(
        status.replaceAll('_', ' ').toUpperCase(),
        style: GoogleFonts.notoSans(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: fg,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ─── Badge chip ──────────────────────────────────────────────────────────────
class BadgeChip extends StatelessWidget {
  final String badge;
  const BadgeChip({super.key, required this.badge});

  static const Map<String, String> _labels = {
    'first_job': 'First Job',
    'five_jobs': 'Trusted Hands',
    'twenty_jobs': 'Veteran',
    'streak_3': 'On a Roll',
    'streak_7': 'Week Warrior',
    'all_thumbs_up': 'Spotless',
    'verified': 'Aadhaar Verified',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.accent.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppTheme.accent.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.military_tech,
            size: 13,
            color: AppTheme.accentForeground,
          ),
          const SizedBox(width: 5),
          KsText(
            _labels[badge] ?? badge,
            style: GoogleFonts.notoSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppTheme.accentForeground,
            ),
          ),
        ],
      ),
    );
  }
}
