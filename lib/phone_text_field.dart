// ignore_for_file: library_private_types_in_public_api

library phone_text_field;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_text_field/helper/extensions/string.dart';

import 'dialog/country_picker_dialog.dart';
import 'helper/countries.dart';
import 'phone_text_field.dart';
export 'model/country_code_view_options.dart' show CountryViewOptions;
export 'model/phone_number.dart' show PhoneNumber;

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

  /// to show country code as icon.
  ///
  /// Default is showCountryCodeAsIcon : false
  final bool showCountryCodeAsIcon;

  /// Message to be displayed on dialog title
  ///
  /// Default value is `Select Country`.
  final String? dialogTitle;

  /// TextStyle of TextFormField
  ///
  /// Default value is null.
  final TextStyle? textStyle;

  /// TextStyle of TextFormField when search
  ///
  /// Default value is null.
  final TextStyle? searchTextStyle;

  /// onSubmit of keypoard
  ///
  /// Default value is null.
  final ValueChanged<String>? onSubmit;

  /// to show country result data.
  /// If [CountryViewOptions.countryNameOnly], to show country name only.
  /// If [CountryViewOptions.countryNameWithFlag], to show country name with flag.
  /// If [CountryViewOptions.countryCodeOnly], to show country code only.
  /// If [CountryViewOptions.countryCodeWithFlag], to show country flag with code.
  /// If [CountryViewOptions.countryFlagOnly], to show country flag only.
  /// Default is countryViewOptions : [CountryViewOptions.countryCodeOnly]
  final CountryViewOptions countryViewOptions;

  const PhoneTextField({
    super.key,
    this.initialCountryCode,
    this.textAlign = TextAlign.left,
    this.isRequired = true,
    this.showCountryCodeAsIcon = false,
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
    this.onSubmit,
    this.textStyle,
    this.searchTextStyle,
    this.countryViewOptions = CountryViewOptions.countryCodeOnly,
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
    try {
      CountriesHelper.init(widget.locale.languageCode.toLowerCase());

      super.initState();

      _countryList = widget.countries == null
          ? countries
          : countries
              .where((country) => widget.countries!.contains(country.code))
              .toList();

      final List<Country> unSortcountryList = [..._countryList];
      unSortcountryList.sort((a, b) => a.name.compareTo(b.name));

      _countryList = unSortcountryList;
      filteredCountries = _countryList;
      number = widget.initialValue ?? '';

      if (widget.initialCountryCode != null) {
        final initCode = widget.initialCountryCode!.replaceAll('+', '');

        if (initCode.isInt) {
          if (_countryList.map((e) => e.dialCode).toList().contains(initCode)) {
            _selectedCountry = _countryList.firstWhere(
              (element) => element.dialCode == initCode,
              orElse: () => _countryList.first,
            );
          }
        } else {
          if (_countryList
              .map((e) => e.code)
              .toList()
              .contains(initCode.toUpperCase())) {
            _selectedCountry = _countryList.firstWhere(
              (element) => element.code == initCode.toUpperCase(),
              orElse: () => _countryList.first,
            );
          }
        }
      }

      if (number.startsWith('+')) {
        number = number.substring(1);
      }

      if (number.length > 1) {
        // parse initial value
        _selectedCountry = countries.firstWhere(
          (country) => number.startsWith(country.dialCode),
          orElse: () => _countryList.first,
        );

        // remove country code from the initial number value
        number = number.replaceFirst(
          RegExp("^${_selectedCountry.fullCountryCode}"),
          "",
        );
      }
    } catch (e) {
      _selectedCountry = _countryList.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: (widget.controller == null) ? number : null,
      style: widget.textStyle,
      textAlign: widget.textAlign,
      controller: widget.controller,
      focusNode: widget.focusNode,
      decoration: widget.showCountryCodeAsIcon
          ? widget.decoration.copyWith(
              prefixIcon: widget.locale.languageCode.toLowerCase() == "ar"
                  ? null
                  : _buildCountryCodeButton(),
              suffixIcon: widget.locale.languageCode.toLowerCase() == "ar"
                  ? _buildCountryCodeButton()
                  : null,
              counterText: '',
            )
          : widget.decoration.copyWith(
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
      textInputAction: TextInputAction.next,
      onFieldSubmitted: widget.onSubmit,
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
          searchTextStyle: widget.searchTextStyle,
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
                displayReult(widget.countryViewOptions),
                style: widget.textStyle,
              ),
            ),
            widget.dropdownIcon,
          ],
        ),
      ),
    );
  }

  String displayReult(CountryViewOptions countryViewOptions) {
    switch (countryViewOptions) {
      case CountryViewOptions.countryCodeOnly:
        return '+${_selectedCountry.dialCode}';
      case CountryViewOptions.countryNameOnly:
        return _selectedCountry.name;
      case CountryViewOptions.countryFlagOnly:
        return _selectedCountry.flag;
      case CountryViewOptions.countryCodeWithFlag:
        return '${_selectedCountry.flag} +${_selectedCountry.dialCode}';
      case CountryViewOptions.countryNameWithFlag:
        return '${_selectedCountry.flag} ${_selectedCountry.name}';
      default:
        return '+${_selectedCountry.dialCode}';
    }
  }
}
