import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../auth/presentation/admin_profile/admin_profile_cubit.dart';
import '../../../AppBar/presentation/admin_app_bar.dart';
import '../../../navigation/presentation/widgets/admin_navigation_drawer.dart';
import '../../data/models/payment_method_config_model.dart';
import '../cubit/admin_payment_config_cubit.dart';

class AdminPaymentConfigScreen extends StatefulWidget {
  const AdminPaymentConfigScreen({super.key});

  @override
  State<AdminPaymentConfigScreen> createState() =>
      _AdminPaymentConfigScreenState();
}

class _AdminPaymentConfigScreenState extends State<AdminPaymentConfigScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminPaymentConfigCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c = tokens.colors;
    final l10n = AppLocalizations.of(context)!;
    final profile = context.watch<AdminProfileCubit>().state;

    return Scaffold(
      backgroundColor: c.background,
      drawer: SafeArea(
        child: AdminNavigationDrawer(
          gymName: profile.gymName,
          branchName: profile.branchName,
          adminName: profile.adminName,
          adminEmail: profile.adminEmail,
          avatarUrl: profile.avatarUrl,
          initialActiveId: 'payments',
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            AdminAppBar(title: l10n.navPayments),
            Expanded(
              child: BlocBuilder<AdminPaymentConfigCubit, AdminPaymentConfigState>(
                builder: (context, state) {
                  if (state is AdminPaymentConfigLoading) {
                    return Center(
                      child: CircularProgressIndicator(color: c.primary),
                    );
                  }
                  if (state is AdminPaymentConfigError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.error_outline, color: c.danger, size: 48),
                            const SizedBox(height: 12),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: tokens.typography.bodyMedium
                                  .copyWith(color: c.danger),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () =>
                                  context.read<AdminPaymentConfigCubit>().load(),
                              child: Text(l10n.retry),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (state is AdminPaymentConfigLoaded) {
                    return _MethodList(
                      methods: state.methods,
                      savingMethod: state.savingMethod,
                      tokens: tokens,
                      l10n: l10n,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Method List ───────────────────────────────────────────────────────────────

class _MethodList extends StatelessWidget {
  final List<PaymentMethodConfigModel> methods;
  final String? savingMethod;
  final dynamic tokens;
  final AppLocalizations l10n;

  const _MethodList({
    required this.methods,
    required this.savingMethod,
    required this.tokens,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        _SectionHeader(
          label: l10n.admin_payments_sectionTitle,
          subtitle: l10n.admin_payments_sectionSubtitle,
          tokens: tokens,
        ),
        const SizedBox(height: 16),
        ...methods.map(
          (method) => _MethodCard(
            method: method,
            isSaving: savingMethod == method.name,
            tokens: tokens,
          ),
        ),
        if (methods.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Text(
                l10n.admin_payments_noMethodsAvailable,
                style: tokens.typography.bodyMedium.copyWith(color: c.muted),
              ),
            ),
          ),
      ],
    );
  }
}

// ── Section Header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final String subtitle;
  final dynamic tokens;

  const _SectionHeader({
    required this.label,
    required this.subtitle,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: tokens.typography.headlineSmall.copyWith(
            color: c.label,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: tokens.typography.bodySmall.copyWith(color: c.muted),
        ),
      ],
    );
  }
}

// ── Method Card ───────────────────────────────────────────────────────────────

class _MethodCard extends StatelessWidget {
  final PaymentMethodConfigModel method;
  final bool isSaving;
  final dynamic tokens;

  const _MethodCard({
    required this.method,
    required this.isSaving,
    required this.tokens,
  });

  bool get _needsConfig => method.name.toUpperCase() != 'CASH';

  bool get _isConfigured {
    if (!_needsConfig) return true;
    return method.configJson != null && method.configJson!.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: method.tenantEnabled
              ? c.primary.withValues(alpha: 0.3)
              : c.border.withValues(alpha: 0.15),
          width: method.tenantEnabled ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: c.label.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Header row ─────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: method.tenantEnabled
                        ? c.primary.withValues(alpha: 0.12)
                        : c.muted.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _iconFor(method.name),
                    color: method.tenantEnabled ? c.primary : c.muted,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        method.displayName,
                        style: tokens.typography.titleMedium.copyWith(
                          color: c.label,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Text(
                            method.tenantEnabled ? l10n.admin_payments_active : l10n.admin_payments_disabled,
                            style: tokens.typography.bodySmall.copyWith(
                              color: method.tenantEnabled ? c.success : c.muted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (_needsConfig) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: _isConfigured
                                    ? c.success.withValues(alpha: 0.12)
                                    : c.danger.withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                _isConfigured ? l10n.admin_payments_configured : l10n.admin_payments_notConfigured,
                                style: tokens.typography.bodySmall.copyWith(
                                  fontSize: 10.0,
                                  color: _isConfigured ? c.success : c.danger,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                if (isSaving)
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: c.primary),
                  )
                else
                  Switch(
                  value: method.tenantEnabled,
                  activeColor: c.primary, //  works
                  onChanged: (value) => _toggle(context, method, value),
                ),
              ],
            ),
          ),

          // ── Action row (non-CASH only) ──────────────────────────────────────
          if (_needsConfig) ...[
            Divider(height: 1, color: c.border.withValues(alpha: 0.12)),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(18),
                    ),
                    onTap: () => _openConfigSheet(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Icon(Icons.settings_outlined,
                              size: 16, color: c.primary),
                          const SizedBox(width: 8),
                          Text(
                            l10n.admin_payments_configure,
                            style: tokens.typography.bodySmall.copyWith(
                              color: c.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_isConfigured) ...[
                  VerticalDivider(
                      width: 1, color: c.border.withValues(alpha: 0.12)),
                  Expanded(
                    child: InkWell(
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(18),
                      ),
                      onTap: () => _testConnection(context),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Icon(Icons.wifi_tethering_rounded,
                                size: 16, color: c.muted),
                            const SizedBox(width: 8),
                            Text(
                              l10n.admin_payments_testConnection,
                              style: tokens.typography.bodySmall.copyWith(
                                color: c.muted,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Icon(Icons.chevron_right_rounded,
                        size: 18, color: c.muted),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _toggle(
      BuildContext context, PaymentMethodConfigModel method, bool value) async {
    try {
      await context.read<AdminPaymentConfigCubit>().toggleMethod(method, value);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.admin_payments_couldNotUpdate(method.displayName, e.toString()))),
        );
      }
    }
  }

  void _openConfigSheet(BuildContext context) {
    final cubit = context.read<AdminPaymentConfigCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: _CredentialsSheet(method: method, tokens: tokens),
      ),
    );
  }

  Future<void> _testConnection(BuildContext context) async {
    final cubit = context.read<AdminPaymentConfigCubit>();
    final c = tokens.colors;
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(color: c.primary),
            const SizedBox(width: 16),
            Text(l10n.admin_payments_testingConnection),
          ],
        ),
      ),
    );

    try {
      final result = await cubit.testConnection(method.name);
      if (context.mounted) {
        Navigator.of(context).pop(); // close loading dialog
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Row(
              children: [
                Icon(
                  result.ok ? Icons.check_circle : Icons.error_outline,
                  color: result.ok ? c.success : c.danger,
                ),
                const SizedBox(width: 10),
                Text(result.ok ? l10n.admin_payments_connectionOk : l10n.admin_payments_connectionFailed),
              ],
            ),
            content: Text(
              result.ok
                  ? l10n.admin_payments_credentialsVerified(method.displayName)
                  : result.error ?? l10n.admin_payments_unknownError,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.admin_payments_okButton),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.admin_payments_testFailed(e.toString()))),
        );
      }
    }
  }

  IconData _iconFor(String name) {
    switch (name.toUpperCase()) {
      case 'CASH':
        return Icons.payments_outlined;
      case 'STRIPE':
        return Icons.credit_card_outlined;
      case 'PAYPAL':
        return Icons.account_balance_wallet_outlined;
      case 'MPGS':
        return Icons.contactless_outlined;
      default:
        return Icons.payment_outlined;
    }
  }
}

