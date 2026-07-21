/// Parses a tenant id read from secure storage/token store.
///
/// Never returns a fallback tenant id (e.g. 1) when parsing fails or the
/// value is missing — silently assuming tenant 1 would let one gym's admin
/// screen show or mutate another gym's data whenever the stored tenant id
/// hadn't loaded yet. Callers must treat `null` as "not resolved" and show
/// a resolving/error state instead of proceeding.
class TenantIdParser {
  const TenantIdParser._();

  static int? parseOrNull(String? raw) {
    if (raw == null) return null;
    return int.tryParse(raw);
  }
}
