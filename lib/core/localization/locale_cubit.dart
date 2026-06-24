import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'locale_storage.dart';

class LocaleCubit extends Cubit<Locale?> {
  final LocaleStorage storage;

  /// Default language the whole app initializes with.
  /// Every screen starts in English unless the user explicitly changes it.
  static const Locale defaultLocale = Locale('en');

  LocaleCubit(this.storage) : super(defaultLocale);

  Future<void> loadSavedLocale() async {
    final saved = await storage.load();
    // Fall back to English when nothing has been saved yet, so the app
    // never picks up the device locale by accident.
    emit(saved ?? defaultLocale);
  }

  Future<void> setLocale(Locale? locale) async {
    if (locale == null) {
      // Reset back to the default English locale instead of device locale.
      await storage.clear();
      emit(defaultLocale);
      return;
    }

    // only allow ar/en/fr
    const allowed = ['ar', 'en', 'fr'];
    if (!allowed.contains(locale.languageCode)) return;

    await storage.save(locale);
    emit(locale);
  }
}
