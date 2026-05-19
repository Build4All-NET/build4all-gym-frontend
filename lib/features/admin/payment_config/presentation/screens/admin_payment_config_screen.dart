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
                              child: const Text('Retry'),
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

class _MethodList extends StatelessWidget {
  final List<PaymentMethodConfigModel> methods;
  final String? savingMethod;
  final dynamic tokens;

  const _MethodList({
    required this.methods,
    required this.savingMethod,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        _SectionHeader(
          label: 'Payment Methods',
          subtitle: 'Enable or disable payment options visible to your members.',
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
                'No payment methods available on this platform.',
                style: tokens.typography.bodyMedium.copyWith(color: c.muted),
              ),
            ),
          ),
      ],
    );
  }
}

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

class _MethodCard extends StatelessWidget {
  final PaymentMethodConfigModel method;
  final bool isSaving;
  final dynamic tokens;

  const _MethodCard({
    required this.method,
    required this.isSaving,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: method.tenantEnabled
              ? c.primary.withOpacity(0.3)
              : c.border.withOpacity(0.15),
          width: method.tenantEnabled ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: c.label.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: method.tenantEnabled
                  ? c.primary.withOpacity(0.12)
                  : c.muted.withOpacity(0.08),
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
                Text(
                  method.tenantEnabled ? 'Active' : 'Disabled',
                  style: tokens.typography.bodySmall.copyWith(
                    color: method.tenantEnabled ? c.success : c.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (isSaving)
            SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: c.primary,
              ),
            )
          else
            Switch(
              value: method.tenantEnabled,
              activeColor: c.primary,
              onChanged: (value) => context
                  .read<AdminPaymentConfigCubit>()
                  .toggleMethod(method, value),
            ),
        ],
      ),
    );
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
