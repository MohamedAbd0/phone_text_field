// ignore_for_file: always_use_package_imports, library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../constants/countries.dart';
import '../helper/helpers.dart';

class CountryPickerDialog extends StatefulWidget {
  final List<Country> countryList;
  final Country selectedCountry;
  final ValueChanged<Country> onCountryChanged;
  final List<Country> filteredCountries;
  final InputDecoration? searchFieldInputDecoration;
  final Locale locale;
  final String dialogTitle;

  const CountryPickerDialog({
    super.key,
    required this.countryList,
    required this.onCountryChanged,
    required this.selectedCountry,
    required this.filteredCountries,
    this.searchFieldInputDecoration,
    required this.dialogTitle,
    required this.locale,
  });

  @override
  _CountryPickerDialogState createState() => _CountryPickerDialogState();
}

class _CountryPickerDialogState extends State<CountryPickerDialog> {
  late List<Country> _filteredCountries;
  late Country _selectedCountry;

  @override
  void initState() {
    _selectedCountry = widget.selectedCountry;
    _filteredCountries = widget.filteredCountries;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              widget.dialogTitle,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: widget.searchFieldInputDecoration ??
                  const InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    hintText: 'Search by name or country code',
                  ),
              onChanged: (value) {
                _filteredCountries = isNumeric(value)
                    ? widget.countryList
                        .where(
                          (country) => country.dialCode.contains(
                            value.trim(),
                          ),
                        )
                        .toList()
                    : widget.locale.languageCode.toLowerCase() == "ar"
                        ? widget.countryList
                            .where(
                              (country) => country.nameAr
                                  .toLowerCase()
                                  .contains(value.toLowerCase().trim()),
                            )
                            .toList()
                        : widget.countryList
                            .where(
                              (country) => country.name
                                  .toLowerCase()
                                  .contains(value.toLowerCase().trim()),
                            )
                            .toList();
                if (mounted) setState(() {});
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredCountries.length,
              itemBuilder: (ctx, index) => ListTile(
                leading: Text(
                  _filteredCountries[index].flag,
                ),
                title: Text(
                  widget.locale.languageCode.toLowerCase() == "ar"
                      ? _filteredCountries[index].nameAr
                      : _filteredCountries[index].name,
                ),
                trailing: Text(
                  '+${_filteredCountries[index].dialCode}',
                ),
                onTap: () {
                  _selectedCountry = _filteredCountries[index];
                  widget.onCountryChanged(_selectedCountry);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
