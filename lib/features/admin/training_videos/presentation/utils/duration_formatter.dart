// features/admin/training_videos/presentation/utils/duration_formatter.dart

// ── DurationFormatter ─────────────────────────────────────────────────────────
// A pure utility class (no state, no widgets) that converts raw seconds
// into the "MM:SS" format displayed on video cards.
//
// Examples:
//   0   → "0:00"
//   45  → "0:45"
//   60  → "1:00"
//   305 → "5:05"
//   745 → "12:25"
//
// The backend stores duration as whole seconds (e.g., 305).
// The Flutter UI displays it as "MM:SS" (e.g., "5:05") via this helper.
// ─────────────────────────────────────────────────────────────────────────────

class DurationFormatter {
  // Private constructor — this class is never instantiated.
  // All methods are static; call them as DurationFormatter.format(seconds).
  DurationFormatter._();

  /// Converts [totalSeconds] into a "MM:SS" string.
  ///
  /// Example: DurationFormatter.format(745) → "12:25"
  static String format(int totalSeconds) {
    // Integer division: 745 ÷ 60 = 12 minutes
    final minutes = totalSeconds ~/ 60;

    // Remainder: 745 % 60 = 25 seconds
    final seconds = totalSeconds % 60;

    // padLeft(2, '0') ensures single-digit seconds get a leading zero
    // e.g., 5 → "05", so the result is "5:05" not "5:5"
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}