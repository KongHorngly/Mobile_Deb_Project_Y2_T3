import 'package:flutter/material.dart';
import '../models/history_model.dart';
import 'risk_badge.dart';

/// A single row in the History list (sender/subject + verdict + arrow).
class HistoryTile extends StatelessWidget {
  final HistoryItem item;
  final VoidCallback onTap;

  const HistoryTile({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.shield_outlined),
      title: Text(item.title, overflow: TextOverflow.ellipsis),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RiskBadge(label: item.verdictLabel, isSafe: item.isSafe),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, size: 18),
        ],
      ),
      onTap: onTap,
    );
  }
}
