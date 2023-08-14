import 'package:phone_text_field/helper/countries.dart';
import '../../constants/lang/ar.dart';
import '../../constants/lang/en.dart';
import '../../constants/lang/fr.dart';

extension StringExtension on String {
  String tr() {
    String result = this;

    switch (localeCode) {
      case "ar":
        result = ar[result] ?? this;
        break;

      case "en":
        result = en[result] ?? this;
        break;

      case "fr":
        result = fr[result] ?? this;
        break;

      default:
        result = this;
    }

    return result;
  }

  bool get isInt => int.tryParse(this) != null;
}
