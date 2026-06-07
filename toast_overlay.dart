// lib/widgets/toast_overlay.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum ToastType { success, error, info }

class ToastData {
  final String title;
  final String message;
  final ToastType type;

  const ToastData({
    required this.title,
    required this.message,
    this.type = ToastType.success,
  });
}

class ToastOverlay extends StatefulWidget {
  final Widget child;
  const ToastOverlay({super.key, required this.child});

  static ToastOverlayState of(BuildContext context) =>
      context.findAncestorStateOfType<ToastOverlayState>()!;

  @override
  State<ToastOverlay> createState() => ToastOverlayState();
}

class ToastOverlayState extends State<ToastOverlay>
    with SingleTickerProviderStateMixin {
  ToastData? _toast;
  late final AnimationController _ctrl;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slide = Tween<Offset>(
      begin: const Offset(1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void show(ToastData toast) async {
    setState(() => _toast = toast);
    await _ctrl.forward(from: 0);
    await Future.delayed(const Duration(milliseconds: 3600));
    await _ctrl.reverse();
    if (mounted) setState(() => _toast = null);
  }

  Color get _borderColor {
    switch (_toast?.type) {
      case ToastType.error:
        return AppColors.error;
      case ToastType.info:
        return AppColors.gold;
      default:
        return AppColors.success;
    }
  }

  String get _icon {
    switch (_toast?.type) {
      case ToastType.error:
        return '✕';
      default:
        return '✓';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_toast != null)
          Positioned(
            bottom: 32,
            right: 32,
            child: SlideTransition(
              position: _slide,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 320),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border(
                    left: BorderSide(color: _borderColor, width: 4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 32,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Text(
                      _icon,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _toast!.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: AppColors.text,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _toast!.message,
                            style: const TextStyle(
                              fontSize: 12.8,
                              color: AppColors.muted,
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
      ],
    );
  }
}
