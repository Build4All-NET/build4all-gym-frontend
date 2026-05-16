// lib/features/admin/payment_settings/presentation/screens/admin_payment_settings_screen.dart
//
// PURPOSE:
//   Shows the payment gateway configuration for this gym.
//   Each gateway (STRIPE, PAYPAL, MPGS, CASH) gets a tile with:
//     • Status badge (Configured / Not configured)
//     • Toggle to enable/disable
//     • "Configure" button that opens a bottom sheet with the credential form
//     • "Test" button to ping the gateway
//
// WIRING (add this to admin settings navigation or directly as a settings item):
//   Navigator.push(context, MaterialPageRoute(
//     builder: (_) => AdminPaymentSettingsScreen(tokenStore: tokenStore),
//   ));

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/features/auth/data/services/auth_token_store.dart';

import '../../data/repositories/payment_settings_repository_impl.dart';
import '../../data/services/admin_payment_settings_service.dart';
import '../../domain/entities/payment_method_entity.dart';
import '../bloc/payment_settings_bloc.dart';
import '../bloc/payment_settings_event.dart';
import '../bloc/payment_settings_state.dart';

class AdminPaymentSettingsScreen extends StatelessWidget {
  final AuthTokenStore tokenStore;
  const AdminPaymentSettingsScreen({super.key, required this.tokenStore});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentSettingsBloc(
        PaymentSettingsRepositoryImpl(
          AdminPaymentSettingsService(tokenStore: tokenStore),
        ),
      )..add(const LoadPaymentMethods()),
      child: const _PaymentSettingsView(),
    );
  }
}

