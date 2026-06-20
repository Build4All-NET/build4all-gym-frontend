/// A single labelled value used by the report charts/breakdowns.
/// e.g. (label: "2026-06-19", value: 1200) or (label: "Rent", value: 500).
class ReportPointEntity {
  final String label;
  final double value;

  const ReportPointEntity({required this.label, required this.value});
}
