import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../app/theme/app_colors.dart';

// ─── CyberButton ──────────────────────────────────────────────────────────────
class CyberButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color color;
  final bool isLoading;
  final double? width;
  final IconData? icon;

  const CyberButton({
    super.key,
    required this.text,
    this.onPressed,
    this.color = AppColors.primary,
    this.isLoading = false,
    this.width,
    this.icon,
  });

  @override
  State<CyberButton> createState() => _CyberButtonState();
}

class _CyberButtonState extends State<CyberButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: 200.ms,
        width: widget.width ?? double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: widget.color.withOpacity(_hovered ? 0.15 : 0.05),
          border: Border.all(
            color: widget.color.withOpacity(_hovered ? 1.0 : 0.7),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(4),
          boxShadow: _hovered
              ? [BoxShadow(color: widget.color.withOpacity(0.4), blurRadius: 12, spreadRadius: 1)]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: widget.isLoading ? null : widget.onPressed,
            child: Center(
              child: widget.isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: widget.color,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon, color: widget.color, size: 18),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          widget.text.toUpperCase(),
                          style: TextStyle(
                            color: widget.color,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── GlowButton ───────────────────────────────────────────────────────────────
class GlowButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color color;
  final bool isLoading;

  const GlowButton({
    super.key,
    required this.text,
    this.onPressed,
    this.color = AppColors.primary,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          elevation: 0,
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) return Colors.white24;
            return null;
          }),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
              )
            : Text(
                text.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 13),
              ),
      ),
    );
  }
}

// ─── DangerButton ─────────────────────────────────────────────────────────────
class DangerButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const DangerButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CyberButton(text: text, onPressed: onPressed, color: AppColors.error);
  }
}

// ─── CyberCard ────────────────────────────────────────────────────────────────
class CyberCard extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  final VoidCallback? onTap;
  final EdgeInsets? padding;

  const CyberCard({
    super.key,
    required this.child,
    this.borderColor = const Color(0xFF2A2A2A),
    this.onTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: 1),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color(0xFF181818), Colors.black.withOpacity(0.9)],
          ),
        ),
        child: child,
      ),
    );
  }
}

// ─── XPCard ───────────────────────────────────────────────────────────────────
class XPCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const XPCard({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            Text(label,
                style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                    letterSpacing: 1.2)),
          ],
        ),
      ),
    );
  }
}

// ─── CyberTextField ───────────────────────────────────────────────────────────
class CyberTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final IconData? prefixIcon;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final int? maxLength;

  const CyberTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.prefixIcon,
    this.suffix,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      maxLength: maxLength,
      style: const TextStyle(color: AppColors.textPrimary, fontFamily: 'monospace'),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        counterText: '',
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.primary, size: 20)
            : null,
        suffix: suffix,
      ),
    );
  }
}

// ─── LoadingWidget ────────────────────────────────────────────────────────────
class LoadingWidget extends StatelessWidget {
  final String? message;
  const LoadingWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(message!,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          ],
        ],
      ),
    );
  }
}

// ─── ErrorDisplayWidget ───────────────────────────────────────────────────────
class ErrorDisplayWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorDisplayWidget({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 48),
            const SizedBox(height: 16),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary)),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              CyberButton(text: 'RETRY', onPressed: onRetry, color: AppColors.error, width: 160),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── HackerAvatar ─────────────────────────────────────────────────────────────
class HackerAvatar extends StatelessWidget {
  final double radius;
  final String? initials;
  final Color color;

  const HackerAvatar({
    super.key,
    this.radius = 30,
    this.initials,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.1),
        border: Border.all(color: color, width: 2),
        boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 10)],
      ),
      child: Center(
        child: initials != null
            ? Text(initials!,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: radius * 0.6))
            : Icon(Icons.person, color: color, size: radius),
      ),
    );
  }
}

// ─── SectionHeader ────────────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? trailing;
  final VoidCallback? onTrailingTap;
  final Color color;

  const SectionHeader({
    super.key,
    required this.title,
    this.trailing,
    this.onTrailingTap,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(width: 3, height: 16, color: color),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        if (trailing != null)
          GestureDetector(
            onTap: onTrailingTap,
            child: Text(
              trailing!,
              style: TextStyle(color: color.withOpacity(0.7), fontSize: 12),
            ),
          ),
      ],
    );
  }
}

// ─── TerminalBox ──────────────────────────────────────────────────────────────
class TerminalBox extends StatelessWidget {
  final String content;
  final Color textColor;

  const TerminalBox({
    super.key,
    required this.content,
    this.textColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Text(
        content,
        style: TextStyle(
          fontFamily: 'monospace',
          color: textColor,
          fontSize: 13,
          height: 1.6,
        ),
      ),
    );
  }
}
