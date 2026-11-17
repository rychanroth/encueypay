import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../../../core/presentation/widgets/app_snack_bar.dart';
import '../../../../core/presentation/widgets/brand_lockup.dart';
import '../../../../core/presentation/widgets/content_width.dart';
import '../../domain/customer_onboarding.dart';
import '../controllers/auth_controller.dart';
import '../controllers/onboarding_controller.dart';
import '../widgets/onboarding_visuals.dart';

/// First-run customer onboarding: three feature explainers, then the required
/// name + phone step. Full-screen overlay outside the shell (ROUTE-03); the
/// router redirect (`needsCustomerOnboarding`) owns entry and exit.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const _profilePage = 3;

  final _pageController = PageController();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  int _page = 0;
  bool _filled = false;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _goTo(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  void _next() {
    if (_page < _profilePage) {
      _goTo(_page + 1);
      return;
    }
    _complete();
  }

  Future<void> _complete() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final phone = normalizeCustomerPhone(_phoneController.text);
    if (phone == null) return;
    FocusScope.of(context).unfocus();
    await ref
        .read(onboardingControllerProvider.notifier)
        .complete(fullName: _nameController.text.trim(), phone: phone);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider).value;
    final isSaving = ref.watch(onboardingControllerProvider).isLoading;
    final isProfile = _page == _profilePage;

    // Deep-link/cold-start: hold here until the session resolves (the router
    // normally redirects signed-out visitors to /login).
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_filled) {
      // Prefill once: Google already gave us a name, and edits must not be
      // overwritten by a late session emission.
      _nameController.text = user.fullName.trim();
      _phoneController.text = user.phone?.trim() ?? '';
      _filled = true;
    }

    ref.listen(onboardingControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            AppSnackBar(content: Text(userMessageFor(next.error!))),
          );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: ContentWidth(
          maxWidth: 560,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.md,
                  0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: isProfile
                            ? IconButton(
                                tooltip: 'Back',
                                icon: const Icon(Icons.arrow_back),
                                onPressed: isSaving
                                    ? null
                                    : () => _goTo(_profilePage - 1),
                              )
                            : FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: const BrandLockup(
                                  markSize: 28,
                                  wordmarkSize: 20,
                                ),
                              ),
                      ),
                    ),
                    if (!isProfile)
                      TextButton(
                        onPressed: isSaving ? null : () => _goTo(_profilePage),
                        child: const Text('Skip intro'),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (page) => setState(() => _page = page),
                  children: [
                    _OnboardingStep(
                      content: const _IntroContent(
                        visual: CatalogOnboardingVisual(),
                        eyebrow: 'SHOP LOCAL',
                        title: 'Everything you need, one storefront',
                        body:
                            'Browse curated products from trusted Cambodian '
                            'brands. Search, compare and save favourites in '
                            'seconds.',
                      ),
                      footer: _StepFooter(
                        page: 0,
                        isSaving: isSaving,
                        onNext: isSaving ? null : _next,
                      ),
                    ),
                    _OnboardingStep(
                      content: const _IntroContent(
                        visual: PaymentOnboardingVisual(),
                        eyebrow: 'PAY YOUR WAY',
                        title: 'Scan to pay, or pay on delivery',
                        body:
                            'Check out with Bakong KHQR for instant '
                            'verification, or choose cash on delivery. Every '
                            'payment shows a clear status.',
                      ),
                      footer: _StepFooter(
                        page: 1,
                        isSaving: isSaving,
                        onNext: isSaving ? null : _next,
                      ),
                    ),
                    _OnboardingStep(
                      content: const _IntroContent(
                        visual: DeliveryOnboardingVisual(),
                        eyebrow: 'STAY IN THE LOOP',
                        title: 'Follow every order to your door',
                        body:
                            'Live status from confirmed to delivered, with '
                            'delivery updates so you always know when to '
                            'expect your parcel.',
                      ),
                      footer: _StepFooter(
                        page: 2,
                        isSaving: isSaving,
                        onNext: isSaving ? null : _next,
                      ),
                    ),
                    _OnboardingStep(
                      content: _ProfileContent(
                        formKey: _formKey,
                        nameController: _nameController,
                        phoneController: _phoneController,
                        onSubmit: isSaving ? null : _complete,
                      ),
                      footer: _StepFooter(
                        page: _profilePage,
                        isProfile: true,
                        isSaving: isSaving,
                        onNext: isSaving ? null : _next,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Scrolls when the viewport is short, but centers the step (content + CTA)
/// in the available height when it fits. The CTA lives with its slide, so it
/// never floats at the bottom of the screen with a dead gap above it.
class _OnboardingStep extends StatelessWidget {
  const _OnboardingStep({required this.content, required this.footer});

  final Widget content;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.fromLTRB(
      AppSpacing.md,
      AppSpacing.sm,
      AppSpacing.md,
      AppSpacing.md,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final minHeight = (constraints.maxHeight - padding.vertical).clamp(
          0.0,
          double.infinity,
        );
        return SingleChildScrollView(
          padding: padding,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: minHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                content,
                const SizedBox(height: AppSpacing.lg),
                footer,
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StepFooter extends StatelessWidget {
  const _StepFooter({
    required this.page,
    required this.isSaving,
    required this.onNext,
    this.isProfile = false,
  });

  final int page;
  final bool isSaving;
  final bool isProfile;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var index = 0; index <= 3; index++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                margin: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs / 2,
                ),
                width: index == page ? 22 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: index == page
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outlineVariant,
                  borderRadius: AppRadii.brFull,
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: isSaving ? null : onNext,
            child: isSaving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(isProfile ? 'Start shopping' : 'Next'),
          ),
        ),
      ],
    );
  }
}

class _IntroContent extends StatelessWidget {
  const _IntroContent({
    required this.visual,
    required this.eyebrow,
    required this.title,
    required this.body,
  });

  final Widget visual;
  final String eyebrow;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visualHeight = (MediaQuery.sizeOf(context).height * 0.34)
        .clamp(190.0, 310.0)
        .toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: SizedBox(height: visualHeight, child: visual),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          eyebrow,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.primary,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(title, style: theme.textTheme.headlineLarge),
        const SizedBox(height: AppSpacing.sm),
        Text(
          body,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AutofillGroup(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Almost there', style: theme.textTheme.headlineLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Confirm your name and add a phone number so couriers can reach '
              'you on delivery day.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.name],
              decoration: const InputDecoration(
                labelText: 'Full name',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Enter your name'
                  : null,
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.telephoneNumber],
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s\-().]')),
                LengthLimitingTextInputFormatter(20),
              ],
              decoration: const InputDecoration(
                labelText: 'Phone number',
                hintText: '012 345 678',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              validator: (value) => normalizeCustomerPhone(value ?? '') == null
                  ? 'Enter 8–15 digits'
                  : null,
              onFieldSubmitted: (_) => onSubmit?.call(),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    'Your number is only shared with the courier for this '
                    'delivery.',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
