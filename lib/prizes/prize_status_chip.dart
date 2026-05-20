import 'package:flutter/material.dart';

import '../data/app_database.dart';

class PrizeStatusChip extends StatelessWidget {
  const PrizeStatusChip({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final colors = _colorsFor(context, status);
    return Chip(
      label: Text(PrizeStatus.label(status)),
      backgroundColor: colors.background,
      side: BorderSide(color: colors.border),
      visualDensity: VisualDensity.compact,
      labelStyle: TextStyle(
        color: colors.foreground,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  _StatusColors _colorsFor(BuildContext context, String status) {
    return switch (status) {
      PrizeStatus.owned => _StatusColors(
        background: Colors.green.shade100,
        foreground: Colors.green.shade900,
        border: Colors.green.shade400,
      ),
      PrizeStatus.reserved => _StatusColors(
        background: Colors.amber.shade100,
        foreground: Colors.orange.shade900,
        border: Colors.amber.shade500,
      ),
      PrizeStatus.skipped => _StatusColors(
        background: Colors.red.shade100,
        foreground: Colors.red.shade900,
        border: Colors.red.shade400,
      ),
      _ => _StatusColors(
        background: Colors.blueGrey.shade100,
        foreground: Colors.blueGrey.shade900,
        border: Colors.blueGrey.shade400,
      ),
    };
  }
}

class _StatusColors {
  const _StatusColors({
    required this.background,
    required this.foreground,
    required this.border,
  });

  final Color background;
  final Color foreground;
  final Color border;
}
