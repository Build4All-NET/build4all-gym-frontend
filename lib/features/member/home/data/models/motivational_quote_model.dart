// This model converts the motivational quote section from backend JSON
// into a typed Dart object.
//
// Example backend JSON:
// {
//   "text": "Success is the sum of small efforts repeated daily",
//   "languageCode": "en"
// }
//
// After parsing with fromJson, the app can use:
// quote.text
// quote.languageCode

class MotivationalQuoteModel {
  // Quote text shown in the UI
  final String text;

  // Language code of the quote, such as ar or en
  final String languageCode;

  // Creates a typed MotivationalQuoteModel object
  const MotivationalQuoteModel({
    required this.text,
    required this.languageCode,
  });

  // Converts backend JSON into a MotivationalQuoteModel object
  factory MotivationalQuoteModel.fromJson(Map<String, dynamic> json) {
    return MotivationalQuoteModel(
      // Safely read the text, fallback to empty string if null
      text: json['text']?.toString() ?? '',

      // Safely read the language code, fallback to empty string if null
      languageCode: json['languageCode']?.toString() ?? '',
    );
  }
}