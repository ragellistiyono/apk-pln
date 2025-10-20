# apk_pln

A Flutter application for PLN with strict quality and performance standards.

## Development Guidelines

This project follows a comprehensive [**Project Constitution**](.specify/memory/constitution.md) that defines core development principles:

- ✅ **File Size Discipline**: All files kept under 700 lines (target 500)
- ✅ **Code Quality & Modularity**: Single responsibility, clear separation of concerns
- ✅ **Testing Standards**: Comprehensive unit, widget, and integration testing
- ✅ **UX Consistency**: Following Material Design and iOS HIG conventions
- ✅ **Performance Requirements**: 60 FPS target, optimized memory usage
- ✅ **Flutter/Dart Conventions**: Proper naming, structure, and best practices

**All contributors MUST review and follow the constitution principles.**

## Getting Started

This project is a Flutter application. To get started:

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK (included with Flutter)
- Android Studio / Xcode (for mobile development)

### Installation

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
dart format .
```

### Project Structure

```
lib/
  ├── main.dart           # Application entry point
  ├── screens/            # UI screens
  ├── widgets/            # Reusable widgets
  ├── models/             # Data models
  ├── services/           # Business logic and API services
  └── utils/              # Utility functions

test/
  ├── unit/               # Unit tests
  ├── widget/             # Widget tests
  └── integration/        # Integration tests
```

## Development Standards

### Before Contributing
1. Read [`.specify/memory/constitution.md`](.specify/memory/constitution.md)
2. Ensure your editor is configured for Dart/Flutter
3. Enable auto-format on save
4. Run tests before committing

### Quality Checks
- Keep files under 700 lines (target 500 lines)
- Write tests for all business logic and widgets
- Follow Flutter naming conventions (snake_case files, PascalCase classes)
- Maintain 60 FPS performance
- Ensure proper resource disposal (controllers, streams, etc.)

## Resources

Flutter development resources:
- [Flutter Documentation](https://docs.flutter.dev/)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Material Design Guidelines](https://m3.material.io/)

## License

[Add license information]
