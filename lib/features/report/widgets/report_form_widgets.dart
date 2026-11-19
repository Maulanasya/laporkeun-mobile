import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/report_draft.dart';

class RK {
  static const navy = Color(0xFF0B3047);
  static const teal = Color(0xFF17707E);
  static const tealSoft = Color(0xFF5FA8B0);
  static const muted = Color(0xFF5F7A88);
  static const error = Color(0xFFB3384A);

  static const peach = Color(0xFFFFDCC8);
  static const mint = Color(0xFFCDEBE6);
  static const sun = Color(0xFFFFE9AE);
  static const rose = Color(0xFFF2D1DB);

  static Color white(double opacity) =>
      Color.fromRGBO(255, 255, 255, opacity);

  static Color tint(Color c, double opacity) =>
      c.withAlpha((opacity * 255).round());
}

class RkBackground extends StatelessWidget {
  const RkBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFD3CAEE),
            Color(0xFFEBD4E4),
            Color(0xFFCBE9E6),
            Color(0xFFFFDCC9),
          ],
          stops: [0, 0.35, 0.7, 1],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 70,
            right: -30,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: RK.white(0.25),
              ),
              alignment: Alignment.center,
              child: Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFFF6E3),
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.radius = 28,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius);
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: RK.tint(RK.navy, 0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [RK.white(0.62), RK.white(0.28)],
              ),
              border: Border.all(color: RK.white(0.75), width: 1.2),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.number,
    required this.title,
    this.subtitle,
    this.color = RK.peach,
  });

  final int number;
  final String title;
  final String? subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: RK.white(0.9), width: 2),
          ),
          alignment: Alignment.center,
          child: Text(
            '$number',
            style: const TextStyle(
              color: RK.navy,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: RK.navy,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    color: RK.muted,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class RkField extends StatelessWidget {
  const RkField({
    super.key,
    required this.label,
    required this.hint,
    this.icon,
    this.controller,
    this.validator,
    this.minLines = 1,
    this.maxLines = 1,
    this.maxLength,
    this.readOnly = false,
    this.onTap,
    this.textInputAction,
    this.suffix,
  });

  final String label;
  final String hint;
  final IconData? icon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int minLines;
  final int maxLines;
  final int? maxLength;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputAction? textInputAction;
  final Widget? suffix;

  OutlineInputBorder _border(Color color, [double width = 1.2]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(maxLines > 1 ? 24 : 28),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: RK.navy,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          minLines: minLines,
          maxLines: maxLines,
          maxLength: maxLength,
          readOnly: readOnly,
          onTap: onTap,
          textInputAction: textInputAction,
          textCapitalization: TextCapitalization.sentences,
          style: const TextStyle(color: RK.navy, fontSize: 15, height: 1.4),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: RK.tint(RK.muted, 0.8), fontSize: 15),
            prefixIcon: icon == null ? null : Icon(icon, color: RK.teal),
            suffixIcon: suffix,
            filled: true,
            fillColor: RK.white(0.6),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            border: _border(RK.white(0.9)),
            enabledBorder: _border(RK.white(0.9)),
            focusedBorder: _border(RK.teal, 1.6),
            errorBorder: _border(RK.error),
            focusedErrorBorder: _border(RK.error, 1.6),
            errorStyle: const TextStyle(color: RK.error, fontSize: 12.5),
            counterStyle: const TextStyle(color: RK.muted, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

/// Pilihan kategori kasus.
class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final ReportCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: category.label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: selected ? RK.white(0.92) : RK.white(0.5),
            border: Border.all(
              color: selected ? RK.teal : RK.white(0.9),
              width: selected ? 2 : 1.2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: category.color,
                      shape: BoxShape.circle,
                      border: Border.all(color: RK.white(0.9), width: 2),
                    ),
                    child: Icon(category.icon, color: RK.navy, size: 22),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 180),
                    opacity: selected ? 1 : 0,
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: RK.teal,
                      size: 22,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                category.label,
                style: const TextStyle(
                  color: RK.navy,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                category.description,
                style: const TextStyle(
                  color: RK.muted,
                  fontSize: 12,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IdentityOption extends StatelessWidget {
  const IdentityOption({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: title,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: selected ? RK.white(0.92) : RK.white(0.5),
            border: Border.all(
              color: selected ? RK.teal : RK.white(0.9),
              width: selected ? 2 : 1.2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: selected ? RK.teal : RK.mint,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: selected ? Colors.white : RK.navy,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: RK.navy,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: const TextStyle(
                        color: RK.muted,
                        fontSize: 12.5,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                selected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: selected ? RK.teal : RK.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RkPrimaryButton extends StatelessWidget {
  const RkPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: RK.navy,
          foregroundColor: Colors.white,
          disabledBackgroundColor: RK.tint(RK.navy, 0.55),
          disabledForegroundColor: Colors.white,
          elevation: 0,
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.6,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(label),
                ],
              ),
      ),
    );
  }
}