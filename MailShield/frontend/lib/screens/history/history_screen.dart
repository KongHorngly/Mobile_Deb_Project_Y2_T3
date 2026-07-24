import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../models/history_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/history_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/history_tile.dart';
import '../../widgets/risk_badge.dart';

// Covers History list, History detail 
// tapping a tile shows the detail view, backed by [HistoryProvider].

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uid = context.read<AuthProvider>().currentUser?.id;
      if (uid != null) {
        context.read<HistoryProvider>().loadHistory(uid);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _deleteSelected() async {
    final uid = context.read<AuthProvider>().currentUser?.id;
    if (uid == null) return;
    await context.read<HistoryProvider>().deleteSelected(uid);
  }

  @override
  Widget build(BuildContext context) {
    final historyProvider = context.watch<HistoryProvider>();
    final selected = historyProvider.selected;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (selected != null) {
                          historyProvider.clearSelection();
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(Icons.arrow_back_ios, size: 18),
                    ),
                    const Text(
                      AppStrings.history,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: selected == null
                    ? _buildList(historyProvider)
                    : _buildDetail(selected),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(HistoryProvider historyProvider) {
    if (historyProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          CustomTextField(
            controller: _searchController,
            hintText: AppStrings.searchHistory,
            suffixIcon: const Icon(Icons.search, size: 20),

          ),
          const SizedBox(height: 4),
          Expanded(
            child: Card(
              child: historyProvider.items.isEmpty
                  ? const Center(child: Text('No scans yet'))
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: historyProvider.items.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = historyProvider.items[index];
                        return HistoryTile(
                          item: item,
                          onTap: () => historyProvider.select(item),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetail(HistoryItem item) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.title),
                  Text(
                    '${item.scannedAt.day} '
                    '${_monthName(item.scannedAt.month)} '
                    '${item.scannedAt.year}, '
                    '${item.scannedAt.hour.toString().padLeft(2, '0')}:'
                    '${item.scannedAt.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    AppStrings.emailVerdict,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  RiskBadge(label: item.verdictLabel, isSafe: item.isSafe),
                ],
              ),
              if (item.sender != null) ...[
                const SizedBox(height: 12),
                const Text(
                  AppStrings.imageInformation,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text('Sender: ${item.sender}'),
                Text('Subject: ${item.subject}'),
                Text('Image: ${item.fileOrImageName}'),
                const SizedBox(height: 12),
                const Text(
                  AppStrings.securityCheck,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text('${AppStrings.senderDomain} ${item.senderDomainStatus}'),
                Text(
                  '${AppStrings.suspiciousWords} ${item.suspiciousWordsFound! ? 'Found' : 'Not found'}',
                ),
                Text(
                  '${AppStrings.maliciousLinks} ${item.maliciousLinksFound! ? 'Found' : 'Not found'}',
                ),
                const SizedBox(height: 12),
                const Text(
                  AppStrings.recommendation,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...?item.recommendations?.map((r) => Text('• $r')),
              ],
              const SizedBox(height: 20),
              CustomButton(
                label: AppStrings.deleteHistory,
                type: ButtonStyleType.red,
                onPressed: _deleteSelected,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  String _monthName(int month) {
    const names = [
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
    return names[month - 1];
  }
}
