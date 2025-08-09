# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2025-08-09

### 🚀 Major Features Added

- **Enhanced PhoneNumber Model**: Complete redesign with better validation, formatting, and serialization
- **Custom Theme Support**: Full theming capabilities with `PhoneTextFieldTheme`
- **Auto-formatting**: Real-time phone number formatting as users type
- **Advanced Validation**: Comprehensive validation with detailed error types and messages
- **Custom Input Formatters**: Country-specific phone number formatting
- **Improved Country Picker**: Enhanced dialog with better UX and customization options

### ✨ New Features

- **ValidationResult**: Detailed validation results with error types and messages
- **Phone Number Formatting**: Multiple format options (E164, national, formatted, etc.)
- **JSON Serialization**: Built-in `toJson()` and `fromJson()` methods
- **Custom Validators**: Support for custom validation functions
- **Enhanced Country View Options**: New display options including full format
- **Accessibility Support**: Better screen reader and keyboard navigation support
- **Performance Improvements**: Optimized rendering and state management

### 🎨 UI/UX Enhancements

- **Modern Dialog Design**: Completely redesigned country picker dialog
- **Better Search**: Improved country search with better filtering
- **Responsive Design**: Better adaptation to different screen sizes
- **Theme Integration**: Automatic dark/light theme support
- **RTL Support**: Enhanced right-to-left language support

### 🔧 Technical Improvements

- **Null Safety**: Full null-safety compliance
- **Better Error Handling**: Comprehensive exception types with meaningful messages
- **Code Quality**: Enhanced with linting rules and better documentation
- **Test Coverage**: Comprehensive test suite for all components
- **Dependencies**: Updated to latest Flutter and Dart versions

### 📚 Documentation

- **Complete API Documentation**: Detailed documentation for all classes and methods
- **Usage Examples**: Comprehensive examples for all features
- **Migration Guide**: Step-by-step guide for migrating from v1.x
- **Best Practices**: Guidelines for optimal usage

### 🛠 Breaking Changes

- **PhoneNumber Constructor**: Now requires named parameters and is immutable
- **Validation API**: `isValidNumber()` now throws typed exceptions
- **Theme System**: Complete redesign of theming system
- **Country View Options**: New enum values and behavior
- **Minimum Requirements**: Updated minimum Flutter and Dart versions

### 🐛 Bug Fixes

- Fixed country code parsing for numbers with leading zeros
- Resolved cursor position issues during formatting
- Fixed validation for edge cases in various countries
- Improved memory management in country picker dialog
- Fixed RTL layout issues in Arabic locale

### 🧪 Testing

- Added comprehensive unit tests for PhoneNumber model
- Added widget tests for PhoneTextField component
- Added formatter tests for all supported countries
- Added theme system tests
- Added validation tests for edge cases

### 📱 Example App

- Complete redesign of example application
- Multiple interactive examples showcasing all features
- Dark/light theme toggle
- Real-time validation demonstration
- Performance metrics display

## [1.0.0] - Previous Release

### Features

- Basic phone number input
- Country code selection
- Simple validation
- Basic localization support (Arabic, English, French)
- Country picker dialog

### Supported Countries

- All international countries with dial codes
- Flag emoji support
- Basic formatting

## [0.0.5] - Early Release

- Initial localization improvements

## [0.0.4] - Early Release

- Performance improvements

## [0.0.1] - Initial Release

- Basic phone text field implementation
- Country code selection
- Simple validation