// ── Credentials Bottom Sheet ──────────────────────────────────────────────────

class _CredentialsSheet extends StatefulWidget {
  final PaymentMethodConfigModel method;
  final dynamic tokens;

  const _CredentialsSheet({required this.method, required this.tokens});

  @override
  State<_CredentialsSheet> createState() => _CredentialsSheetState();
}

class _CredentialsSheetState extends State<_CredentialsSheet> {
  late final Map<String, TextEditingController> _controllers;
  bool _saving = false;
  bool _testing = false;
  ({bool ok, String? error})? _testResult;

  static const Map<String, List<_Field>> _fieldDefs = {
    'STRIPE': [
      _Field('secretKey',     'Secret Key',      'sk_live_... or sk_test_...',      _FieldType.password),
      _Field('publishableKey','Publishable Key',  'pk_live_... or pk_test_...',      _FieldType.text),
      _Field('webhookSecret', 'Webhook Secret',   'whsec_...',                       _FieldType.password,
          hint: 'Create a webhook at /api/webhooks/stripe and copy its signing secret.'),
    ],
    'PAYPAL': [
      _Field('clientId',     'Client ID',     '',            _FieldType.text,
          hint: 'Found on your PayPal REST app page.'),
      _Field('clientSecret', 'Client Secret', '',            _FieldType.password,
          hint: 'Shown next to the Client ID in PayPal dashboard.'),
      _Field('mode',         'Mode',          '',            _FieldType.select,
          options: ['SANDBOX', 'LIVE'],
          hint: 'Use SANDBOX while testing. Switch to LIVE for real payments.'),
      _Field('returnUrl',    'Return URL',    'https://yourapp.com/paypal/return', _FieldType.text,
          hint: 'Where PayPal redirects after the buyer approves.'),
      _Field('cancelUrl',    'Cancel URL',    'https://yourapp.com/paypal/cancel', _FieldType.text,
          hint: 'Where PayPal redirects if the buyer cancels.'),
      _Field('brandName',    'Brand Name',    '',            _FieldType.text,
          hint: 'Shown on the PayPal approval page. (Optional)'),
    ],
    'MPGS': [
      _Field('merchantId',  'Merchant ID',   'MERCHANT_00...',                          _FieldType.text,
          hint: 'Issued by your acquiring bank.'),
      _Field('apiPassword', 'API Password',  '',                                        _FieldType.password,
          hint: 'Admin → Integration Settings → Password 1 → Generate New.'),
      _Field('apiBaseUrl',  'API Base URL',  'https://<bank>.gateway.mastercard.com',   _FieldType.text,
          hint: 'Bank of Beirut TEST: https://test-bobsal.gateway.mastercard.com'),
      _Field('mode',        'Mode',          '',                                        _FieldType.select,
          options: ['TEST', 'LIVE'],
          hint: 'Routing is controlled by API Base URL — set the matching host above.'),
      _Field('currency',    'Currency',      'USD',                                     _FieldType.text,
          hint: 'ISO-4217 code (e.g. USD, EUR, LBP). Must match what the bank enabled.'),
      _Field('brandName',   'Brand Name',    '',                                        _FieldType.text,
          hint: 'Shown to the buyer on the hosted checkout page. (Optional)'),
      _Field('apiVersion',  'API Version',   '73',                                      _FieldType.text,
          hint: 'Leave as 73 unless your bank requires a different version.'),
    ],
  };

