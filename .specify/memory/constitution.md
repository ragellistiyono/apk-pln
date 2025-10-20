<!--
Sync Impact Report - Constitution v1.0.0
────────────────────────────────────────
VERSION CHANGE: Initial creation → 1.0.0
RATIFICATION: 2025-10-19

PRINCIPLES ESTABLISHED:
✓ I. File Size Discipline (NEW)
✓ II. Code Quality & Modularity (NEW)
✓ III. Testing Standards (NEW)
✓ IV. User Experience Consistency (NEW)
✓ V. Performance Requirements (NEW)
✓ VI. Flutter/Dart Conventions (NEW)

TEMPLATES STATUS:
✅ plan-template.md - Constitution Check section ready for validation
✅ spec-template.md - Requirements alignment verified
✅ tasks-template.md - Task categorization supports principles
✅ agent-file-template.md - Reviewed for consistency
✅ checklist-template.md - Reviewed for consistency

FOLLOW-UP ACTIONS:
- None - All principles defined and documented
- Templates reviewed and compatible with new constitution
-->

# APK PLN Constitution

## Core Principles

### I. File Size Discipline (NON-NEGOTIABLE)

**Every source file MUST adhere to strict size limits to maintain code readability, modularity, and maintainability:**

- **Hard Maximum**: 700 lines of code (excluding comments and blank lines)
- **Target Size**: 500 lines or less per file
- **Pre-Edit Check**: ALWAYS verify current file size before adding or modifying code
- **Enforcement Rules**:
  - Files < 500 lines: Code may be added directly
  - Files 500-700 lines: NO additions permitted - extract functionality to new file
  - Files > 700 lines: MUST refactor immediately into multiple files
  - New files projected to exceed 700 lines: MUST split into multiple logical modules

**Rationale**: Large files become difficult to navigate, understand, and maintain. Size limits enforce single responsibility principle, improve code review efficiency, reduce merge conflicts, and make testing more focused. In Flutter development, this prevents monolithic widgets and encourages component reuse.

### II. Code Quality & Modularity

**All code MUST maintain high standards of readability, organization, and separation of concerns:**

- **Modularity**: Code MUST be organized into cohesive, loosely-coupled modules
- **Single Responsibility**: Each file, class, and function MUST have one clear purpose
- **Naming Clarity**: Names MUST be descriptive, unambiguous, and follow conventions
- **Documentation**: Public APIs MUST include doc comments explaining purpose, parameters, and return values
- **Code Reusability**: Extract common patterns into shared utilities/widgets
- **Refactoring Triggers**:
  - File approaching 500 lines → plan extraction
  - Duplicated code patterns → create shared utilities
  - Complex conditional logic → extract to named functions
  - Large widget trees → split into smaller widgets

**Rationale**: Quality and modularity are foundational to long-term maintainability. Well-structured code reduces cognitive load, enables confident changes, facilitates onboarding, and allows independent evolution of features.

### III. Testing Standards

**Testing MUST be comprehensive, automated, and integrated into the development workflow:**

- **Test Coverage**: All business logic MUST have unit tests
- **Widget Testing**: All custom widgets MUST have widget tests verifying UI behavior
- **Integration Testing**: Critical user journeys MUST have integration tests
- **Test Organization**: Tests MUST mirror source structure (test/feature_test.dart for lib/feature.dart)
- **Test Quality Standards**:
  - Tests MUST be independent and repeatable
  - Tests MUST have clear arrange-act-assert structure
  - Tests MUST use descriptive names explaining what is tested
  - Mock external dependencies appropriately
  - Avoid testing implementation details
- **Continuous Validation**: Tests MUST pass before merging changes

**Rationale**: Comprehensive testing enables confident refactoring, prevents regressions, serves as living documentation, and enables rapid iteration. In Flutter, well-tested widgets and business logic form a safety net for UI changes.

### IV. User Experience Consistency

**The application MUST provide a consistent, intuitive, and polished user experience:**

- **Design System**: MUST maintain consistent spacing, typography, colors, and component styling
- **Navigation Patterns**: MUST use predictable, standard navigation patterns
- **Feedback & States**: MUST provide clear feedback for user actions, loading states, and errors
- **Accessibility**: MUST support screen readers, appropriate contrast ratios, and touch targets (min 48x48dp)
- **Responsive Design**: MUST adapt gracefully to different screen sizes and orientations
- **Platform Conventions**: MUST respect Material Design (Android) and Human Interface Guidelines (iOS) where appropriate
- **Performance Feel**: MUST maintain 60 FPS animations and responsive interactions

**Rationale**: Consistency builds user trust and reduces cognitive load. Users should never be confused about how to interact with the application. A polished UX directly impacts user satisfaction and adoption.