class _PaymentSettingsView extends StatelessWidget {
  const _PaymentSettingsView();

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return Scaffold(
      backgroundColor: tokens.colors.background,
      appBar: AppBar(
        backgroundColor: tokens.colors.primary,
        foregroundColor: tokens.colors.onPrimary,
        title: Text(
          'Payment Methods',
          style: tokens.typography.titleMedium.copyWith(
            color: tokens.colors.onPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        elevation: 0,
      ),
      body: BlocConsumer<PaymentSettingsBloc, PaymentSettingsState>(
        listenWhen: (prev, curr) =>
            curr.testResult != null && prev.testResult != curr.testResult,
        listener: (context, state) {
          if (state.testResult != null) {
            final success = state.testResult!['success'] as bool? ?? false;
            final msg = state.testResult!['message'] as String? ?? '';
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(success ? '✓ $msg' : '✗ $msg'),
              backgroundColor:
                  success ? tokens.colors.success : tokens.colors.danger,
            ));
          }
        },
        builder: (context, state) {
          if (state.status == PaymentSettingsStatus.loading) {
            return Center(
              child: CircularProgressIndicator(color: tokens.colors.primary),
            );
          }

          if (state.status == PaymentSettingsStatus.error) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, color: tokens.colors.danger, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    state.errorMessage ?? 'Failed to load payment methods',
                    textAlign: TextAlign.center,
                    style: tokens.typography.bodyMedium
                        .copyWith(color: tokens.colors.danger),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context
                        .read<PaymentSettingsBloc>()
                        .add(const LoadPaymentMethods()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.methods.isEmpty) {
            return Center(
              child: Text(
                'No payment methods configured on the platform.',
                style: tokens.typography.bodyMedium
                    .copyWith(color: tokens.colors.muted),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.methods.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final method = state.methods[i];
              final isSaving = state.savingMethod == method.methodName;
              return _PaymentMethodTile(
                method: method,
                isSaving: isSaving,
              );
            },
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TILE
// ─────────────────────────────────────────────────────────────────────────────
class _PaymentMethodTile extends StatelessWidget {
  final PaymentMethodEntity method;
  final bool isSaving;
  const _PaymentMethodTile({required this.method, required this.isSaving});

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return Container(
      decoration: BoxDecoration(
        color: tokens.colors.card,
        borderRadius: BorderRadius.circular(tokens.card.radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          // ── Header row ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 0),
            child: Row(
              children: [
                // Gateway icon
                _GatewayIcon(methodName: method.methodName),
                const SizedBox(width: 12),
                // Name + status badge
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        method.displayName,
                        style: tokens.typography.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      _StatusBadge(
                          configured: method.configured,
                          active: method.isActive),
                    ],
                  ),
                ),
                // Enable / disable toggle
                isSaving
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: tokens.colors.primary,
                        ),
                      )
                    : Switch.adaptive(
                        value: method.projectEnabled,
                        activeColor: tokens.colors.primary,
                        onChanged: (val) {
                          if (!method.configured && val) {
                            // Can't enable without config
                            _openConfigSheet(context, method);
                          } else {
                            context.read<PaymentSettingsBloc>().add(
                                  SavePaymentConfig(
                                    methodName: method.methodName,
                                    enabled: val,
                                    configValues: method.configValues,
                                  ),
                                );
                          }
                        },
                      ),
              ],
            ),
          ),
          // ── Action buttons ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (method.configured) ...[
                  TextButton.icon(
                    onPressed: () => context
                        .read<PaymentSettingsBloc>()
                        .add(TestPaymentConnection(method.methodName)),
                    icon: Icon(Icons.wifi_tethering_rounded,
                        size: 16, color: tokens.colors.primary),
                    label: Text(
                      'Test',
                      style: tokens.typography.bodySmall.copyWith(
                          color: tokens.colors.primary,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
                OutlinedButton.icon(
                  onPressed: () => _openConfigSheet(context, method),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: tokens.colors.primary),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  ),
                  icon: Icon(Icons.settings_rounded,
                      size: 16, color: tokens.colors.primary),
                  label: Text(
                    'Configure',
                    style: tokens.typography.bodySmall.copyWith(
                        color: tokens.colors.primary,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openConfigSheet(BuildContext context, PaymentMethodEntity method) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<PaymentSettingsBloc>(),
        child: _ConfigSheet(method: method),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CONFIG BOTTOM SHEET
// ─────────────────────────────────────────────────────────────────────────────
class _ConfigSheet extends StatefulWidget {
  final PaymentMethodEntity method;
  const _ConfigSheet({required this.method});

  @override
  State<_ConfigSheet> createState() => _ConfigSheetState();
}

class _ConfigSheetState extends State<_ConfigSheet> {
  late bool _enabled;
  late Map<String, TextEditingController> _controllers;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _enabled = widget.method.projectEnabled;

    // Build a text controller for each schema field
    _controllers = {};
    final schema = widget.method.configSchema;
    final values = widget.method.configValues;

    for (final key in schema.keys) {
      final existing = values[key]?.toString() ?? '';
      // Don't prefill masked secrets — let the admin re-enter them
      final isMasked = existing.startsWith('***');
      _controllers[key] = TextEditingController(text: isMasked ? '' : existing);
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final schemaFields = widget.method.configSchema.keys.toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: tokens.colors.background,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              controller: scrollController,
              padding: EdgeInsets.fromLTRB(
                20,
                16,
                20,
                MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: tokens.colors.muted.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  'Configure ${widget.method.displayName}',
                  style: tokens.typography.titleMedium
                      .copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  'Enter your API credentials below. Secret fields are stored encrypted.',
                  style: tokens.typography.bodySmall
                      .copyWith(color: tokens.colors.muted),
                ),
                const SizedBox(height: 20),

                // Enable toggle
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Enable ${widget.method.displayName}',
                        style: tokens.typography.bodyMedium
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Switch.adaptive(
                      value: _enabled,
                      activeColor: tokens.colors.primary,
                      onChanged: (v) => setState(() => _enabled = v),
                    ),
                  ],
                ),
                const Divider(height: 24),

                // Schema fields
                ...schemaFields.map((fieldKey) {
                  final meta = widget.method.configSchema[fieldKey];
                  final label = _labelFor(fieldKey);
                  final isSecret = _isSecretField(fieldKey);
                  final isRequired =
                      meta is Map ? (meta['required'] as bool? ?? false) : false;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TextFormField(
                      controller: _controllers[fieldKey],
                      obscureText: isSecret,
                      decoration: InputDecoration(
                        labelText: label + (isRequired ? ' *' : ''),
                        hintText: isSecret ? '••••••••••••' : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: isSecret
                            ? Icon(Icons.lock_outline_rounded,
                                color: tokens.colors.muted)
                            : null,
                      ),
                      validator: isRequired
                          ? (v) => (v == null || v.trim().isEmpty)
                              ? '$label is required'
                              : null
                          : null,
                    ),
                  );
                }),

                const SizedBox(height: 8),

                // Save button
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tokens.colors.primary,
                      foregroundColor: tokens.colors.onPrimary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      'Save Configuration',
                      style: tokens.typography.bodyMedium.copyWith(
                          color: tokens.colors.onPrimary,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final configValues = <String, dynamic>{};
    for (final key in _controllers.keys) {
      final value = _controllers[key]!.text.trim();
      if (value.isNotEmpty) {
        configValues[key] = value;
      }
    }

    context.read<PaymentSettingsBloc>().add(SavePaymentConfig(
          methodName: widget.method.methodName,
          enabled: _enabled,
          configValues: configValues,
        ));

    Navigator.pop(context);
  }

  String _labelFor(String key) {
    const labels = {
      'publishableKey':  'Publishable Key',
      'secretKey':       'Secret Key',
      'webhookSecret':   'Webhook Secret',
      'clientId':        'Client ID',
      'clientSecret':    'Client Secret',
      'sandboxMode':     'Sandbox Mode',
      'merchantId':      'Merchant ID',
      'apiUsername':     'API Username',
      'apiPassword':     'API Password',
      'apiBaseUrl':      'API Base URL',
      'mode':            'Mode (TEST / LIVE)',
      'instructions':    'Cash Instructions',
    };
    return labels[key] ?? key;
  }

  bool _isSecretField(String key) {
    const secrets = {'secretKey', 'webhookSecret', 'clientSecret', 'apiPassword'};
    return secrets.contains(key);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SMALL WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class _GatewayIcon extends StatelessWidget {
  final String methodName;
  const _GatewayIcon({required this.methodName});

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final icon = _iconFor(methodName);
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: tokens.colors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: tokens.colors.primary, size: 22),
    );
  }

  IconData _iconFor(String name) {
    switch (name.toUpperCase()) {
      case 'STRIPE':  return Icons.credit_card_rounded;
      case 'PAYPAL':  return Icons.account_balance_wallet_rounded;
      case 'MPGS':    return Icons.contactless_rounded;
      case 'CASH':    return Icons.payments_rounded;
      default:        return Icons.payment_rounded;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final bool configured;
  final bool active;
  const _StatusBadge({required this.configured, required this.active});

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final color  = active ? tokens.colors.success : tokens.colors.muted;
    final label  = active ? 'Active' : configured ? 'Disabled' : 'Not configured';

    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: tokens.typography.bodySmall.copyWith(color: color),
        ),
      ],
    );
  }
}
