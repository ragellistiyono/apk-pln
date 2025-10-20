# Implementation Plan: Internal Ticket Management System

**Branch**: `001-ticket-system` | **Date**: 2025-10-19 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-ticket-system/spec.md`

## Summary

Building a Flutter-based internal ticket management system for PLN with self-hosted REST API backend. The system enables employees to report technical issues, automatically matches them with appropriate technicians based on category/sub-category/region criteria, and provides real-time comment-based communication between parties. Three user roles (Employee, Technician, Admin) with distinct capabilities. Key features include intelligent technician matching across 7 regions, 5 problem categories, real-time notifications, and comprehensive ticket tracking with time elapsed display.

## Technical Context

**Language/Version**: Dart 3.9.4, Flutter 3.x (stable channel)
**Primary Dependencies**: 
- Frontend: flutter_bloc/provider (state management), http/dio (API client), sqflite/hive (local storage), web_socket_channel (real-time), shared_preferences (session)
- Backend: Node.js 22+ with Express OR Python 3.14 with FastAPI (recommend FastAPI for simplicity)
- Database: PostgreSQL 18

**Storage**: PostgreSQL (primary), SQLite (Flutter local cache)
**Testing**: Flutter: flutter_test, mockito; Backend: pytest/jest depending on choice
**Target Platform**: Android mobile (primary), iOS (secondary consideration)
**Project Type**: Mobile app with backend API (separate repositories recommended)
**Performance Goals**: 60 FPS UI, <30s ticket creation, <5s notifications, 100 concurrent users
**Constraints**: <200ms API response p95, offline-capable mobile app, real-time comment updates
**Scale/Scope**: ~300 employees, 11 technicians, ~50-100 tickets/day estimated

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Review the feature against `.specify/memory/constitution.md` principles:

- [x] **File Size Discipline**: Plan accounts for keeping files under 700 lines (target 500)
  - Flutter app: ~20-25 files (screens, widgets, models, services, state management)
  - Backend API: ~15-18 files (routes, models, services, middleware)
  - Each component scoped to single responsibility
  
- [x] **Code Quality & Modularity**: Design promotes single responsibility and clear separation of concerns
  - Flutter: Separate layers for UI, business logic (BLoC), data (repositories), models
  - Backend: Separate routes, services, data access, validation
  - Clear interfaces between components
  
- [x] **Testing Standards**: Test strategy covers unit, widget, and integration testing requirements
  - Unit tests: All business logic (matching algorithm, time tracking, validation)
  - Widget tests: All screens and custom widgets
  - Integration tests: Complete ticket workflows (create → accept → complete with comments)
  - API tests: All endpoints with authentication
  
- [x] **User Experience Consistency**: UI design follows Material/iOS guidelines and maintains consistency
  - Material Design 3 for Android primary target
  - Consistent color scheme, typography, spacing
  - Standard navigation patterns (bottom nav, app bar)
  - Loading states, error handling, offline indicators
  
- [x] **Performance Requirements**: Design considers 60 FPS, memory usage, and launch time targets
  - Lazy loading for ticket lists (pagination)
  - Efficient state management (selective rebuilds)
  - Image optimization (if added in v2)
  - Connection pooling and caching
  
- [x] **Flutter/Dart Conventions**: Architecture follows Flutter best practices and naming conventions
  - snake_case files, PascalCase classes
  - Feature-first folder structure
  - Proper import organization
  - BLoC/Provider pattern for state management

**Violations Requiring Justification**: None

## Project Structure

### Documentation (this feature)

```
specs/001-ticket-system/
├── plan.md              # This file (/speckit.plan command output)
├── spec.md              # Clarified specification
├── research.md          # Phase 0 output (to be created)
├── data-model.md        # Phase 1 output (to be created)
├── quickstart.md        # Phase 1 output (to be created)
├── contracts/           # Phase 1 output (to be created)
│   ├── api-endpoints.md
│   └── websocket-events.md
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root: /home/ragel/Documents/projek-it-pln-ktg/apk_pln)

**Option Selected**: Mobile + API (Flutter frontend + separate backend)