### V. Performance Requirements

**The application MUST meet strict performance standards to ensure smooth user experience:**

- **Frame Rate**: MUST maintain 60 FPS (16ms per frame) during normal operation
- **Launch Time**: Cold start MUST complete within 3 seconds on target devices
- **Memory Usage**: MUST stay within reasonable bounds (avoid memory leaks, dispose resources properly)
- **Network Efficiency**: MUST minimize unnecessary network calls, implement caching where appropriate
- **Build Size**: MUST monitor and control APK/IPA size (avoid unnecessary dependencies)
- **Performance Monitoring**:
  - Use Flutter DevTools to profile performance
  - Identify and optimize expensive builds
  - Implement lazy loading for heavy resources
  - Use const constructors where possible
  - Avoid unnecessary rebuilds

**Rationale**: Performance directly impacts user satisfaction. Laggy applications frustrate users and damage reputation. Flutter's performance capabilities should be leveraged, not squandered by inefficient code.

### VI. Flutter/Dart Conventions

**All code MUST follow Flutter and Dart language conventions and best practices:**

- **File Naming**: MUST use snake_case for all file names (e.g., user_profile_screen.dart)
- **Class Naming**: MUST use PascalCase for class names (e.g., UserProfileScreen)
- **Variable Naming**: MUST use lowerCamelCase for variables and functions (e.g., userName, fetchUserData())
- **Import Organization**: MUST organize imports in order: Dart → Flutter → Packages → Project
- **Widget Organization**:
  - Separate large widgets into smaller, reusable components
  - Use proper folder structure (screens/, widgets/, models/, services/)
  - Extract business logic from UI (use Controllers, BLoCs, or Providers)
- **State Management**: MUST use consistent state management approach across the application
- **Null Safety**: MUST leverage Dart's null safety features properly
- **Async/Await**: MUST handle asynchronous operations properly with error handling
- **Resource Management**: MUST properly dispose controllers, streams, and subscriptions

**Rationale**: Following language conventions ensures code is immediately familiar to any Flutter developer. It reduces mental overhead, enables better tooling support, and aligns with community practices and examples.

## Development Standards

### Code Organization

- **Feature-First Structure**: Organize code by feature/domain rather than technical layers
- **Separation of Concerns**: Clearly separate UI, business logic, data access, and models
- **Dependency Management**: Avoid circular dependencies; use dependency injection where appropriate
- **Configuration Management**: Externalize configuration; use environment variables for sensitive data

### Code Review Requirements

- **Self-Review**: Author MUST review their own changes before requesting review
- **Constitution Compliance**: Reviewer MUST verify adherence to all principles
- **File Size Check**: Reviewer MUST verify no files exceed 700 lines
- **Test Coverage**: Reviewer MUST verify appropriate tests exist and pass
- **Documentation**: Reviewer MUST verify public APIs are documented

### Quality Gates

All changes MUST pass these gates before merging:

1. **Compilation**: Code MUST compile without errors or warnings
2. **Tests**: All tests MUST pass (unit, widget, integration)
3. **Linting**: Code MUST pass `flutter analyze` with no issues
4. **Formatting**: Code MUST be formatted with `dart format`
5. **Constitution Check**: No principle violations unless explicitly justified

## Governance

### Constitution Authority

- This constitution supersedes all other development practices and guidelines
- All team members MUST be familiar with these principles
- All code reviews MUST verify compliance with this constitution
- Any deviation from principles MUST be explicitly documented and justified

### Amendment Process

1. **Proposal**: Submit proposed amendment with clear rationale
2. **Discussion**: Team reviews impact and alternatives
3. **Approval**: Requires consensus from technical leadership
4. **Migration**: Create migration plan if changes affect existing code
5. **Version Update**: Increment version according to semantic versioning
6. **Documentation**: Update all dependent templates and documentation

### Versioning Policy

- **MAJOR**: Backward-incompatible governance changes, principle removals/redefinitions
- **MINOR**: New principles added, material expansion of guidance
- **PATCH**: Clarifications, wording improvements, non-semantic refinements

### Compliance Review

- **Continuous**: Principles enforced during code review
- **Periodic**: Quarterly review of constitution relevance and effectiveness
- **Retrospective**: After major releases, assess principle adherence and update if needed

### Complexity Budget

Any violation of principles MUST be justified by documenting:
- **What**: Specific principle being violated
- **Why**: Why the violation is necessary
- **Alternatives**: Why simpler approaches were rejected
- **Plan**: Plan to resolve the violation if temporary

**Version**: 1.0.0 | **Ratified**: 2025-10-19 | **Last Amended**: 2025-10-19