  List<_Field> get _fields =>
      _fieldDefs[widget.method.name.toUpperCase()] ?? [];

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> existing = {};
    if (widget.method.configJson != null &&
        widget.method.configJson!.isNotEmpty) {
      try {
        existing =
            jsonDecode(widget.method.configJson!) as Map<String, dynamic>;
      } catch (_) {}
    }
    _controllers = {
      for (final f in _fields)
        f.key: TextEditingController(
          text: existing[f.key]?.toString() ??
              (f.type == _FieldType.select && f.options.isNotEmpty
                  ? f.options.first
                  : ''),
        ),
    };
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final payload = {
      for (final f in _fields)
        if (_controllers[f.key]!.text.trim().isNotEmpty)
          f.key: _controllers[f.key]!.text.trim(),
    };
    if (payload.isEmpty) return;

    setState(() {
      _saving = true;
      _testResult = null;
    });
    final ok = await context.read<AdminPaymentConfigCubit>().saveCredentials(
          widget.method,
          jsonEncode(payload),
        );
    if (mounted) {
      setState(() => _saving = false);
      final l10n = AppLocalizations.of(context)!;
      if (ok) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.admin_payments_credentialsSaved)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.admin_payments_credentialsSaveFailed)),
        );
      }
    }
  }

  Future<void> _test() async {
    setState(() {
      _testing = true;
      _testResult = null;
    });
    try {
      final result = await context
          .read<AdminPaymentConfigCubit>()
          .testConnection(widget.method.name);
      if (mounted) setState(() => _testResult = result);
    } catch (e) {
      if (mounted) {
        setState(() => _testResult = (ok: false, error: e.toString()));
      }
    } finally {
      if (mounted) setState(() => _testing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.tokens.colors;
    final t = widget.tokens.typography;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────────────────────
            Row(
              children: [
                Icon(_iconFor(widget.method.name), color: c.primary, size: 22),
                const SizedBox(width: 10),
                Text(
                  l10n.admin_payments_credentialsTitle(widget.method.displayName),
                  style: t.headlineSmall
                      .copyWith(color: c.label, fontWeight: FontWeight.w900),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.close, color: c.muted),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              l10n.admin_payments_credentialsSecureNotice,
              style: t.bodySmall.copyWith(color: c.muted),
            ),
            const SizedBox(height: 20),

            // ── Fields ────────────────────────────────────────────────────────
            ..._fields.map((f) => _CredentialField(
                  field: f,
                  controller: _controllers[f.key]!,
                  tokens: widget.tokens,
                )),

            // ── Test result banner ────────────────────────────────────────────
            if (_testResult != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: _testResult!.ok
                      ? c.success.withValues(alpha: 0.1)
                      : c.danger.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _testResult!.ok
                        ? c.success.withValues(alpha: 0.3)
                        : c.danger.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      _testResult!.ok
                          ? Icons.check_circle_outline
                          : Icons.error_outline,
                      color: _testResult!.ok ? c.success : c.danger,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _testResult!.ok
                            ? l10n.admin_payments_connectionSuccessful
                            : _testResult!.error ?? l10n.admin_payments_connectionFailedShort,
                        style: t.bodySmall.copyWith(
                          color: _testResult!.ok ? c.success : c.danger,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),

            // ── Save button ───────────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: c.primary,
                  foregroundColor: c.onPrimary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: _saving
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: c.onPrimary),
                      )
                    : Text(
                        l10n.admin_payments_saveCredentials,
                        style: t.bodyMedium.copyWith(
                            color: c.onPrimary, fontWeight: FontWeight.w800),
                      ),
              ),
            ),
            const SizedBox(height: 10),

            // ── Test Connection button ────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: _testing ? null : _test,
                icon: _testing
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child:
                            CircularProgressIndicator(strokeWidth: 2, color: c.primary),
                      )
                    : Icon(Icons.wifi_tethering_rounded,
                        size: 18, color: c.primary),
                label: Text(
                  _testing ? l10n.admin_payments_testingEllipsis : l10n.admin_payments_testConnection,
                  style: t.bodyMedium
                      .copyWith(color: c.primary, fontWeight: FontWeight.w700),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: c.primary.withValues(alpha: 0.4)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(String name) {
    switch (name.toUpperCase()) {
      case 'STRIPE':
        return Icons.credit_card_outlined;
      case 'PAYPAL':
        return Icons.account_balance_wallet_outlined;
      case 'MPGS':
        return Icons.contactless_outlined;
      default:
        return Icons.payment_outlined;
    }
  }
}

