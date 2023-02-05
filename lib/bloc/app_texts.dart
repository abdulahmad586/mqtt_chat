// ignore_for_file: constant_identifier_names, non_constant_identifier_names

class AppTexts{

  AppTexts({this.locale = LOCALE_ENGLISH_US});
  String locale;
  static const String LOCALE_ENGLISH_US = "En-US";
  static const String LOCALE_HAUSA = "Ha-NG";

  final Map<String, String> _confirm_user_block = {
    LOCALE_ENGLISH_US: "Are you sure you want to block this user?",
    LOCALE_HAUSA: "Ka tabbata kana so ka yi blocking din wannan?"
  };
  String get confirm_user_block => _confirm_user_block[locale]??'Language not supported';

  final Map<String, String> _confirm_clear_message = {
    LOCALE_ENGLISH_US: "Are you sure you want to delete this conversation?",
    LOCALE_HAUSA: "Ka tabbata kana son goge dukkanin sakonnin nan?"
  };
  String get confirm_clear_message => _confirm_clear_message[locale]??'Language not supported';

  final Map<String, String> _cleared_successfully = {
    LOCALE_ENGLISH_US: "Cleared successfully",
    LOCALE_HAUSA: "An ci nasaran gogewa"
  };
  String get cleared_successfully => _cleared_successfully[locale]??'Language not supported';

  final Map<String, String> _cleared_error = {
    LOCALE_ENGLISH_US: "Unable to delete",
    LOCALE_HAUSA: "Gogewa baya yiwuwa"
  };
  String get cleared_error => _cleared_error[locale]??'Language not supported';

  final Map<String, String> _coming_soon = {
    LOCALE_ENGLISH_US: "Coming soon",
    LOCALE_HAUSA: "Yana nan tafe"
  };
  String get coming_soon => _coming_soon[locale]??'Language not supported';

  final Map<String, String> _rating_added = {
    LOCALE_ENGLISH_US: "Rating added",
    LOCALE_HAUSA: "An ci nasara",
  };
  String get rating_added => _rating_added[locale]??'Language not supported';



}