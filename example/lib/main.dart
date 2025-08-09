import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:phone_text_field/phone_text_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phone Text Field Demo',
      debugShowCheckedModeBanner: false,
      locale: const Locale('en'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ar'), Locale('en'), Locale('fr')],
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: ThemeMode.system,
      home: const MyHomePage(),
    );
  }

  static ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2196F3),
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }

  static ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2196F3),
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;

  // Controllers for different examples
  final _basicController = TextEditingController();
  final _styledController = TextEditingController();
  final _validationController = TextEditingController();

  // Current phone numbers
  PhoneNumber? _basicPhoneNumber;
  PhoneNumber? _styledPhoneNumber;
  PhoneNumber? _validationPhoneNumber;
  PhoneNumber? _demoPhoneNumber;

  // Settings
  bool _isDarkMode = false;
  CountryViewOptions _currentViewOption =
      CountryViewOptions.countryCodeWithFlag;
  String _currentCountry = 'US';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _basicController.dispose();
    _styledController.dispose();
    _validationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          children: [
            Text('Phone Text Field Demo'),
            Text(
              'International Phone Input Widget',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
          ),
          if (isWeb) ...[
            IconButton(
              icon: const Icon(Icons.code),
              onPressed: _showSourceCode,
              tooltip: 'View Source Code',
            ),
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: _showAboutDialog,
              tooltip: 'About',
            ),
          ],
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: !isWeb,
          tabs: const [
            Tab(icon: Icon(Icons.home), text: 'Overview'),
            Tab(icon: Icon(Icons.phone), text: 'Examples'),
            Tab(icon: Icon(Icons.settings), text: 'Playground'),
          ],
        ),
      ),
      body: Theme(
        data: _isDarkMode
            ? ThemeData.dark().copyWith(useMaterial3: true)
            : Theme.of(context),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(isWeb),
            _buildExamplesTab(isWeb),
            _buildPlaygroundTab(isWeb),
          ],
        ),
      ),
    );
  }

  // Overview Tab
  Widget _buildOverviewTab(bool isWeb) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isWeb ? 32 : 16),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isWeb ? 800 : double.infinity),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeroSection(),
              const SizedBox(height: 32),
              _buildFeaturesGrid(isWeb),
              const SizedBox(height: 32),
              _buildQuickDemo(),
              const SizedBox(height: 32),
              _buildGitHubLinks(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(
              Icons.phone_android,
              size: 64,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            Text(
              'Flutter Phone Text Field',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'A comprehensive international phone number input widget with validation, formatting, and country selection for Flutter applications.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildFeatureChip('🌍 200+ Countries'),
                _buildFeatureChip('📱 Auto Formatting'),
                _buildFeatureChip('✅ Validation'),
                _buildFeatureChip('🎨 Customizable'),
                _buildFeatureChip('🌙 Dark Mode'),
                _buildFeatureChip('📱 Responsive'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureChip(String label) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }

  Widget _buildFeaturesGrid(bool isWeb) {
    final features = [
      {
        'icon': Icons.language,
        'title': 'International Support',
        'description':
            'Support for 200+ countries with proper validation rules',
      },
      {
        'icon': Icons.format_align_left,
        'title': 'Auto Formatting',
        'description': 'Automatic number formatting based on country standards',
      },
      {
        'icon': Icons.verified,
        'title': 'Validation',
        'description': 'Built-in validation with customizable error messages',
      },
      {
        'icon': Icons.palette,
        'title': 'Customizable',
        'description': 'Flexible styling and decoration options',
      },
      {
        'icon': Icons.settings,
        'title': 'Controller Support',
        'description':
            'Full TextEditingController support for form integration',
      },
      {
        'icon': Icons.bug_report,
        'title': 'Bug Fixes',
        'description':
            'Resolved +1 country codes, Chinese numbers, and controller issues',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWeb ? 3 : 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: isWeb ? 1.2 : 1,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  feature['icon'] as IconData,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 8),
                Text(
                  feature['title'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  feature['description'] as String,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickDemo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Demo',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            PhoneTextField(
              initialCountryCode: 'US',
              decoration: const InputDecoration(
                labelText: 'Try entering a phone number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              onChanged: (phoneNumber) {
                setState(() {
                  _demoPhoneNumber = phoneNumber;
                });
              },
            ),
            if (_demoPhoneNumber != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Formatted Number:',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Text(
                      _demoPhoneNumber!.completeNumber,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Country: ${_demoPhoneNumber!.countryISOCode}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGitHubLinks() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(
              Icons.code,
              size: 48,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Open Source',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This package is open source and available on GitHub. Contributions are welcome!',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () =>
                      _copyToClipboard('flutter pub add phone_text_field'),
                  icon: const Icon(Icons.content_copy),
                  label: const Text('Copy Install Command'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showSourceCode(),
                  icon: const Icon(Icons.code),
                  label: const Text('View Source'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Examples Tab
  Widget _buildExamplesTab(bool isWeb) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isWeb ? 32 : 16),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isWeb ? 800 : double.infinity),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildBasicExample(),
                const SizedBox(height: 24),
                _buildStyledExample(),
                const SizedBox(height: 24),
                _buildValidationExample(),
                const SizedBox(height: 24),
                _buildCountryOptionsExample(),
                const SizedBox(height: 24),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicExample() {
    return _buildExampleCard(
      title: 'Basic Usage',
      description: 'Simple phone input with default settings',
      code: '''PhoneTextField(
  onChanged: (phoneNumber) {
    print(phoneNumber.completeNumber);
  },
)''',
      child: PhoneTextField(
        controller: _basicController,
        onChanged: (phoneNumber) {
          setState(() {
            _basicPhoneNumber = phoneNumber;
          });
        },
      ),
      phoneNumber: _basicPhoneNumber,
    );
  }

  Widget _buildStyledExample() {
    return _buildExampleCard(
      title: 'Custom Styling',
      description: 'Customized appearance with Material 3 design',
      code: '''PhoneTextField(
  decoration: InputDecoration(
    filled: true,
    labelText: 'Phone Number',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    prefixIcon: Icon(Icons.phone),
  ),
  countryViewOptions: CountryViewOptions.countryCodeWithFlag,
)''',
      child: PhoneTextField(
        controller: _styledController,
        decoration: InputDecoration(
          filled: true,
          labelText: 'Phone Number',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          prefixIcon: const Icon(Icons.phone),
        ),
        countryViewOptions: CountryViewOptions.countryCodeWithFlag,
        initialCountryCode: 'AE',
        onChanged: (phoneNumber) {
          setState(() {
            _styledPhoneNumber = phoneNumber;
          });
        },
      ),
      phoneNumber: _styledPhoneNumber,
    );
  }

  Widget _buildValidationExample() {
    return _buildExampleCard(
      title: 'Validation & Error Handling',
      description: 'Form validation with custom error messages',
      code: '''PhoneTextField(
  isRequired: true,
  invalidNumberMessage: 'Please enter a valid phone number',
  autovalidateMode: AutovalidateMode.onUserInteraction,
)''',
      child: PhoneTextField(
        controller: _validationController,
        isRequired: true,
        invalidNumberMessage: 'Please enter a valid phone number',
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: const InputDecoration(
          labelText: 'Required Phone Number',
          border: OutlineInputBorder(),
          helperText: 'This field is required and validated',
        ),
        onChanged: (phoneNumber) {
          setState(() {
            _validationPhoneNumber = phoneNumber;
          });
        },
      ),
      phoneNumber: _validationPhoneNumber,
    );
  }

  Widget _buildCountryOptionsExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Country Display Options',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            const Text('Different ways to display country information'),
            const SizedBox(height: 16),
            ...CountryViewOptions.values.map((option) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: PhoneTextField(
                    key: ValueKey(option),
                    countryViewOptions: option,
                    initialCountryCode: 'US',
                    decoration: InputDecoration(
                      labelText: _getOptionLabel(option),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (phoneNumber) {},
                  ),
                )),
          ],
        ),
      ),
    );
  }

  // Bug Fixes Tab
  Widget _buildBugFixesTab(bool isWeb) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isWeb ? 32 : 16),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isWeb ? 800 : double.infinity),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildBugFixCard(
                '🐛 Controller Problem #2',
                'Fixed: Late initialization error with controller property',
                'The controller property was commented out causing runtime errors. Now properly supports both provided and auto-created controllers.',
                'Before: //final TextEditingController? controller;\nAfter: final TextEditingController? controller;',
              ),
              const SizedBox(height: 16),
              _buildBugFixCard(
                '🇺🇸🇨🇦 +1 Country Code Issue #3',
                'Fixed: Flag switching between US and Canada',
                'When editing numbers with +1 country codes (US, Canada, etc.), the flag would incorrectly switch to Canada. Now preserves the originally selected country.',
                'Improved country selection logic to prioritize currently selected country when multiple countries share the same dial code.',
              ),
              const SizedBox(height: 16),
              _buildBugFixCard(
                '🇨🇳 Chinese Phone Number Length #4',
                'Fixed: Incorrect validation for Chinese numbers',
                'Chinese phone numbers are 11 digits long, but the library was configured for 12 digits, causing validation errors.',
                'Before: minLength: 12, maxLength: 12\nAfter: minLength: 11, maxLength: 11',
              ),
              const SizedBox(height: 24),
              _buildTestSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBugFixCard(
      String title, String summary, String description, String fix) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              summary,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                fix,
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Test the Fixes',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // Test +1 countries
            const Text('Test +1 Country Code Fix:'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: PhoneTextField(
                    initialCountryCode: 'US',
                    initialValue: '+15551234567',
                    decoration: const InputDecoration(
                      labelText: 'US Number',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (phoneNumber) {},
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: PhoneTextField(
                    initialCountryCode: 'CA',
                    initialValue: '+15551234567',
                    decoration: const InputDecoration(
                      labelText: 'CA Number',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (phoneNumber) {},
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Test Chinese number
            const Text('Test Chinese Number Fix:'),
            const SizedBox(height: 8),
            PhoneTextField(
              initialCountryCode: 'CN',
              decoration: const InputDecoration(
                labelText: 'Chinese Number (11 digits)',
                helperText: 'Try: 13812345678',
                border: OutlineInputBorder(),
              ),
              onChanged: (phoneNumber) {},
            ),
          ],
        ),
      ),
    );
  }

  // Playground Tab
  Widget _buildPlaygroundTab(bool isWeb) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isWeb ? 32 : 16),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isWeb ? 800 : double.infinity),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPlaygroundControls(),
              const SizedBox(height: 24),
              _buildPlaygroundDemo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaygroundControls() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Playground Settings',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // Country View Options
            const Text('Country Display Style:'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: CountryViewOptions.values.map((option) {
                return ChoiceChip(
                  label: Text(_getOptionLabel(option)),
                  selected: _currentViewOption == option,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _currentViewOption = option;
                      });
                    }
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Initial Country
            const Text('Initial Country:'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                'US',
                'CA',
                'GB',
                'AE',
                'CN',
                'IN',
                'BR',
                'DE',
                'FR',
                'JP'
              ].map((country) {
                return ChoiceChip(
                  label: Text(country),
                  selected: _currentCountry == country,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _currentCountry = country;
                      });
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaygroundDemo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Live Demo',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            PhoneTextField(
              key: ValueKey('${_currentViewOption}_${_currentCountry}'),
              initialCountryCode: _currentCountry,
              countryViewOptions: _currentViewOption,
              decoration: const InputDecoration(
                labelText: 'Playground Phone Number',
                border: OutlineInputBorder(),
                helperText: 'Customize the settings above to see changes',
              ),
              onChanged: (phoneNumber) {
                // Handle phone number changes
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper Methods
  String _getOptionLabel(CountryViewOptions option) {
    switch (option) {
      case CountryViewOptions.countryCodeOnly:
        return 'Code Only';
      case CountryViewOptions.countryNameOnly:
        return 'Name Only';
      case CountryViewOptions.countryFlagOnly:
        return 'Flag Only';
      case CountryViewOptions.countryCodeWithFlag:
        return 'Code + Flag';
      case CountryViewOptions.countryNameWithFlag:
        return 'Name + Flag';
    }
  }

  Widget _buildExampleCard({
    required String title,
    required String description,
    required String code,
    required Widget child,
    PhoneNumber? phoneNumber,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 16),
            child,
            if (phoneNumber != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Output:',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Text('Number: ${phoneNumber.completeNumber}'),
                    Text('Country: ${phoneNumber.countryISOCode}'),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            ExpansionTile(
              title: const Text('View Code'),
              tilePadding: EdgeInsets.zero,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    code,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All phone numbers are valid! ✅'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fix validation errors ❌'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Validate All Fields'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              _formKey.currentState?.reset();
              _basicController.clear();
              _styledController.clear();
              _validationController.clear();
              setState(() {
                _basicPhoneNumber = null;
                _styledPhoneNumber = null;
                _validationPhoneNumber = null;
                _demoPhoneNumber = null;
              });
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Reset All Fields'),
          ),
        ),
      ],
    );
  }

  void _showSourceCode() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Source Code'),
        content: const SingleChildScrollView(
          child: Text('''
// Add to pubspec.yaml
dependencies:
  phone_text_field: ^latest_version

// Basic usage
PhoneTextField(
  onChanged: (phoneNumber) {
    print(phoneNumber.completeNumber);
  },
)

// With custom styling
PhoneTextField(
  decoration: InputDecoration(
    labelText: 'Phone Number',
    border: OutlineInputBorder(),
  ),
  initialCountryCode: 'US',
  countryViewOptions: CountryViewOptions.countryCodeWithFlag,
  onChanged: (phoneNumber) {
    // Handle phone number changes
  },
)
          '''),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              _copyToClipboard('flutter pub add phone_text_field');
              Navigator.of(context).pop();
            },
            child: const Text('Copy Install Command'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Phone Text Field Demo',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.phone_android, size: 48),
      children: const [
        Text(
            'A comprehensive Flutter package for international phone number input with validation and formatting.'),
        SizedBox(height: 16),
        Text('Features:'),
        Text('• 200+ countries support'),
        Text('• Auto formatting'),
        Text('• Validation'),
        Text('• Customizable UI'),
        Text('• Controller support'),
        Text('• Bug fixes for common issues'),
      ],
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied: $text'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
