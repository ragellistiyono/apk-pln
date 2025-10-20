# [PROJECT NAME] Development Guidelines

Auto-generated from all feature plans. Last updated: [DATE]

**Constitution**: See `.specify/memory/constitution.md` for core principles

## Active Technologies
[EXTRACTED FROM ALL PLAN.MD FILES]

## Project Structure
```
[ACTUAL STRUCTURE FROM PLANS]
```

## Constitutional Requirements

All development MUST adhere to principles in `.specify/memory/constitution.md`:

1. **File Size Discipline**: Keep files under 700 lines (target 500)
2. **Code Quality**: Maintain modularity and single responsibility
3. **Testing Standards**: Comprehensive unit, widget, and integration tests
4. **UX Consistency**: Follow Material Design/iOS HIG conventions
5. **Performance**: Maintain 60 FPS, optimize memory and launch time
6. **Flutter/Dart Conventions**: snake_case files, PascalCase classes, proper import order

## Commands
[ONLY COMMANDS FOR ACTIVE TECHNOLOGIES]

## Code Style
[LANGUAGE-SPECIFIC, ONLY FOR LANGUAGES IN USE]

## Flutter/Dart Conventions (Per Constitution)

### File Naming
- Use snake_case: `user_profile_screen.dart`, `auth_service.dart`
- Descriptive names: `product_card_widget.dart` not `product.dart`

### Class Naming
- Use PascalCase: `UserProfileScreen`, `AuthService`
- Match file purpose: class in `auth_service.dart` named `AuthService`

### Import Order
1. Dart SDK imports
2. Flutter framework imports
3. Third-party package imports
4. Project imports (relative paths)

### Widget Organization
- Extract large widgets into separate files
- Keep widget files under 500 lines
- Separate business logic from UI (use Controllers/BLoCs)

### File Size Management
- Before editing: Check current file size
- If file > 500 lines: Extract to new file
- If new code > 700 lines: Split logically from start

## Recent Changes
[LAST 3 FEATURES AND WHAT THEY ADDED]

<!-- MANUAL ADDITIONS START -->
<!-- MANUAL ADDITIONS END -->
