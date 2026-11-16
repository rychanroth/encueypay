import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/content_width.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../domain/entities/address.dart';
import '../../domain/entities/administrative_unit.dart';
import '../../domain/entities/located_address.dart';
import '../../domain/entities/user_profile.dart';
import '../controllers/addresses_controller.dart';
import '../controllers/current_location_controller.dart';
import '../controllers/geo_controllers.dart';
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
  late final _labelController = TextEditingController(
    text: widget.address?.label,
  );
  late final _recipientController = TextEditingController(
    text: widget.address?.recipientName,
  );
  late final _phoneController = TextEditingController(
    text: widget.address?.phone,
  );
  late final _line1Controller = TextEditingController(
    text: widget.address?.line1,
  );
  late final _line2Controller = TextEditingController(
    text: widget.address?.line2,
  );
  late final _cityController = TextEditingController(
    text: widget.address?.city,
  );

  /// The located fix once "Use my current location" succeeds — drives the
  /// verification map and is persisted with the address. On a failed web
  /// lookup the map starts at the Phnom Penh centre and the customer places
  /// the pin by tapping.
  ({double latitude, double longitude})? _locatedCoordinates;

  /// Guards map-tap reverse-geocode races: a slower earlier lookup must not
  /// overwrite a newer pin.
  int _mapLookupToken = 0;

  /// Why the last locate attempt failed — rendered inline (persistent) so the
  /// customer can read it, retry, or fall back to the map. Null when idle or
  /// successful.
  String? _locationError;

  static const _fallbackLatitude = 11.5564;
  static const _fallbackLongitude = 104.9282;

  List<AdministrativeUnit> _provinces = const [];
  List<AdministrativeUnit> _districts = const [];
  List<AdministrativeUnit> _communes = const [];
  List<AdministrativeUnit> _villages = const [];
  String? _provinceCode;
  String? _districtCode;
  String? _communeCode;
  String? _villageCode;
  bool _loadingGeo = false;
  String? _geoError;

  /// New-address contact prefill: fills empty fields once from the profile.
  ProviderSubscription<AsyncValue<UserProfile>>? _profileSubscription;
  bool _profilePrefillDone = false;

  @override
  void initState() {
    super.initState();
    _provinceCode = widget.address?.provinceCode;
    _districtCode = widget.address?.districtCode;
    _communeCode = widget.address?.communeCode;
    _villageCode = widget.address?.villageCode;
    if (widget.address == null) {
      // fireImmediately covers a profile that was already loaded before
      // this screen opened; the empty checks preserve anything the user
      // has already typed.
      _profileSubscription = ref.listenManual(
        profileControllerProvider,
        (_, next) => _prefillContactFromProfile(next.value),
        fireImmediately: true,
      );
    }
    _hydrateGeo();
  }

  void _prefillContactFromProfile(UserProfile? profile) {
    if (_profilePrefillDone || profile == null) return;
    _profilePrefillDone = true;
    final name = profile.fullName.trim();
    final phone = profile.phone?.trim() ?? '';
    if (name.isNotEmpty && _recipientController.text.trim().isEmpty) {
      _recipientController.text = name;
    }
    if (phone.isNotEmpty && _phoneController.text.trim().isEmpty) {
      _phoneController.text = phone;
    }
  }

  @override
  void dispose() {
    _profileSubscription?.close();
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
    final hasAnyCode = [
      _provinceCode,
      _districtCode,
      _communeCode,
      _villageCode,
    ].any((code) => code != null);
    final hasAllCodes =
        _provinceCode != null &&
        _districtCode != null &&
        _communeCode != null &&
        _villageCode != null;
    if (hasAnyCode && !hasAllCodes) {
      _showSnack(
        'Select province/city, district/khan, commune/sangkat, '
        'and village/phum.',
      );
      return;
    }
    if (widget.address == null && !hasAllCodes) {
      _showSnack('Select the administrative area.');
      return;
    }
    final city = hasAllCodes ? _composeCity() : _cityController.text.trim();
    if (city.isEmpty) {
      _showSnack('Select the administrative area.');
      return;
    }
    final draft = AddressDraft(
      label: _labelController.text.trim(),
      recipientName: _recipientController.text.trim(),
      phone: _phoneController.text.trim(),
      line1: _line1Controller.text.trim(),
      line2: _line2Controller.text.trim().isEmpty
          ? null
          : _line2Controller.text.trim(),
      city: city,
      provinceCode: _provinceCode,
      districtCode: _districtCode,
      communeCode: _communeCode,
      villageCode: _villageCode,
      latitude: _locatedCoordinates?.latitude ?? widget.address?.latitude,
      longitude: _locatedCoordinates?.longitude ?? widget.address?.longitude,
    );
    await ref
        .read(addressesControllerProvider.notifier)
        .save(draft, addressId: widget.address?.id);
    final hasError = ref.read(addressesControllerProvider).hasError;
    if (!hasError && mounted) context.pop();
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _hydrateGeo() async {
    try {
      final provinces = await ref.read(geoProvincesProvider.future);
      if (!mounted) return;
      final province = _hasCode(provinces, _provinceCode)
          ? _provinceCode
          : null;
      setState(() {
        _provinces = provinces;
        _provinceCode = province;
        _geoError = null;
        if (province == null) {
          _districtCode = null;
          _communeCode = null;
          _villageCode = null;
        }
      });
      if (province == null) return;
      await _loadDistricts(province, selectCode: _districtCode);
      final district = _districtCode;
      if (district == null) return;
      await _loadCommunes(province, district, selectCode: _communeCode);
      final commune = _communeCode;
      if (commune == null) return;
      await _loadVillages(
        province,
        district,
        commune,
        selectCode: _villageCode,
      );
    } on Failure catch (failure) {
      if (!mounted) return;
      setState(() => _geoError = userMessageFor(failure));
    }
  }

  Future<void> _loadDistricts(String provinceCode, {String? selectCode}) async {
    setState(() => _loadingGeo = true);
    try {
      final list = await ref.read(geoDistrictsProvider(provinceCode).future);
      if (!mounted || _provinceCode != provinceCode) return;
      setState(() {
        _districts = list;
        _districtCode = _hasCode(list, selectCode) ? selectCode : null;
        _communes = const [];
        _communeCode = null;
        _villages = const [];
        _villageCode = null;
      });
    } on Failure catch (failure) {
      _showSnack(failure.message);
    } finally {
      if (mounted) setState(() => _loadingGeo = false);
    }
  }

  Future<void> _loadCommunes(
    String provinceCode,
    String districtCode, {
    String? selectCode,
  }) async {
    setState(() => _loadingGeo = true);
    try {
      final list = await ref.read(
        geoCommunesProvider(provinceCode, districtCode).future,
      );
      if (!mounted) return;
      setState(() {
        _communes = list;
        _communeCode = _hasCode(list, selectCode) ? selectCode : null;
        _villages = const [];
        _villageCode = null;
      });
    } on Failure catch (failure) {
      _showSnack(failure.message);
    } finally {
      if (mounted) setState(() => _loadingGeo = false);
    }
  }

  Future<void> _loadVillages(
    String provinceCode,
    String districtCode,
    String communeCode, {
    String? selectCode,
  }) async {
    setState(() => _loadingGeo = true);
    try {
      final list = await ref.read(
        geoVillagesProvider(provinceCode, districtCode, communeCode).future,
      );
      if (!mounted ||
          _provinceCode != provinceCode ||
          _districtCode != districtCode ||
          _communeCode != communeCode) {
        return;
      }
      setState(() {
        _villages = list;
        _villageCode = _hasCode(list, selectCode) ? selectCode : null;
      });
    } on Failure catch (failure) {
      _showSnack(failure.message);
    } finally {
      if (mounted) setState(() => _loadingGeo = false);
    }
  }

  Future<void> _onProvinceChanged(String? code) async {
    setState(() {
      _provinceCode = code;
      _districtCode = null;
      _communeCode = null;
      _villageCode = null;
      _districts = const [];
      _communes = const [];
      _villages = const [];
    });
    if (code != null) await _loadDistricts(code);
  }

  Future<void> _onDistrictChanged(String? code) async {
    setState(() {
      _districtCode = code;
      _communeCode = null;
      _villageCode = null;
      _communes = const [];
      _villages = const [];
    });
    final province = _provinceCode;
    if (province != null && code != null) {
      await _loadCommunes(province, code);
    }
  }

  Future<void> _onCommuneChanged(String? code) async {
    setState(() {
      _communeCode = code;
      _villageCode = null;
      _villages = const [];
    });
    final province = _provinceCode;
    final district = _districtCode;
    if (province != null && district != null && code != null) {
      await _loadVillages(province, district, code);
    }
  }

  void _onVillageChanged(String? code) {
    setState(() => _villageCode = code);
  }

  Future<void> _applyDetectedHierarchy(LocatedAddress located) async {
    final province = located.provinceCode;
    if (province == null) return;
    setState(() => _loadingGeo = true);
    try {
      final districts = await ref.read(geoDistrictsProvider(province).future);
      final district = _hasCode(districts, located.districtCode)
          ? located.districtCode
          : null;
      final communes = district == null
          ? const <AdministrativeUnit>[]
          : await ref.read(geoCommunesProvider(province, district).future);
      final commune = _hasCode(communes, located.communeCode)
          ? located.communeCode
          : null;
      final villages = district == null || commune == null
          ? const <AdministrativeUnit>[]
          : await ref.read(
              geoVillagesProvider(province, district, commune).future,
            );
      final village = _hasCode(villages, located.villageCode)
          ? located.villageCode
          : null;
      if (!mounted) return;
      setState(() {
        _provinceCode = province;
        _districts = districts;
        _districtCode = district;
        _communes = communes;
        _communeCode = commune;
        _villages = villages;
        _villageCode = village;
      });
    } on Failure catch (failure) {
      _showSnack(failure.message);
    } finally {
      if (mounted) setState(() => _loadingGeo = false);
    }
  }

  static bool _hasCode(List<AdministrativeUnit> units, String? code) {
    if (code == null) return false;
    return units.any((unit) => unit.code == code);
  }

  static AdministrativeUnit? _unitByCode(
    List<AdministrativeUnit> units,
    String? code,
  ) {
    if (code == null) return null;
    for (final unit in units) {
      if (unit.code == code) return unit;
    }
    return null;
  }

  String _composeCity() {
    final parts = [
      _unitByCode(_villages, _villageCode)?.nameEn,
      _unitByCode(_communes, _communeCode)?.nameEn,
      _unitByCode(_districts, _districtCode)?.nameEn,
      _unitByCode(_provinces, _provinceCode)?.nameEn,
    ].whereType<String>().where((part) => part.isNotEmpty).toList();
    return parts.isEmpty ? _cityController.text.trim() : parts.join(', ');
  }

  /// One-tap locate (spec B.6): position → reverse geocode → verification
  /// map + prefill. Only fills empty fields — typed values are never
  /// overwritten silently.
  Future<void> _useCurrentLocation() async {
    if (_locationError != null) setState(() => _locationError = null);
    final notifier = ref.read(currentLocationControllerProvider.notifier);
    final located = await notifier.locate();
    if (!mounted) return;
    if (located == null) {
      final failure = ref.read(currentLocationControllerProvider).error;
      // Browser geolocation is optional (insecure origin, no provider, user
      // denied). Keep the form usable: drop a pin at the city centre so the
      // customer can tap the map to place it manually. The reason stays on
      // screen (not a transient snackbar) with a retry action.
      if (failure != null && failure is! Failure) {
        // Should be unreachable (the repository maps every error); keep the
        // type visible for diagnosis instead of hiding the real defect.
        debugPrint('[location] unexpected state error: $failure');
      }
      setState(() {
        _locationError = failure is Failure
            ? failure.message
            : failure == null
                ? 'Location is unavailable.'
                : 'Location is unavailable (${failure.runtimeType}).';
        _locatedCoordinates ??= (
          latitude: _fallbackLatitude,
          longitude: _fallbackLongitude,
        );
      });
      return;
    }
    setState(() {
      _locationError = null;
      _locatedCoordinates = (
        latitude: located.latitude,
        longitude: located.longitude,
      );
    });
    final address = located.address;
    final filled = await _applyLocatedAddress(address);
    if (!mounted) return;
    final levels = address?.matchedLevels ?? 0;
    _showSnack(
      switch ((filled, address)) {
        (true, _) when levels > 0 =>
          'Detected $levels administrative level(s) — verify the pin and '
              'selections before saving.',
        (true, _) =>
          'Filled from your current location — verify the pin and details.',
        (false, null) =>
          "Couldn't determine an address from your location — tap the map or "
              'enter it manually.',
        (false, _) => 'Address fields already have values — nothing changed.',
      },
    );
  }

  /// Applies a reverse-geocoded suggestion to the fields, never overwriting
  /// values the customer already typed. Returns whether anything changed.
  Future<bool> _applyLocatedAddress(LocatedAddress? address) async {
    if (address == null) return false;
    var filled = false;
    if (address.line1.isNotEmpty && _line1Controller.text.trim().isEmpty) {
      _line1Controller.text = address.line1;
      filled = true;
    }
    final noHierarchyYet = _provinceCode == null &&
        _districtCode == null &&
        _communeCode == null &&
        _villageCode == null;
    if (address.provinceCode != null && noHierarchyYet) {
      await _applyDetectedHierarchy(address);
      filled = true;
    } else if (address.city != null && _cityController.text.trim().isEmpty) {
      _cityController.text = address.city!;
      filled = true;
    }
    return filled;
  }

  /// Tap-to-place fallback: the pin moves immediately and the new point is
  /// reverse-geocoded best-effort. A slow lookup cannot overwrite a newer tap
  /// (guarded by [_mapLookupToken]).
  Future<void> _onMapPositionChanged(
    ({double latitude, double longitude}) position,
  ) async {
    final token = ++_mapLookupToken;
    setState(() {
      _locatedCoordinates = position;
      _locationError = null;
    });
    final address = await ref
        .read(currentLocationControllerProvider.notifier)
        .reverseGeocodeAt(
          latitude: position.latitude,
          longitude: position.longitude,
        );
    if (!mounted || token != _mapLookupToken || address == null) return;
    final filled = await _applyLocatedAddress(address);
    if (!mounted || token != _mapLookupToken) return;
    if (filled) {
      _showSnack('Updated from the pin — verify the fields before saving.');
    }
  }

  Widget _adminDropdown({
    required String label,
    required List<AdministrativeUnit> units,
    required String? value,
    required ValueChanged<String?>? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: _hasCode(units, value) ? value : null,
            hint: Text('Select ${label.toLowerCase()}'),
            icon: const Icon(Icons.expand_more),
            items: [
              for (final unit in units)
                DropdownMenuItem(
                  value: unit.code,
                  child: Text(
                    unit.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
            onChanged: onChanged,
          ),
        ),
      ),
    );
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
          ..showSnackBar(SnackBar(content: Text(userMessageFor(error))));
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.address == null ? 'Add address' : 'Edit address'),
      ),
      body: ContentWidth(
        child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ---- Contact: label, recipient + phone (prefilled from the
            // customer's profile for new addresses) ----
            Text(
              'Contact',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _labelController,
              decoration: const InputDecoration(
                labelText: 'Label (e.g. Home, Work)',
                prefixIcon: Icon(Icons.label_outline),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
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
              validator: (value) => (value == null || value.trim().isEmpty)
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
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
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
            if (_locationError != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.sm + 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: AppRadii.br12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_off_outlined,
                          size: 18,
                          color: theme.colorScheme.onErrorContainer,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            'Location unavailable',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.colorScheme.onErrorContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      _locationError!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: isLocating ? null : _useCurrentLocation,
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Try again'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (_locatedCoordinates != null) ...[
              const SizedBox(height: 12),
              CurrentLocationMap(
                latitude: _locatedCoordinates!.latitude,
                longitude: _locatedCoordinates!.longitude,
                onPositionChanged: _onMapPositionChanged,
              ),
              const SizedBox(height: 4),
              Text(
                'Tap the map to adjust the pin, then review the fields below.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 12),
            _adminDropdown(
              label: 'Province / City',
              units: _provinces,
              value: _provinceCode,
              onChanged: _loadingGeo ? null : _onProvinceChanged,
            ),
            _adminDropdown(
              label: 'District / Khan / Krong',
              units: _districts,
              value: _districtCode,
              onChanged: _loadingGeo || _provinceCode == null
                  ? null
                  : _onDistrictChanged,
            ),
            _adminDropdown(
              label: 'Commune / Sangkat',
              units: _communes,
              value: _communeCode,
              onChanged: _loadingGeo || _districtCode == null
                  ? null
                  : _onCommuneChanged,
            ),
            _adminDropdown(
              label: 'Village / Phum',
              units: _villages,
              value: _villageCode,
              onChanged: _loadingGeo || _communeCode == null
                  ? null
                  : _onVillageChanged,
            ),
            if (_loadingGeo) const LinearProgressIndicator(minHeight: 2),
            if (_geoError != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _geoError!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _loadingGeo ? null : _hydrateGeo,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            if (_provinceCode != null || _cityController.text.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'Administrative area: '
                  '${_provinceCode != null ? _composeCity() : _cityController.text.trim()}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            TextFormField(
              controller: _line1Controller,
              decoration: const InputDecoration(
                labelText: 'Street / house / building',
                prefixIcon: Icon(Icons.home_outlined),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Enter the street address'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _line2Controller,
              decoration: const InputDecoration(
                labelText: 'Additional details (optional)',
              ),
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
      ),
    );
  }
}