// ── Credential Field ──────────────────────────────────────────────────────────

enum _FieldType { text, password, select }

class _Field {
  final String key;
  final String label;
  final String placeholder;
  final _FieldType type;
  final List<String> options;
  final String hint;

  const _Field(
    this.key,
    this.label,
    this.placeholder,
    this.type, {
    this.options = const [],
    this.hint = '',
  });
}

class _CredentialField extends StatefulWidget {
  final _Field field;
  final TextEditingController controller;
  final dynamic tokens;

  const _CredentialField({
    required this.field,
    required this.controller,
    required this.tokens,
  });

  @override
  State<_CredentialField> createState() => _CredentialFieldState();
}

class _CredentialFieldState extends State<_CredentialField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final c = widget.tokens.colors;
    final t = widget.tokens.typography;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.field.label,
            style: t.bodySmall.copyWith(
              color: c.label,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (widget.field.hint.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              widget.field.hint,
              style: t.bodySmall.copyWith(color: c.muted, fontSize: 11.0),
            ),
          ],
          const SizedBox(height: 6),

          // ── Select field ──────────────────────────────────────────────────
          if (widget.field.type == _FieldType.select) ...[
            SegmentedButton<String>(
              segments: widget.field.options
                  .map((o) => ButtonSegment<String>(value: o, label: Text(o)))
                  .toList(),
              selected: {
                widget.controller.text.isNotEmpty
                    ? widget.controller.text
                    : widget.field.options.first
              },
              onSelectionChanged: (s) =>
                  setState(() => widget.controller.text = s.first),
              style: SegmentedButton.styleFrom(
                selectedBackgroundColor: c.primary.withValues(alpha: 0.12),
                selectedForegroundColor: c.primary,
              ),
            ),
          ]
          // ── Text / Password field ─────────────────────────────────────────
          else ...[
            TextField(
              controller: widget.controller,
              obscureText: widget.field.type == _FieldType.password && _obscure,
              decoration: InputDecoration(
                hintText: widget.field.placeholder,
                hintStyle: TextStyle(color: c.muted, fontSize: 13.0),
                filled: true,
                fillColor: c.background,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: c.border.withValues(alpha: 0.2)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: c.border.withValues(alpha: 0.2)),
                ),
                suffixIcon: widget.field.type == _FieldType.password
                    ? IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: c.muted,
                          size: 18,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      )
                    : null,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
