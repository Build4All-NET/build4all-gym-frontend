// lib/core/currency/currency_info.dart
//
// Mirrors the backend's CurrencyDTO (build4all-backend
// com.build4all.catalog.dto.CurrencyDTO): { id, currencyType, code, symbol }.

class CurrencyInfo {
  final int? id;
  final String code; // e.g. "USD"
  final String symbol; // e.g. "$"

  const CurrencyInfo({this.id, required this.code, required this.symbol});

  /// Used before the real currency loads, and if it fails to load.
  /// currency_id=1 in gym_dev.json maps to USD on the backend, so default to it.
  static const fallback = CurrencyInfo(code: 'USD', symbol: '\$');

  factory CurrencyInfo.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    return CurrencyInfo(
      id: rawId is int ? rawId : int.tryParse('$rawId'),
      code: (json['code'] ?? fallback.code).toString(),
      symbol: (json['symbol'] ?? fallback.symbol).toString(),
    );
  }
}