```
# Flutter Mobile App (current repository: /home/ragel/Documents/projek-it-pln-ktg/apk_pln)
lib/
├── main.dart                          # App entry point, routing
├── core/                              # Shared utilities
│   ├── constants/
│   │   ├── app_constants.dart         # Categories, regions, routes
│   │   └── api_constants.dart         # API endpoints, timeouts
│   ├── theme/
│   │   └── app_theme.dart             # Material Design theme
│   ├── utils/
│   │   ├── date_utils.dart            # Time formatting, elapsed calculation
│   │   └── validators.dart            # Input validation
│   └── errors/
│       └── exceptions.dart            # Custom exceptions
│
├── data/                              # Data layer
│   ├── models/                        # Data models (JSON serialization)
│   │   ├── user_model.dart            # Base user, Employee, Technician, Admin
│   │   ├── ticket_model.dart          # Ticket with status
│   │   ├── comment_model.dart         # Comment with user info
│   │   └── notification_model.dart    # Notification data
│   ├── repositories/                  # Data access abstraction
│   │   ├── auth_repository.dart       # Login, logout, token management
│   │   ├── ticket_repository.dart     # Ticket CRUD, filtering
│   │   ├── comment_repository.dart    # Comment CRUD
│   │   └── admin_repository.dart      # User management CRUD
│   └── datasources/                   # Concrete data sources
│       ├── local/
│       │   ├── local_storage.dart     # SQLite/Hive for cache
│       │   └── secure_storage.dart    # JWT token storage
│       └── remote/
│           ├── api_client.dart        # HTTP client wrapper
│           └── websocket_client.dart  # WebSocket for real-time
│
├── domain/                            # Business logic layer
│   ├── entities/                      # Pure business objects
│   │   ├── user.dart
│   │   ├── ticket.dart
│   │   └── comment.dart
│   ├── usecases/                      # Business operations
│   │   ├── auth/
│   │   │   ├── login_usecase.dart
│   │   │   └── logout_usecase.dart
│   │   ├── tickets/
│   │   │   ├── create_ticket_usecase.dart
│   │   │   ├── get_tickets_usecase.dart
│   │   │   ├── accept_ticket_usecase.dart
│   │   │   └── complete_ticket_usecase.dart
│   │   └── comments/
│   │       ├── add_comment_usecase.dart
│   │       └── get_comments_usecase.dart
│   └── repositories/                  # Repository interfaces
│       └── (interfaces for data layer)
│
├── presentation/                      # UI layer
│   ├── blocs/                         # State management (BLoC pattern)
│   │   ├── auth/
│   │   │   ├── auth_bloc.dart
│   │   │   ├── auth_event.dart
│   │   │   └── auth_state.dart
│   │   ├── ticket/
│   │   │   ├── ticket_bloc.dart
│   │   │   ├── ticket_event.dart
│   │   │   └── ticket_state.dart
│   │   ├── comment/
│   │   │   ├── comment_bloc.dart
│   │   │   ├── comment_event.dart
│   │   │   └── comment_state.dart
│   │   └── notification/
│   │       ├── notification_bloc.dart
│   │       ├── notification_event.dart
│   │       └── notification_state.dart
│   │
│   ├── screens/                       # Full-page screens
│   │   ├── auth/
│   │   │   └── login_screen.dart      # Login for all roles
│   │   ├── employee/
│   │   │   ├── employee_home_screen.dart
│   │   │   ├── create_ticket_screen.dart
│   │   │   ├── ticket_list_screen.dart
│   │   │   └── ticket_detail_screen.dart
│   │   ├── technician/
│   │   │   ├── technician_home_screen.dart
│   │   │   ├── ticket_queue_screen.dart
│   │   │   └── ticket_detail_screen.dart
│   │   └── admin/
│   │       ├── admin_home_screen.dart
│   │       ├── manage_employees_screen.dart
│   │       └── manage_technicians_screen.dart
│   │
│   └── widgets/                       # Reusable components
│       ├── common/
│       │   ├── app_button.dart
│       │   ├── app_text_field.dart
│       │   ├── loading_indicator.dart
│       │   └── error_message.dart
│       ├── ticket/
│       │   ├── ticket_card.dart       # List item
│       │   ├── ticket_status_chip.dart
│       │   ├── technician_selector.dart
│       │   └── time_elapsed_widget.dart
│       └── comment/
│           ├── comment_list.dart
│           ├── comment_item.dart
│           └── comment_input.dart
│
└── config/
    ├── routes.dart                    # Route definitions
    └── dependency_injection.dart      # Service locator setup

test/
├── unit/                              # Unit tests
│   ├── usecases/
│   ├── repositories/
│   └── blocs/
├── widget/                            # Widget tests
│   ├── screens/
│   └── widgets/
└── integration/                       # Integration tests
    └── ticket_flow_test.dart

# Backend API (separate repository recommended: ticket-api)
backend/
├── src/
│   ├── main.py (or index.ts)         # Entry point, server setup
│   ├── config/
│   │   ├── database.py                # PostgreSQL connection
│   │   └── settings.py                # Environment config
│   ├── models/                        # Database models (SQLAlchemy/Sequelize)
│   │   ├── user.py
│   │   ├── ticket.py
│   │   ├── comment.py
│   │   └── notification.py
│   ├── schemas/                       # Request/response validation (Pydantic)
│   │   ├── auth_schema.py
│   │   ├── ticket_schema.py
│   │   └── comment_schema.py
│   ├── services/                      # Business logic
│   │   ├── auth_service.py            # JWT generation, validation
│   │   ├── ticket_service.py          # Matching algorithm, status updates
│   │   ├── comment_service.py
│   │   └── notification_service.py
│   ├── routes/                        # API endpoints
│   │   ├── auth_routes.py
│   │   ├── ticket_routes.py
│   │   ├── comment_routes.py
│   │   ├── admin_routes.py
│   │   └── notification_routes.py
│   ├── middleware/
│   │   ├── auth_middleware.py         # JWT verification
│   │   └── error_handler.py
│   └── utils/
│       ├── technician_matcher.py      # Matching algorithm
│       └── time_tracker.py
│
└── tests/
    ├── test_auth.py
    ├── test_tickets.py
    └── test_matching.py

# Database migrations
migrations/
├── versions/
│   ├── 001_initial_schema.py
│   ├── 002_add_comments.py
│   └── 003_add_indexes.py
└── alembic.ini (or similar)
```

