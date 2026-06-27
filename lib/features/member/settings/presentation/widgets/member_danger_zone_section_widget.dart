import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:build4allgym/app/app_router.dart';
import 'package:build4allgym/core/config/env.dart';
import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/features/auth/data/services/auth_token_store.dart';
import 'package:build4allgym/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MemberDangerZoneSectionWidget extends StatelessWidget {
  const MemberDangerZoneSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.watch<ThemeCubit>().state.tokens;
    final colors = tokens.colors;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.danger.withOpacity(0.08),
        borderRadius: BorderRadius.circular(
          tokens.card.radius,
        ),
        border: Border.all(
          color: colors.danger.withOpacity(0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colors.danger,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_rounded,
                  color: colors.onPrimary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.admin_settings_dangerTitle,
                      style: tokens.typography.titleMedium.copyWith(
                        color: colors.danger,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      l10n.admin_settings_dangerSubtitle,
                      style: tokens.typography.bodySmall.copyWith(
                        color: colors.danger,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _DangerButton(
            icon: Icons.logout_rounded,
            label: l10n.admin_settings_logOut,
            onTap: () => _confirmLogout(
              context,
              tokens,
              colors,
            ),
          ),

          const SizedBox(height: 10),

          _DangerButton(
            icon: Icons.delete_outline_rounded,
            label: l10n.admin_settings_deleteAccount,
            onTap: () => _confirmDeleteAccount(
              context,
              tokens,
              colors,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // LOGOUT
  // ---------------------------------------------------------------------------

  Future<void> _confirmLogout(
      BuildContext context,
      dynamic tokens,
      dynamic colors,
      ) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            l10n.admin_settings_logOut,
            style: tokens.typography.titleMedium,
          ),
          content: Text(
            l10n.admin_settings_logOutMessage,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: Text(
                l10n.general_cancel,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              style: TextButton.styleFrom(
                foregroundColor: colors.danger,
              ),
              child: Text(
                l10n.admin_settings_logOut,
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    await _performLogout(context);
  }

  Future<void> _performLogout(
      BuildContext context,
      ) async {
    const storage = FlutterSecureStorage();

    await storage.deleteAll();

    if (!context.mounted) {
      return;
    }

    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRouter.logout,
          (_) => false,
    );
  }

  // ---------------------------------------------------------------------------
  // DELETE ACCOUNT
  // ---------------------------------------------------------------------------

  Future<void> _confirmDeleteAccount(
      BuildContext context,
      dynamic tokens,
      dynamic colors,
      ) async {
    final l10n = AppLocalizations.of(context)!;
    final passwordController = TextEditingController();

    bool hidePassword = true;
    bool deleting = false;

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                l10n.admin_settings_deleteAccount,
                style: tokens.typography.titleMedium,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.admin_settings_deleteAccountMessage,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: hidePassword,
                    enabled: !deleting,
                    decoration: InputDecoration(
                      labelText: 'Current password',
                      prefixIcon: const Icon(
                        Icons.lock_outline_rounded,
                      ),
                      suffixIcon: IconButton(
                        onPressed: deleting
                            ? null
                            : () {
                          setDialogState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                        icon: Icon(
                          hidePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: deleting
                      ? null
                      : () {
                    Navigator.of(dialogContext).pop(false);
                  },
                  child: Text(
                    l10n.general_cancel,
                  ),
                ),
                TextButton(
                  onPressed: deleting
                      ? null
                      : () async {
                    final password =
                    passwordController.text.trim();

                    if (password.isEmpty) {
                      ScaffoldMessenger.of(dialogContext)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Current password is required.',
                          ),
                        ),
                      );
                      return;
                    }

                    setDialogState(() {
                      deleting = true;
                    });

                    try {
                      await _deleteAccount(
                        password: password,
                      );

                      if (!dialogContext.mounted) {
                        return;
                      }

                      Navigator.of(dialogContext).pop(true);
                    } catch (e) {
                      if (!dialogContext.mounted) {
                        return;
                      }

                      setDialogState(() {
                        deleting = false;
                      });

                      ScaffoldMessenger.of(dialogContext)
                          .showSnackBar(
                        SnackBar(
                          content: Text(
                            _readError(
                              e,
                              'Failed to delete account.',
                            ),
                          ),
                          backgroundColor: colors.danger,
                        ),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: colors.danger,
                  ),
                  child: deleting
                      ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.danger,
                    ),
                  )
                      : Text(
                    l10n.admin_settings_delete,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    passwordController.dispose();

    if (confirmed != true || !context.mounted) {
      return;
    }

    await _clearStorageAndOpenLogin(context);
  }

  Future<void> _deleteAccount({
    required String password,
  }) async {
    const tokenStore = AuthTokenStore();

    final userId = await tokenStore.getUserId();
    final token = (await tokenStore.getToken())?.trim() ?? '';

    if (userId <= 0) {
      throw Exception('Missing user id.');
    }

    if (token.isEmpty) {
      throw Exception('Missing authentication token.');
    }

    final authorization = token.toLowerCase().startsWith('bearer ')
        ? token
        : 'Bearer $token';

    final dio = Dio(
      BaseOptions(
        baseUrl: Env.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 30),
        headers: const {
          'Accept': 'application/json',
        },
      ),
    );

    await dio.delete(
      '/api/users/$userId',
      data: {
        'password': password,
      },
      options: Options(
        headers: {
          'Authorization': authorization,
          'Content-Type': 'application/json',
        },
        receiveDataWhenStatusError: true,
      ),
    );
  }

  Future<void> _clearStorageAndOpenLogin(
      BuildContext context,
      ) async {
    const storage = FlutterSecureStorage();

    await storage.deleteAll();

    if (!context.mounted) {
      return;
    }

    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRouter.logout,
          (_) => false,
    );
  }

  String _readError(
      Object error,
      String fallback,
      ) {
    if (error is DioException) {
      final data = error.response?.data;

      if (data is Map) {
        final message = (
            data['message'] ??
                data['error'] ??
                data['details'] ??
                data['detail']
        )
            ?.toString()
            .trim();

        if (message != null && message.isNotEmpty) {
          return message;
        }
      }

      if (data is String && data.trim().isNotEmpty) {
        return data.trim();
      }

      final message = error.message?.trim();

      if (message != null && message.isNotEmpty) {
        return message;
      }
    }

    final raw = error
        .toString()
        .replaceFirst('Exception: ', '')
        .trim();

    return raw.isEmpty ? fallback : raw;
  }
}

class _DangerButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DangerButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.watch<ThemeCubit>().state.tokens;
    final colors = tokens.colors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: colors.danger.withOpacity(0.30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: colors.danger,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: tokens.typography.bodyMedium.copyWith(
                color: colors.danger,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}