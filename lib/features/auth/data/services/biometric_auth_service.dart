import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

/// Wraps device biometric authentication (fingerprint / Face ID) and the
/// persisted on/off preference for it.
///
/// The preference is stored locally only — biometrics gate access to an
/// already-issued session token, they don't talk to the backend.
class BiometricAuthService {
  static const prefKey = 'biometric_enabled';

  final LocalAuthentication _auth;
  final FlutterSecureStorage _storage;

  BiometricAuthService({
    LocalAuthentication? auth,
    FlutterSecureStorage? storage,
  })  : _auth = auth ?? LocalAuthentication(),
        _storage = storage ?? const FlutterSecureStorage();

  Future<bool> isEnabled() async {
    final v = await _storage.read(key: prefKey);
    return v == 'true';
  }

  Future<void> setEnabled(bool value) {
    return _storage.write(key: prefKey, value: value.toString());
  }

  Future<bool> isDeviceSupported() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final supported = await _auth.isDeviceSupported();
      return canCheck && supported;
    } catch (_) {
      return false;
    }
  }

  Future<bool> authenticate(String reason) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}
