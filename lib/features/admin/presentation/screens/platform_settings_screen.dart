import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/widgets/content_width.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/money.dart';
import '../../../../core/presentation/widgets/app_snack_bar.dart';
import '../../domain/entities/admin.dart';
import '../controllers/admin_settings_controller.dart';

/// Admin — platform settings editor (spec §47): delivery fee, commissions,
/// payment account. Server-side, these drive checkout pricing.
class PlatformSettingsScreen extends ConsumerStatefulWidget {
  const PlatformSettingsScreen({super.key});

  @override
  ConsumerState<PlatformSettingsScreen> createState() =>
      _PlatformSettingsScreenState();
}

class _PlatformSettingsScreenState
    extends ConsumerState<PlatformSettingsScreen> {
  final _feeController = TextEditingController();
  final _platformCommissionController = TextEditingController();
  final _paymentAccountController = TextEditingController();
  bool _filled = false;
  bool _saving = false;

  @override
  void dispose() {
    _feeController.dispose();
    _platformCommissionController.dispose();
    _paymentAccountController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    int feeMinor;
    try {
      feeMinor = Money.parse(_feeController.text).minorUnits;
    } on FormatException {
      feeMinor = -1;
    }
    final platformCommission = int.tryParse(_platformCommissionController.text) ?? -1;
    if (feeMinor < 0 || platformCommission < 0 || platformCommission > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const AppSnackBar(content: Text('Check the values (commissions 0-100)')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final error =
          await ref.read(adminSettingsControllerProvider.notifier).save(
                PlatformSettings(
                  deliveryFeeMinor: feeMinor,
                  platformCommissionPercent: platformCommission,
                  paymentAccount: _paymentAccountController.text.trim(),
                ),
              );
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          AppSnackBar(
            content: Text(
              error == null ? 'Settings saved' : userMessageFor(error),
            ),
          ),
        );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(adminSettingsControllerProvider);

    ref.listen(adminSettingsControllerProvider, (previous, next) {
      final error = next.hasError ? next.error : null;
      if (error is Failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(AppSnackBar(content: Text(userMessageFor(error))));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Platform settings')),
      body: ContentWidth(
        child: settingsAsync.when(
        skipLoadingOnReload: true,
        skipLoadingOnRefresh: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(userMessageFor(error))),
        data: (settings) {
          if (!_filled) {
            _feeController.text =
                (settings.deliveryFeeMinor / 100).toStringAsFixed(2);
            _platformCommissionController.text =
                '${settings.platformCommissionPercent}';
            _paymentAccountController.text = settings.paymentAccount;
            _filled = true;
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                controller: _feeController,
                decoration: const InputDecoration(
                  labelText: 'Delivery fee',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _platformCommissionController,
                decoration: const InputDecoration(
                  labelText: 'Platform commission (%)',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _paymentAccountController,
                decoration: const InputDecoration(
                  labelText: 'Platform payment account (for transfers)',
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save'),
              ),
            ],
          );
        },
      ),
      ),
    );
  }
}
