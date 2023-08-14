import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:phone_text_field/phone_text_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      locale: const Locale('en'),
      //fallbackLocale: Locale('ar'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
        Locale('fr'),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Phone Text Field"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Basic Widget",
                  textScaleFactor: 1.5,
                ),
                PhoneTextField(
                  initialValue: '+201090718223',
                  initialCountryCode: '+971',
                  countryViewOptions: CountryViewOptions.countryCodeOnly,
                  showCountryCodeAsIcon: true,
                  onChanged: (value) {},
                ),
              ],
            ),
            Column(
              children: [
                const Text(
                  "Decoration Widget",
                  textScaleFactor: 1.5,
                ),
                const SizedBox(
                  height: 20,
                ),
                PhoneTextField(
                  locale: const Locale('en'),
                  decoration: const InputDecoration(
                    filled: true,
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(),
                    ),
                    prefixIcon: Icon(Icons.phone),
                    labelText: "Phone number",
                  ),
                  searchFieldInputDecoration: const InputDecoration(
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(),
                    ),
                    suffixIcon: Icon(Icons.search),
                    hintText: "Search country",
                  ),
                  initialCountryCode: "AE",
                  onChanged: (phone) {
                    debugPrint(phone.completeNumber);
                  },
                ),
              ],
            ),

/*
            Column(
              children: [
                const Text(
                  "Decoration Widget (ar)",
                  textScaleFactor: 1.5,
                ),
                const SizedBox(
                  height: 20,
                ),
                PhoneTextField(
                  locale: const Locale('ar'),
                  decoration: const InputDecoration(
                    filled: true,
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(),
                    ),
                    prefixIcon: Icon(Icons.phone),
                    labelText: "رقم الهاتف",
                  ),
                  searchFieldInputDecoration: const InputDecoration(
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(),
                    ),
                    suffixIcon: Icon(Icons.search),
                    hintText: "بحث عن بالاسم او الرمز",
                  ),
                  dialogTitle: "اختر الدوله",
                  initialCountryCode: "AE",
                  onChanged: (phone) {
                    debugPrint(phone.completeNumber);
                  },
                ),
              ],
            )
          
          */
          ],
        )),
      ),
    );
  }
}
