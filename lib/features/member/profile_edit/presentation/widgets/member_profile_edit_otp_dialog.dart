import 'package:flutter/material.dart';

import 'package:build4allgym/l10n/app_localizations.dart';

/// Reusable OTP dialog for Edit Profile.
///
/// This follows the same visual structure as Build4All e-commerce:
/// - AlertDialog
/// - title
/// - destination text/email
/// - single TextField for the OTP code
/// - Resend button
/// - Verify button with loading indicator
///
/// Used for:
/// - email change verification
/// - password change verification
class MemberProfileEditOtpDialog extends StatefulWidget {
  /// Dialog title, for example:
  /// "Verify new email" or "Verify password change".
  final String title;

  /// Small text above the email/phone destination.
  /// Example: "Code sent to".
  final String sentToLabel;

  /// Email/phone where the code was sent.
  final String destination;

  /// TextField label.
  final String codeLabel;

  /// Resend button text.
  final String resendLabel;

  /// Verify button text.
  final String verifyLabel;

  /// Message shown if user presses Verify with empty code.
  final String codeRequiredMessage;

  /// Called when user presses Verify.
  ///
  /// Must throw if verification fails.
  final Future<void> Function(String code) onVerify;

  /// Called when user presses Resend.
  ///
  /// Must throw if resend fails.
  final Future<void> Function() onResend;

  const MemberProfileEditOtpDialog({
    super.key,
    required this.title,
    required this.sentToLabel,
    required this.destination,
    required this.codeLabel,
    required this.resendLabel,
    required this.verifyLabel,
    required this.codeRequiredMessage,
    required this.onVerify,
    required this.onResend,
  });

  @override
  State<MemberProfileEditOtpDialog> createState() =>
      _MemberProfileEditOtpDialogState();
}

class _MemberProfileEditOtpDialogState
    extends State<MemberProfileEditOtpDialog> {
  /// Same simple TextEditingController style as e-commerce.
  final TextEditingController _codeController = TextEditingController();

  /// Prevents double tap and shows spinner inside Verify button.
  bool _loading = false;

  /// Inline error text inside the dialog.
  ///
  /// This is better than throwing a red screen or closing the dialog
  /// when the user enters a wrong OTP.
  String? _errorText;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    FocusScope.of(context).unfocus();

    final code = _codeController.text.trim();

    if (code.isEmpty) {
      setState(() {
        _errorText = widget.codeRequiredMessage;
      });
      return;
    }

    setState(() {
      _loading = true;
      _errorText = null;
    });

    try {
      await widget.onVerify(code);

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorText = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _resend() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _loading = true;
      _errorText = null;
    });

    try {
      await widget.onResend();

      if (!mounted) return;

      setState(() {
        _errorText = AppLocalizations.of(context)!.editProfileCodeResentSuccess;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorText = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _cancel() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop(false);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.sentToLabel),
            const SizedBox(height: 6),

            /// Bold destination, same as e-commerce style.
            Text(
              widget.destination,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 14),

            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: widget.codeLabel,
                errorText: _errorText,
              ),
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      actions: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: _loading ? null : _cancel,
                    child: Text(AppLocalizations.of(context)!.general_cancel),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextButton(
                    onPressed: _loading ? null : _resend,
                    child: Text(widget.resendLabel),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: _loading ? null : _verify,
                child: _loading
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : Text(widget.verifyLabel),
              ),
            ),
          ],
        ),
      ],
    );
  }
}