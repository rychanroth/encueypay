import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/money.dart';
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
  final _driverCommissionController = TextEditingController();
  final _paymentAccountController = TextEditingController();
  bool _filled = false;

  @override
  void dispose() {
    _feeController.dispose();
    _platformCommissionController.dispose();
    _driverCommissionController.dispose();
    _paymentAccountController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    int feeMinor;
    try {
      feeMinor = Money.parse(_feeController.text).minorUnits;
    } on FormatException {
      feeMinor = -1;
    }
    final platformCommission = int.tryParse(_platformCommissionController.text) ?? -1;
    final driverCommission = int.tryParse(_driverCommissionController.text) ?? -1;
    if (feeMinor < 0 ||
        platformCommission < 0 ||
        platformCommission > 100 ||
        driverCommission < 0 ||
        driverCommission > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Check the values (commissions 0-100)')),
      );
      return;
    }
    await ref.read(adminSettingsControllerProvider.notifier).save(
          PlatformSettings(
            deliveryFeeMinor: feeMinor,
            platformCommissionPercent: platformCommission,
            driverCommissionPercent: driverCommission,
            paymentAccount: _paymentAccountController.text.trim(),
          ),
        );
    final hasError = ref.read(adminSettingsControllerProvider).hasError;
    if (!hasError && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings saved')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(adminSettingsControllerProvider);
    final saving = ref.watch(
      adminSettingsControllerProvider.select((async) => async.isLoading),
    );

    ref.listen(adminSettingsControllerProvider, (previous, next) {
      final error = next.hasError ? next.error : null;
      if (error is Failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.message)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Platform settings')),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (settings) {
          if (!_filled) {
            _feeController.text =
                (settings.deliveryFeeMinor / 100).toStringAsFixed(2);
            _platformCommissionController.text =
                '${settings.platformCommissionPercent}';
            _driverCommissionController.text =
                '${settings.driverCommissionPercent}';
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
                controller: _driverCommissionController,
                decoration: const InputDecoration(
                  labelText: 'Driver commission share (%)',
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
                onPressed: saving ? null : _save,
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }
}
