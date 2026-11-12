import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// Menjaga layar tetap menyala selama widget ini tampil (kalau [enabled]).
class KeepScreenAwake extends StatefulWidget {
  const KeepScreenAwake({
    super.key,
    required this.enabled,
    required this.child,
  });

  final bool enabled;
  final Widget child;

  @override
  State<KeepScreenAwake> createState() => _KeepScreenAwakeState();
}

class _KeepScreenAwakeState extends State<KeepScreenAwake> {
  @override
  void initState() {
    super.initState();
    if (widget.enabled) unawaited(WakelockPlus.enable());
  }

  @override
  void dispose() {
    if (widget.enabled) unawaited(WakelockPlus.disable());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
