import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/failures.dart';
import '../../domain/entities/address.dart';
import '../controllers/addresses_controller.dart';
import '../controllers/current_location_controller.dart';
import '../controllers/profile_controller.dart';
import '../widgets/current_location_map.dart';

/// Create (address == null) or edit an existing address. The edited address
/// is passed via the router's `extra` (ROUTE-02: navigation by name).
class AddressEditScreen extends ConsumerStatefulWidget {
  const AddressEditScreen({super.key, this.address});

  final Address? address;

  @override
  ConsumerState<AddressEditScreen> createState() => _AddressEditScreenState();
}

class _AddressEditScreenState extends ConsumerState<AddressEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _labelController =
      TextEditingController(text: widget.address?.label);
  late final _recipientController =
      TextEditingController(text: widget.address?.recipientName);
  late final _phoneController =
      TextEditingController(text: widget.address?.phone);
  late final _line1Controller =
      TextEditingController(text: widget.address?.line1);
  late final _line2Controller =
      TextEditingController(text: widget.address?.line2);
  late final _cityController =
      TextEditingController(text: widget.address?.city);

  /// The located fix once "Use my current location" succeeds — drives the
  /// verification map.
  ({double latitude, double longitude})? _locatedCoordinates;

  @override
  void dispose() {
    _labelController.dispose();
    _recipientController.dispose();
    _phoneController.dispose();
    _line1Controller.dispose();
    _line2Controller.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final draft = AddressDraft(
      label: _labelController.text.trim(),
      recipientName: _recipientController.text.trim(),
      phone: _phoneController.text.trim(),
      line1: _line1Controller.text.trim(),
      line2: _line2Controller.text.trim().isEmpty
          ? null
          : _line2Controller.text.trim(),
      city: _cityController.text.trim(),
    );
    await ref
        .read(addressesControllerProvider.notifier)
        .save(draft, addressId: widget.address?.id);
    final hasError = ref.read(addressesControllerProvider).hasError;
    if (!hasError && mounted) context.pop();
  }

  /// One-tap locate (spec B.6): position → reverse geocode → verification
  /// map + prefill. Only fills empty fields — typed values are never
  /// overwritten silently.
  Future<void> _useCurrentLocation() async {
    final notifier = ref.read(currentLocationControllerProvider.notifier);
    final located = await notifier.locate();
    if (!mounted) return;
    if (located == null) {
      final failure = ref.read(currentLocationControllerProvider).error;
      if (failure is! Failure) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(failure.message),
          action: failure is NetworkFailure
              ? SnackBarAction(
                  label: 'Open settings',
                  onPressed: notifier.openSettings,
                )
              : null,
        ));
      return;
    }
    setState(() {
      _locatedCoordinates = (
        latitude: located.latitude,
        longitude: located.longitude,
      );
    });
    var filled = false;
    final address = located.address;
    if (address != null) {
      if (address.line1.isNotEmpty && _line1Controller.text.trim().isEmpty) {
        _line1Controller.text = address.line1;
        filled = true;
      }
      final city = address.city;
      if (city != null && _cityController.text.trim().isEmpty) {
        _cityController.text = city;
        filled = true;
      }
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(switch ((filled, address)) {
          (true, _) =>
            'Filled from your current location — verify the pin and details.',
          (false, null) =>
            "Couldn't determine an address from your location — please enter it manually.",
          (false, _) => 'Address fields already have values — nothing changed.',
        }),
      ));
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = ref.watch(
      addressesControllerProvider.select((async) => async.isLoading),
    );
    final isLocating = ref.watch(
      currentLocationControllerProvider.select((async) => async.isLoading),
    );
    final theme = Theme.of(context);

    ref.listen(addressesControllerProvider, (previous, next) {
      final error = next.hasError ? next.error : null;
      if (error is Failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.message)));
      }
    });
    // New addresses prefill the recipient with the customer's own name once
    // the profile has loaded; the field stays fully editable.
    if (widget.address == null) {
      ref.listen(profileControllerProvider, (_, next) {
        final name = next.value?.fullName ?? '';
        if (name.isNotEmpty && _recipientController.text.isEmpty) {
          _recipientController.text = name;
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.address == null ? 'Add address' : 'Edit address'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ---- Contact: label, recipient (prefilled with the
            // customer's name), phone ----
            Text(
              'Contact',
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _labelController,
              decoration: const InputDecoration(
                labelText: 'Label (e.g. Home, Work)',
                prefixIcon: Icon(Icons.label_outline),
              ),
              validator: (value) =>
                  (value == null || value.trim().isEmpty)
                      ? 'Enter a label'
                      : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _recipientController,
              decoration: const InputDecoration(
                labelText: 'Recipient name',
                prefixIcon: Icon(Icons.person_outline),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) =>
                  (value == null || value.trim().isEmpty)
                      ? 'Enter the recipient name'
                      : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              keyboardType: TextInputType.phone,
            ),
            const Divider(height: 32),
            // ---- Location: one-tap fix + verification map + street
            // details ----
            Text(
              'Location',
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: isLocating ? null : _useCurrentLocation,
              icon: isLocating
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.my_location_outlined),
              label: const Text('Use my current location'),
            ),
            if (_locatedCoordinates != null) ...[
              const SizedBox(height: 12),
              CurrentLocationMap(
                latitude: _locatedCoordinates!.latitude,
                longitude: _locatedCoordinates!.longitude,
              ),
              const SizedBox(height: 4),
              Text(
                'Verify the pin matches your location — then review the '
                'fields below.',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
            const SizedBox(height: 12),
            TextFormField(
              controller: _line1Controller,
              decoration: const InputDecoration(
                labelText: 'Address line 1',
                prefixIcon: Icon(Icons.home_outlined),
              ),
              validator: (value) =>
                  (value == null || value.trim().isEmpty)
                      ? 'Enter the street address'
                      : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _line2Controller,
              decoration: const InputDecoration(
                labelText: 'Address line 2 (optional)',
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'City',
                prefixIcon: Icon(Icons.location_city_outlined),
              ),
              validator: (value) =>
                  (value == null || value.trim().isEmpty)
                      ? 'Enter the city'
                      : null,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: isSaving ? null : _save,
              child: isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
