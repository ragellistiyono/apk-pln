---
description: "Task list for Internal Ticket Management System implementation"
---

# Tasks: Internal Ticket Management System

**Input**: Design documents from `/specs/001-ticket-system/`
**Prerequisites**: plan.md (complete), spec.md (complete and clarified)

**Tests**: Tests are included as this is a production system requiring quality assurance.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`
- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (Setup, Foundation, US1, US2, US3, US4, US5, US6)
- Include exact file paths in descriptions

## Path Conventions
- **Flutter app**: `lib/` in current workspace (`/home/ragel/Documents/projek-it-pln-ktg/apk_pln`)
- **Backend API**: Separate repository (recommend creating `backend/` or separate repo)
- All paths assume Flutter project structure from plan.md

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure for both Flutter and Backend

**Constitution Alignment**: Establish foundation for quality, testing, and conventions

- [ ] T001 Create Flutter project folder structure per plan.md in lib/ (core/, data/, domain/, presentation/)
- [ ] T002 [P] Add Flutter dependencies to pubspec.yaml (flutter_bloc, dio, sqflite, web_socket_channel, shared_preferences, mockito)
- [ ] T003 [P] Configure flutter_test for unit/widget/integration testing in test/ directory
- [ ] T004 [P] Setup lint rules in analysis_options.yaml (enforce 700 line limit warnings)
- [ ] T005 Create Backend project structure (src/models/, src/routes/, src/services/, src/middleware/)
- [ ] T006 [P] Initialize Backend with FastAPI/Express and add dependencies (PostgreSQL driver, JWT library, WebSocket support)
- [ ] T007 [P] Setup Backend testing framework (pytest for Python or jest for Node.js)
- [ ] T008 Create PostgreSQL database and user with appropriate permissions
- [ ] T009 [P] Setup database migration tool (Alembic for Python or similar)
- [ ] T010 [P] Create .env files for both Flutter and Backend with configuration templates

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**Constitution Alignment**: Establish patterns for modularity, testing, and performance

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

### Backend Foundation

- [ ] T011 Create database schema: users table in backend/migrations/versions/001_initial_schema.py
- [ ] T012 Create database schema: tickets table with foreign keys in backend/migrations/versions/001_initial_schema.py
- [ ] T013 Create database schema: comments table with foreign keys in backend/migrations/versions/001_initial_schema.py
- [ ] T014 Create database schema: notifications table in backend/migrations/versions/001_initial_schema.py
- [ ] T015 [P] Create indexes on tickets(employee_id, technician_id, status, created_at) in backend/migrations/versions/002_add_indexes.py
- [ ] T016 [P] Create indexes on comments(ticket_id, created_at) in backend/migrations/versions/002_add_indexes.py
- [ ] T017 Run migrations to create all tables and seed data (11 technicians) in database
- [ ] T018 Create User model in backend/src/models/user.py (Employee, Technician, Admin)
- [ ] T019 [P] Create Ticket model in backend/src/models/ticket.py
- [ ] T020 [P] Create Comment model in backend/src/models/comment.py
- [ ] T021 [P] Create Notification model in backend/src/models/notification.py
- [ ] T022 Create JWT authentication service in backend/src/services/auth_service.py (generate/verify tokens)
- [ ] T023 Create authentication middleware in backend/src/middleware/auth_middleware.py (verify JWT on protected routes)
- [ ] T024 Create auth routes in backend/src/routes/auth_routes.py (POST /api/auth/login, POST /api/auth/refresh)
- [ ] T025 [P] Create error handler middleware in backend/src/middleware/error_handler.py
- [ ] T026 Setup CORS and security headers in backend main file

### Flutter Foundation

- [ ] T027 Create app constants in lib/core/constants/app_constants.dart (Categories enum, Regions enum, Status enum)
- [ ] T028 [P] Create API constants in lib/core/constants/api_constants.dart (base URL, endpoints, timeout values)
- [ ] T029 [P] Create Material Design theme in lib/core/theme/app_theme.dart (colors, typography, component themes)
- [ ] T030 Create base User model in lib/data/models/user_model.dart with JSON serialization
- [ ] T031 [P] Create Ticket model in lib/data/models/ticket_model.dart with JSON serialization
- [ ] T032 [P] Create Comment model in lib/data/models/comment_model.dart with JSON serialization
- [ ] T033 [P] Create Notification model in lib/data/models/notification_model.dart with JSON serialization
- [ ] T034 Create HTTP API client wrapper in lib/data/datasources/remote/api_client.dart (dio configuration, interceptors)
- [ ] T035 [P] Create secure storage for JWT tokens in lib/data/datasources/local/secure_storage.dart
- [ ] T036 Create auth repository in lib/data/repositories/auth_repository.dart (login, logout, token refresh)
- [ ] T037 Create auth BLoC in lib/presentation/blocs/auth/ (auth_bloc.dart, auth_event.dart, auth_state.dart)
- [ ] T038 Create login screen in lib/presentation/screens/auth/login_screen.dart (username/password form)
- [ ] T039 [P] Create common widgets in lib/presentation/widgets/common/ (app_button.dart, app_text_field.dart, loading_indicator.dart, error_message.dart)
- [ ] T040 Setup routing in lib/config/routes.dart (define all route names and navigation logic)
- [ ] T041 Setup dependency injection in lib/config/dependency_injection.dart (register repositories, blocs, services)
- [ ] T042 Update main.dart with BLoC providers, routing, and theme

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - Employee Creates and Tracks Ticket (Priority: P1) 🎯 MVP

**Goal**: Employee can create tickets, select appropriate technician, and view their ticket status

**Independent Test**: Employee logs in, creates ticket, sees it in their list, receives updates when technician accepts/completes

### Tests for User Story 1 ⚠️

**NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [ ] T043 [P] [US1] Integration test for employee ticket creation flow in test/integration/employee_ticket_flow_test.dart
- [ ] T044 [P] [US1] Unit test for technician matching logic in backend/tests/test_matching.py
- [ ] T045 [P] [US1] Widget test for create ticket screen in test/widget/create_ticket_screen_test.dart
- [ ] T046 [P] [US1] Widget test for ticket list screen in test/widget/ticket_list_screen_test.dart
- [ ] T047 [P] [US1] API test for POST /api/tickets endpoint in backend/tests/test_tickets.py

### Backend Implementation for User Story 1

- [ ] T048 [US1] Implement technician matching algorithm in backend/src/utils/technician_matcher.py (category + sub-category + region logic)
- [ ] T049 [US1] Create ticket service in backend/src/services/ticket_service.py (create ticket, match technician, get tickets by employee)
- [ ] T050 [US1] Create ticket routes in backend/src/routes/ticket_routes.py (POST /api/tickets, GET /api/tickets, GET /api/tickets/:id)
- [ ] T051 [US1] Add GET /api/technicians endpoint in backend/src/routes/ticket_routes.py for technician list with filtering

### Flutter Implementation for User Story 1

- [ ] T052 [P] [US1] Create ticket repository in lib/data/repositories/ticket_repository.dart (create, get, filter methods)
- [ ] T053 [US1] Create ticket use cases in lib/domain/usecases/tickets/ (create_ticket_usecase.dart, get_tickets_usecase.dart)
- [ ] T054 [US1] Create ticket BLoC in lib/presentation/blocs/ticket/ (ticket_bloc.dart, ticket_event.dart, ticket_state.dart)
- [ ] T055 [US1] Create employee home screen in lib/presentation/screens/employee/employee_home_screen.dart with bottom navigation
- [ ] T056 [US1] Create ticket list screen in lib/presentation/screens/employee/ticket_list_screen.dart with filtering by status
- [ ] T057 [US1] Create create ticket screen in lib/presentation/screens/employee/create_ticket_screen.dart (description, category, sub-category selection)
- [ ] T058 [US1] Create technician selector widget in lib/presentation/widgets/ticket/technician_selector.dart (shows matched technicians)
- [ ] T059 [P] [US1] Create ticket card widget in lib/presentation/widgets/ticket/ticket_card.dart (display in list)
- [ ] T060 [P] [US1] Create ticket status chip widget in lib/presentation/widgets/ticket/ticket_status_chip.dart (pending/in-progress/completed)
- [ ] T061 [US1] Create ticket detail screen in lib/presentation/screens/employee/ticket_detail_screen.dart (view ticket info, status, resolution)
- [ ] T062 [P] [US1] Create time elapsed widget in lib/presentation/widgets/ticket/time_elapsed_widget.dart (display time since creation)
- [ ] T063 [US1] Add validation in lib/core/utils/validators.dart (description length, required fields)

**Checkpoint**: At this point, employees can create tickets, select technicians, and view their ticket list

---

## Phase 4: User Story 2 - Technician Receives and Resolves Tickets (Priority: P1) 🎯 MVP

**Goal**: Technician receives assigned tickets, accepts them, and marks them complete with notes

**Independent Test**: Technician logs in, sees assigned tickets, accepts one, marks it complete with resolution notes

### Tests for User Story 2 ⚠️

- [ ] T064 [P] [US2] Integration test for technician ticket workflow in test/integration/technician_ticket_flow_test.dart
- [ ] T065 [P] [US2] Widget test for technician home screen in test/widget/technician_home_screen_test.dart
- [ ] T066 [P] [US2] API test for ticket status update endpoints in backend/tests/test_tickets.py

### Backend Implementation for User Story 2

- [ ] T067 [US2] Add ticket status update methods to ticket service in backend/src/services/ticket_service.py (accept_ticket, complete_ticket)
- [ ] T068 [US2] Add ticket status routes in backend/src/routes/ticket_routes.py (POST /api/tickets/:id/accept, POST /api/tickets/:id/complete)
- [ ] T069 [US2] Add get tickets by technician filter in ticket service (filter by technician_id and status)

### Flutter Implementation for User Story 2

- [ ] T070 [US2] Add accept/complete ticket methods to ticket repository in lib/data/repositories/ticket_repository.dart
- [ ] T071 [US2] Create accept/complete ticket use cases in lib/domain/usecases/tickets/ (accept_ticket_usecase.dart, complete_ticket_usecase.dart)
- [ ] T072 [US2] Update ticket BLoC in lib/presentation/blocs/ticket/ to handle accept/complete events
- [ ] T073 [US2] Create technician home screen in lib/presentation/screens/technician/technician_home_screen.dart with queue overview
- [ ] T074 [US2] Create ticket queue screen in lib/presentation/screens/technician/ticket_queue_screen.dart (list pending and in-progress tickets)
- [ ] T075 [US2] Create technician ticket detail screen in lib/presentation/screens/technician/ticket_detail_screen.dart with accept/complete actions
- [ ] T076 [US2] Add resolution notes input dialog/bottom sheet for completing tickets

**Checkpoint**: Technicians can now receive, accept, and complete tickets. Core ticket workflow is functional.

---

## Phase 5: User Story 3 - Comment System (Priority: P1) 🎯 MVP Enhancement

**Goal**: Both employees and technicians can add comments to tickets for two-way communication

**Independent Test**: Create ticket, employee adds comment, technician responds, both see conversation thread

### Tests for User Story 3 ⚠️

- [ ] T077 [P] [US3] Integration test for comment workflow in test/integration/comment_flow_test.dart
- [ ] T078 [P] [US3] Widget test for comment list widget in test/widget/comment_list_test.dart
- [ ] T079 [P] [US3] API test for comment endpoints in backend/tests/test_comments.py

### Backend Implementation for User Story 3

- [ ] T080 [US3] Create comment service in backend/src/services/comment_service.py (add_comment, get_comments_by_ticket)
- [ ] T081 [US3] Create comment routes in backend/src/routes/comment_routes.py (POST /api/tickets/:id/comments, GET /api/tickets/:id/comments)
- [ ] T082 [US3] Add comment creation notification trigger in comment service

### Flutter Implementation for User Story 3

- [ ] T083 [US3] Create comment repository in lib/data/repositories/comment_repository.dart (add, get by ticket)
- [ ] T084 [US3] Create comment use cases in lib/domain/usecases/comments/ (add_comment_usecase.dart, get_comments_usecase.dart)
- [ ] T085 [US3] Create comment BLoC in lib/presentation/blocs/comment/ (comment_bloc.dart, comment_event.dart, comment_state.dart)
- [ ] T086 [US3] Create comment list widget in lib/presentation/widgets/comment/comment_list.dart (display conversation thread)
- [ ] T087 [P] [US3] Create comment item widget in lib/presentation/widgets/comment/comment_item.dart (single comment bubble)
- [ ] T088 [P] [US3] Create comment input widget in lib/presentation/widgets/comment/comment_input.dart (text field with send button)
- [ ] T089 [US3] Add comment section to employee ticket detail screen in lib/presentation/screens/employee/ticket_detail_screen.dart
- [ ] T090 [US3] Add comment section to technician ticket detail screen in lib/presentation/screens/technician/ticket_detail_screen.dart
- [ ] T091 [US3] Implement optimistic UI updates for comments (show immediately, sync in background)

**Checkpoint**: Complete two-way communication established between employees and technicians

---

## Phase 6: User Story 4 - Admin Manages System Data (Priority: P2)

**Goal**: Admin can perform CRUD operations on employees and technicians

**Independent Test**: Admin logs in, creates new employee, updates technician region, deactivates user

### Tests for User Story 4 ⚠️

- [ ] T092 [P] [US4] Widget test for admin screens in test/widget/admin_screens_test.dart
- [ ] T093 [P] [US4] API test for admin CRUD endpoints in backend/tests/test_admin.py

### Backend Implementation for User Story 4

- [ ] T094 [US4] Create admin service in backend/src/services/admin_service.py (CRUD for employees and technicians)
- [ ] T095 [US4] Create admin routes in backend/src/routes/admin_routes.py (CRUD endpoints for users)
- [ ] T096 [US4] Add admin role check middleware to protect admin routes

### Flutter Implementation for User Story 4

- [ ] T097 [US4] Create admin repository in lib/data/repositories/admin_repository.dart (CRUD operations)
- [ ] T098 [US4] Create admin home screen in lib/presentation/screens/admin/admin_home_screen.dart with management options
- [ ] T099 [US4] Create manage employees screen in lib/presentation/screens/admin/manage_employees_screen.dart (list, add, edit, delete)
- [ ] T100 [US4] Create manage technicians screen in lib/presentation/screens/admin/manage_technicians_screen.dart (list, add, edit, delete)
- [ ] T101 [US4] Create user form dialog/screen for adding/editing users (employee and technician variants)

**Checkpoint**: Admin can now maintain user data in the system

---

## Phase 7: User Story 5 - Notification System (Priority: P2)

**Goal**: Users receive timely in-app notifications for ticket events

**Independent Test**: Create ticket, verify technician gets notification; accept ticket, verify employee gets notification

### Tests for User Story 5 ⚠️

- [ ] T102 [P] [US5] Integration test for notification delivery in test/integration/notification_flow_test.dart
- [ ] T103 [P] [US5] Unit test for notification service in backend/tests/test_notifications.py

### Backend Implementation for User Story 5

- [ ] T104 [US5] Create notification service in backend/src/services/notification_service.py (create, mark read, get by user)
- [ ] T105 [US5] Create notification routes in backend/src/routes/notification_routes.py (GET /api/notifications, PUT /api/notifications/:id/read)
- [ ] T106 [US5] Integrate notification creation in ticket service (on create, accept, complete, new comment)
- [ ] T107 [US5] Setup WebSocket server for real-time notifications in backend/src/websocket/ (optional: start with polling)

### Flutter Implementation for User Story 5

- [ ] T108 [US5] Create WebSocket client in lib/data/datasources/remote/websocket_client.dart (connect, listen, reconnect logic)
- [ ] T109 [US5] Create notification BLoC in lib/presentation/blocs/notification/ (notification_bloc.dart, notification_event.dart, notification_state.dart)
- [ ] T110 [US5] Add notification badge to app bar showing unread count
- [ ] T111 [US5] Create notification icon with badge in home screens
- [ ] T112 [US5] Implement notification list/drawer showing recent notifications
- [ ] T113 [US5] Add notification sound/vibration on new notification (optional)
- [ ] T114 [US5] Implement background polling for notifications (if WebSocket not ready)

**Checkpoint**: Users receive real-time or near-real-time notifications for all ticket events

---

## Phase 8: User Story 6 - Ticket History and Reporting (Priority: P3)

**Goal**: View historical tickets and generate basic reports

**Independent Test**: Create and complete multiple tickets, then search and filter history

### Backend Implementation for User Story 6

- [ ] T115 [US6] Add advanced filtering to ticket service (date range, category, status, search text)
- [ ] T116 [US6] Add statistics endpoint in backend/src/routes/ticket_routes.py (GET /api/tickets/stats)
- [ ] T117 [US6] Implement basic report generation (ticket counts, average resolution time, by category)

### Flutter Implementation for User Story 6

- [ ] T118 [US6] Add search and filter UI to ticket list screens (date picker, dropdowns)
- [ ] T119 [US6] Create statistics screen showing ticket metrics (for technicians and admin)
- [ ] T120 [US6] Add export functionality (CSV or PDF) for reports (optional)

**Checkpoint**: Users can analyze historical data and view performance metrics

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories and final release preparation

- [ ] T121 [P] Add Indonesian language strings throughout app (replace all hardcoded text)
- [ ] T122 [P] Add date/time formatting utility in lib/core/utils/date_utils.dart (Indonesian format, relative times)
- [ ] T123 Implement offline mode detection and queue in lib/data/datasources/local/local_storage.dart
- [ ] T124 Add offline indicator banner to all screens
- [ ] T125 Implement optimistic updates for all user actions (create ticket, add comment, etc.)
- [ ] T126 Add loading skeletons for all list screens (better perceived performance)
- [ ] T127 [P] Add comprehensive error messages (network errors, validation errors, server errors)
- [ ] T128 [P] Add accessibility labels and semantic widgets for screen readers
- [ ] T129 Implement pull-to-refresh on all list screens
- [ ] T130 Add pagination/infinite scroll to ticket lists (if >50 tickets)
- [ ] T131 [P] Performance optimization: Add const constructors where possible
- [ ] T132 [P] Performance optimization: Implement memo/selector for BLoC to prevent unnecessary rebuilds
- [ ] T133 [P] Add app icon and splash screen with PLN branding
- [ ] T134 Add backend health check endpoint (GET /api/health)
- [ ] T135 Add backend logging middleware (request/response logging, error tracking)
- [ ] T136 [P] Create API documentation (Swagger/OpenAPI for backend)
- [ ] T137 [P] Write README.md for both Flutter app and backend with setup instructions
- [ ] T138 Run flutter analyze and fix all warnings/errors
- [ ] T139 Run backend linting and fix all issues
- [ ] T140 Setup CI/CD pipeline for automated testing (optional but recommended)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3-8)**: All depend on Foundational phase completion
  - US1, US2, US3 are P1 and should be completed together (core MVP)
  - US4, US5 are P2 and can be done after MVP is working
  - US6 is P3 and can be done last
- **Polish (Phase 9)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational - No dependencies on other stories
- **User Story 2 (P1)**: Can start after Foundational - Should integrate with US1 for complete workflow
- **User Story 3 (P1)**: Can start after Foundational - Enhances US1 and US2 with communication
- **User Story 4 (P2)**: Can start after Foundational - Independent of US1-3
- **User Story 5 (P2)**: Should wait until US1-3 are stable (needs tickets to notify about)
- **User Story 6 (P3)**: Should wait until system has historical data to analyze

### Within Each User Story

- Tests MUST be written and FAIL before implementation
- Backend API endpoints before Flutter integration
- Models and repositories before BLoCs
- BLoCs before UI screens
- Core screens before polish widgets
- Story complete and tested before moving to next priority

### Parallel Opportunities

- Backend and Flutter setup can happen simultaneously (Phase 1)
- Within Foundational phase: database migrations, models, and client setup can be parallel
- Once Foundational complete: US1, US2, US3 can be developed in parallel by different developers
- Widget development can happen while API development is ongoing (with mocked data)
- Polish tasks marked [P] can run in parallel

---

## Implementation Strategy

### MVP First (User Stories 1, 2, 3 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1 (Employee creates tickets)
4. Complete Phase 4: User Story 2 (Technician resolves tickets)
5. Complete Phase 5: User Story 3 (Comment system)
6. **STOP and VALIDATE**: Test complete ticket workflow end-to-end
7. Deploy/demo MVP

### Incremental Delivery

1. Setup + Foundational → Foundation ready
2. Add User Stories 1-3 → Test thoroughly → Deploy/Demo (MVP! 🎯)
3. Add User Story 4 (Admin) → Test independently → Deploy/Demo
4. Add User Story 5 (Notifications) → Test independently → Deploy/Demo
5. Add User Story 6 (Reporting) → Test independently → Deploy/Demo
6. Polish phase → Final release

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1 (Employee features)
   - Developer B: User Story 2 (Technician features)
   - Developer C: Backend API + User Story 3 (Comments)
3. Stories complete and integrate for MVP demo
4. Then parallelize US4, US5, US6 as desired

---

## Constitution Compliance Checklist

Before completing implementation, verify adherence to constitution principles:

- [ ] **File Size**: All modified files remain under 700 lines (target 500) - run analysis before merge
- [ ] **Testing**: Appropriate tests written and passing (unit: 43 tests minimum, widget: 15+, integration: 5+)
- [ ] **Code Quality**: Code is modular, documented with doc comments, and follows single responsibility
- [ ] **UX Consistency**: UI follows Material Design 3 and maintains consistent spacing/typography/colors
- [ ] **Performance**: No performance regressions; maintains 60 FPS; list scrolling smooth with 100+ items
- [ ] **Conventions**: Follows Flutter/Dart naming conventions (snake_case files, PascalCase classes, lowerCamelCase variables)
- [ ] **Dependencies**: No circular dependencies; proper resource disposal (controllers, streams, WebSocket)
- [ ] **Offline Support**: Offline mode tested and working correctly
- [ ] **Real-time**: Comments and notifications deliver within 5 seconds
- [ ] **Time Tracking**: Time elapsed displays update correctly every minute

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability (US1-US6, Setup, Foundation)
- Each user story should be independently completable and testable
- Tests written FIRST, verify they fail, then implement to make them pass
- Commit after each task or logical group (aim for small, focused commits)
- Stop at any checkpoint to validate story independently
- Backend and Flutter can be developed in parallel with clear API contracts
- File size limit (700 lines) will be enforced - extract widgets/services if approaching limit
- Keep tasks focused and specific - if task description is vague, break it down further
- Use mocking for tests to avoid external dependencies
- Follow TDD discipline: Red (test fails) → Green (test passes) → Refactor (improve code)

## Task Count Summary

- **Setup**: 10 tasks
- **Foundation**: 32 tasks (16 backend, 16 Flutter)
- **User Story 1**: 21 tasks (5 tests, 4 backend, 12 Flutter)
- **User Story 2**: 13 tasks (3 tests, 3 backend, 7 Flutter)
- **User Story 3**: 15 tasks (3 tests, 3 backend, 9 Flutter)
- **User Story 4**: 10 tasks (2 tests, 3 backend, 5 Flutter)
- **User Story 5**: 13 tasks (2 tests, 4 backend, 7 Flutter)
- **User Story 6**: 6 tasks (3 backend, 3 Flutter)
- **Polish**: 20 tasks

**Total**: 140 tasks

**Estimated Effort**: 
- MVP (Setup + Foundation + US1-3): ~70 tasks = 4-6 weeks with 2-3 developers
- Full system: 140 tasks = 8-10 weeks with 2-3 developers

---

**Ready to begin implementation!** Start with T001 and work sequentially through Setup and Foundation phases.