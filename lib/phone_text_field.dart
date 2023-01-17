library phone_text_field;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants/countries.dart';
import 'dialog/country_picker_dialog.dart';
import 'model/phone_number.dart';

class PhoneTextField extends StatefulWidget {
  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// {@macro flutter.widgets.editableText.onChanged}
  ///
  /// See also:
  ///
  ///  * [inputFormatters], which are called before [onChanged]
  ///    runs and can validate and change ("format") the input value.
  ///  * [onEditingComplete], [onSubmitted], [onSelectionChanged]:
  ///    which are more specialized input change notifications.
  final ValueChanged<PhoneNumber>? onChanged;

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController? controller;

  final FocusNode? focusNode;

  final bool enabled;

  /// Initial Value for the field.
  /// This property can be used to pre-fill the field.
  final String? initialValue;

  /// 2 letter ISO Code or country dial code.
  ///
  /// ```dart
  /// initialCountryCode: 'IN', // India
  /// initialCountryCode: '+225', // Côte d'Ivoire
  /// ```
  final String? initialCountryCode;

  /// The decoration to show around the text field.
  ///
  /// By default, draws a horizontal line under the text field but can be
  /// configured to show an icon, label, hint text, and error text.
  ///
  /// Specify null to remove the decoration entirely (including the
  /// extra padding introduced by the decoration to save space for the labels).
  final InputDecoration decoration;

  /// Disable view Min/Max Length check
  final bool disableLengthCheck;

  /// Icon of the drop down button.
  ///
  /// Default is [Icon(Icons.arrow_drop_down)]
  final Icon dropdownIcon;

  /// Whether this text field should focus itself if nothing else is already focused.
  final bool autofocus;

  /// Autovalidate mode for text form field.
  ///
  /// If [AutovalidateMode.onUserInteraction], this FormField will only auto-validate after its content changes.
  /// If [AutovalidateMode.always], it will auto-validate even without user interaction.
  /// If [AutovalidateMode.disabled], auto-validation will be disabled.
  ///
  /// Defaults to [AutovalidateMode.onUserInteraction].
  final AutovalidateMode? autovalidateMode;

  /// List of 2 Letter ISO Codes of countries to show. Defaults to showing the inbuilt list of all countries.
  final List<String>? countries;

  /// Message to be displayed on autoValidate error
  ///
  /// Default value is `Invalid Mobile Number`.
  final String? invalidNumberMessage;

  /// Optional set of styles to allow for customizing the country search
  /// & pick dialog
  final InputDecoration? searchFieldInputDecoration;

  /// Localalization.
  ///
  /// Default is Locale('en','')
  final Locale locale;

  /// to required validation number.
  ///
  /// Default is isRequired : true
  final bool isRequired;

  /// Message to be displayed on dialog title
  ///
  /// Default value is `Select Country`.
  final String? dialogTitle;

  const PhoneTextField({
    super.key,
    this.initialCountryCode,
    this.textAlign = TextAlign.left,
    this.isRequired = true,
    this.initialValue,
    this.controller,
    this.focusNode,
    this.decoration = const InputDecoration(labelText: "Phone number"),
    this.locale = const Locale('en', ''),
    this.onChanged,
    this.countries,
    this.enabled = true,
    this.dropdownIcon = const Icon(Icons.arrow_drop_down),
    this.autofocus = false,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.disableLengthCheck = false,
    this.invalidNumberMessage = 'Invalid Phone Number',
    this.dialogTitle = "Select Country",
    this.searchFieldInputDecoration,
  });

  @override
  _PhoneTextFieldState createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  late List<Country> _countryList;
  late Country _selectedCountry;
  late List<Country> filteredCountries;
  late String number;

  String? validatorMessage;

  @override
  void initState() {
    super.initState();
    _countryList = widget.countries == null
        ? countries
        : countries
            .where((country) => widget.countries!.contains(country.code))
            .toList();

    final List<Country> unSortcountryList = [..._countryList];
    if (widget.locale.languageCode.toLowerCase() == "ar") {
      unSortcountryList.sort((a, b) => a.nameAr.compareTo(b.nameAr));
    } else {
      unSortcountryList.sort((a, b) => a.name.compareTo(b.name));
    }

    _countryList = unSortcountryList;
    filteredCountries = _countryList;
    number = widget.initialValue ?? '';
    if (number.startsWith('+')) {
      number = number.substring(1);
      // parse initial value
      _selectedCountry = countries.firstWhere(
        (country) => number.startsWith(country.fullCountryCode),
        orElse: () => _countryList.first,
      );

      // remove country code from the initial number value
      number = number.replaceFirst(
        RegExp("^${_selectedCountry.fullCountryCode}"),
        "",
      );
    } else {
      _selectedCountry = _countryList.firstWhere(
        (item) => item.code == (widget.initialCountryCode ?? 'US'),
        orElse: () => _countryList.first,
      );

      // remove country code from the initial number value
      if (number.startsWith('+')) {
        number = number.replaceFirst(
          RegExp("^\\+${_selectedCountry.fullCountryCode}"),
          "",
        );
      } else {
        number = number.replaceFirst(
          RegExp("^${_selectedCountry.fullCountryCode}"),
          "",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: (widget.controller == null) ? number : null,
      textAlign: widget.textAlign,
      controller: widget.controller,
      focusNode: widget.focusNode,
      decoration: widget.decoration.copyWith(
        prefix: widget.locale.languageCode.toLowerCase() == "ar"
            ? null
            : _buildCountryCodeButton(),
        suffix: widget.locale.languageCode.toLowerCase() == "ar"
            ? _buildCountryCodeButton()
            : null,
        counterText: '',
      ),
      onChanged: (value) async {
        final phoneNumber = PhoneNumber(
          countryISOCode: _selectedCountry.code,
          countryCode: '+${_selectedCountry.fullCountryCode}',
          number: value,
        );

        widget.onChanged?.call(phoneNumber);
      },
      validator: (value) {
        if (widget.isRequired || value!.isNotEmpty) {
          if (!widget.disableLengthCheck && value != null) {
            return value.length >= _selectedCountry.minLength &&
                    value.length <= _selectedCountry.maxLength
                ? null
                : widget.invalidNumberMessage;
          }

          return validatorMessage;
        } else {
          return null;
        }
      },
      maxLength: widget.disableLengthCheck ? null : _selectedCountry.maxLength,
      keyboardType: TextInputType.phone,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      autovalidateMode: widget.autovalidateMode,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
    );
  }

  Future<void> _changeCountry() async {
    filteredCountries = _countryList;
    await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => StatefulBuilder(
        builder: (ctx, setState) => CountryPickerDialog(
          searchFieldInputDecoration: widget.searchFieldInputDecoration,
          filteredCountries: filteredCountries,
          countryList: _countryList,
          locale: widget.locale,
          selectedCountry: _selectedCountry,
          dialogTitle: widget.dialogTitle!,
          onCountryChanged: (Country country) {
            _selectedCountry = country;
            setState(() {});
          },
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  Widget _buildCountryCodeButton() {
    return InkWell(
      onTap: widget.enabled ? _changeCountry : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FittedBox(
              child: Text(
                '+${_selectedCountry.dialCode}',
              ),
            ),
            widget.dropdownIcon,
          ],
        ),
      ),
    );
  }
}