**Structure Decision**: 

Mobile + API architecture selected for clear separation of concerns and scalability:
- **Flutter App**: Located in current repository (`apk_pln`), focused on mobile UI/UX
- **Backend API**: Recommend separate repository (`pln-ticket-api`), can be deployed independently
- **Database**: PostgreSQL hosted on server, accessed only by backend
- **Communication**: REST API for CRUD operations, WebSocket for real-time notifications/comments

This separation enables:
- Independent deployment and scaling
- Clear team responsibilities (mobile vs backend developers)
- Backend can serve multiple clients (future web portal, etc.)
- Easier testing and mocking

## Complexity Tracking

*Fill ONLY if Constitution Check has violations that must be justified*

No violations. All design decisions align with constitution principles.

## Phase 0: Research & Prerequisites

**Duration**: 2-3 days

**Objectives**:
- Research Flutter state management patterns (BLoC vs Provider)
- Research WebSocket implementation for real-time features
- Research PostgreSQL connection pooling and indexing strategies
- Research JWT authentication best practices
- Confirm server infrastructure for backend deployment

**Deliverables**:
- `research.md` documenting:
  - State management choice justification
  - Real-time strategy (WebSocket vs polling)
  - Backend framework choice (FastAPI vs Express)
  - Deployment architecture diagram
  - Performance optimization strategies
  - Security considerations

## Phase 1: Design & Architecture

**Duration**: 3-5 days

**Objectives**:
- Design complete data model with relationships
- Define all API endpoints with request/response schemas
- Design WebSocket event protocol
- Create database schema with indexes
- Design matching algorithm pseudocode
- Define authentication flow
- Create UI wireframes for key screens

**Deliverables**:
- `data-model.md` containing:
  - ER diagram (User, Ticket, Comment, Notification relationships)
  - PostgreSQL table definitions
  - Enum definitions (Categories, Regions, Status)
  - Pre-populated data (11 technicians)
  - Index strategy for performance
  
- `contracts/api-endpoints.md`:
  - All 12+ REST endpoints with full specifications
  - Request/response schemas
  - Authentication requirements
  - Error responses
  - Rate limiting considerations
  
- `contracts/websocket-events.md`:
  - Event types (new_ticket, ticket_status_changed, new_comment)
  - Event payload schemas
  - Connection/reconnection protocol
  
- `quickstart.md`:
  - Development environment setup
  - Database initialization
  - Running backend locally
  - Running Flutter app with local backend
  - Test account credentials
  - Common troubleshooting

## Phase 2: Task Breakdown

