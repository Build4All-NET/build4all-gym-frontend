// Pure domain entity for the motivational quote.
// This class contains only clean data used by the app,
// without any JSON parsing or backend logic.

class MotivationalQuote {
  // The quote text displayed to the user
  final String text;

  // Language code of the quote (e.g., ar, en)
  final String languageCode;

  // Creates a clean MotivationalQuote entity
  const MotivationalQuote({
    required this.text,
    required this.languageCode,
  });
}