**Objectives**:
- Break down implementation into ~50-70 discrete tasks
- Organize by user story for independent delivery
- Identify parallel work opportunities
- Estimate effort per task

**Command**: Use `/speckit.tasks` to generate detailed task list

**Expected Task Structure**:
- Setup phase (project init, dependencies)
- Foundation phase (auth, database, API structure)
- User Story 1 (P1): Employee ticket creation
- User Story 2 (P1): Technician ticket management
- User Story 3 (P1): Matching algorithm
- User Story 4 (P2): Admin CRUD
- User Story 5 (P2): Notifications
- User Story 6 (P3): History/reporting
- Polish phase (performance, documentation)

## Technical Risks & Mitigations

### Risk 1: Real-time Comment Performance
**Risk**: WebSocket connections for ~100 users might strain server
**Mitigation**: 
- Start with polling (5s interval) for MVP
- Implement WebSocket incrementally
- Use connection pooling and message queuing
- Load test early with 100+ simulated connections

### Risk 2: Offline Sync Conflicts
**Risk**: Comments created offline might conflict or duplicate
**Mitigation**:
- Use client-generated UUIDs for offline comments
- Implement conflict resolution (last-write-wins with timestamp)
- Show sync status clearly to users
- Test offline scenarios extensively

### Risk 3: Matching Algorithm Complexity
**Risk**: Edge cases in technician matching might cause incorrect assignments
**Mitigation**:
- Comprehensive unit tests covering all combinations
- Fallback to manual selection if no match
- Log all matching decisions for analysis
- Allow admin to view matching logic results

### Risk 4: File Size Management
**Risk**: Screens might exceed 500 line target with complex UI
**Mitigation**:
- Extract all widgets >100 lines to separate files
- Use widget composition over large widgets
- Separate UI from business logic strictly
- Regular refactoring reviews

### Risk 5: Backend Technology Choice
**Risk**: Team unfamiliar with chosen backend framework
**Mitigation**:
- Choose FastAPI for Python familiarity or Express for JavaScript familiarity
- Allocate extra time for learning in Phase 0
- Use well-documented patterns and examples
- Consider starting with simpler REST-only, add WebSocket later

## Success Metrics Tracking

From specification, tracking these throughout implementation:

- **SC-001**: Ticket creation time <30s (measure with analytics)
- **SC-002**: 95% automatic matching accuracy (log and analyze)
- **SC-003**: Notification delivery <5s (instrument with timestamps)
- **SC-004**: 100 concurrent users (load testing required)
- **SC-005**: Resolution time <48h for 80% (track in database)
- **SC-006**: 90% first-attempt success (user testing)
- **SC-007**: Zero data loss (integrity checks, backups)
- **SC-008**: Admin operations <10s (performance testing)
- **SC-009**: Comments <5s delivery (WebSocket/polling metrics)
- **SC-010**: Time display updates every minute (UI testing)

## Dependencies & Sequencing

### Critical Path
1. **Phase 0** (Research) → Must complete before Phase 1
2. **Phase 1** (Design) → Must complete before implementation starts
3. **Backend Setup** → Must be ready before Flutter can integrate
4. **Authentication** → Blocks all user stories
5. **User Stories P1** → Must complete before P2/P3

### Parallel Opportunities
- Backend and Flutter project setup can happen simultaneously
- Once auth is done, User Stories 1-3 can be developed in parallel by different developers
- Widget development can happen while API routes are being built (with mocked data)
- Testing can begin per-component as soon as that component is implemented

## Next Steps

1. **Complete Phase 0**: Create `research.md` by researching technical choices
2. **Complete Phase 1**: Create `data-model.md`, `contracts/`, and `quickstart.md`
3. **Generate Tasks**: Run `/speckit.tasks` command to create detailed task breakdown
4. **Set Up Repositories**: 
   - Initialize Flutter project structure in current repo
   - Create separate backend repository
   - Set up PostgreSQL database
5. **Begin Implementation**: Start with foundation (auth, database schema)

## Notes

- Constitution principles integrated throughout plan
- File size limits will be enforced via code review
- Testing is integrated per user story, not deferred to end
- Each user story independently deliverable and demonstrable
- Backend API design prioritizes simplicity over premature optimization
- Real-time features can be implemented incrementally (polling → WebSocket)
- Consider setting up CI/CD early for automated testing and deployment