# Feature Specification: Internal Ticket Management System

**Feature Branch**: `001-ticket-system`
**Created**: 2025-10-19
**Status**: Clarified - Ready for Planning
**Last Updated**: 2025-10-19 (Clarification Complete)
**Input**: User description: "Buat aplikasi untuk mengelola sistem tiket internal perusahaan dengan tiga peran pengguna: Employee (pelapor), Technician (penyelesai), dan Admin (pengelola)."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Employee Creates and Tracks Ticket (Priority: P1) 🎯 MVP

An employee encounters a technical problem and needs to report it to the appropriate technician for resolution.

**Why this priority**: This is the core functionality - employees must be able to report issues and get them resolved. Without this, the system has no purpose.

**Independent Test**: Employee can create a ticket, select appropriate technician, and receive updates on ticket status without any other user stories being implemented.

**Acceptance Scenarios**:

1. **Given** employee has logged in with username (NIP), **When** they create a new ticket describing a hardware issue in their region, **Then** system shows matching technicians from their region who handle hardware issues
2. **Given** employee has submitted a ticket, **When** technician accepts the ticket, **Then** employee receives notification that their ticket is being worked on
3. **Given** technician completes the ticket, **When** they mark it as resolved with notes, **Then** employee receives notification with resolution details
4. **Given** employee has multiple tickets, **When** they view their ticket list, **Then** they can see status of all tickets (pending, in-progress, completed) with latest updates and comment counts
5. **Given** employee needs to provide additional information, **When** they add a comment to their ticket, **Then** technician receives notification and can view the comment in conversation thread

---

### User Story 2 - Technician Receives and Resolves Tickets (Priority: P1) 🎯 MVP

A technician receives ticket assignments matching their expertise and region, works on them, and marks them as complete.

**Why this priority**: Equally critical as employee ticket creation - technicians need to receive, acknowledge, and resolve tickets. These two stories form the minimum viable ticket system.

**Independent Test**: Technician can log in, see assigned tickets, accept them, and mark them complete independently of admin features.

**Acceptance Scenarios**:

1. **Given** employee creates ticket matching technician's category and region, **When** system assigns ticket, **Then** technician receives in-app notification with ticket details
2. **Given** technician receives new ticket, **When** they accept/acknowledge it, **Then** system updates ticket status to "in-progress" and notifies employee
3. **Given** technician has resolved the issue, **When** they mark ticket as complete with resolution notes, **Then** system updates status to "completed" and notifies employee
4. **Given** technician views their dashboard, **When** they check their queue, **Then** they see all pending and in-progress tickets assigned to them with time elapsed indicators
5. **Given** technician needs clarification on an issue, **When** they add a comment asking questions, **Then** employee receives notification and can respond with additional details

---

### User Story 3 - Technician Matching Based on Category, Sub-Category, and Region (Priority: P1) 🎯 MVP

System intelligently matches tickets to appropriate technicians based on problem category, sub-category, and employee's region.

**Why this priority**: This is essential for the system to function properly - tickets must go to the right technician. Without proper matching, the system creates chaos.

**Independent Test**: Create tickets with different combinations of category/sub-category/region and verify correct technicians are matched in each case.

**Acceptance Scenarios**:

1. **Given** employee in UPT Malang reports hardware issue, **When** they search for technicians, **Then** system shows Parluhutan Harahap (regional) and any "ALL UIT" technicians
2. **Given** employee reports VPN issue (Akun category, VPN sub-category), **When** system matches technician, **Then** Risma Budi is selected regardless of region
3. **Given** employee reports Smartness application issue, **When** system matches technician, **Then** Hartanto Budi is selected (application-specific, no region limit)
4. **Given** employee in Kantor Induk reports SAP issue, **When** they filter technicians, **Then** system shows Pupus Dwi Anggono (regional) and Alfian Prasetyo (ALL UIT with SAP expertise)

---

### User Story 4 - Admin Manages System Data (Priority: P2)

Admin can create, read, update, and delete employee and technician data to maintain accurate system information.

**Why this priority**: Important for long-term maintenance but not critical for initial ticket flow. System can function with pre-populated data initially.

**Independent Test**: Admin can log in and perform CRUD operations on both employees and technicians without affecting ticket flow (tickets continue working with existing data).

**Acceptance Scenarios**:

1. **Given** admin is logged in, **When** new employee joins company, **Then** admin can create employee record with NIP and name
2. **Given** technician changes region or specialization, **When** admin updates technician profile, **Then** future ticket matching reflects the updated information
3. **Given** employee leaves company, **When** admin deactivates/deletes their account, **Then** their historical tickets remain visible but they cannot create new tickets
4. **Given** admin views technician list, **When** they search by region or category, **Then** system filters and displays matching technicians

---

### User Story 5 - Notification System (Priority: P2)

Users receive timely in-app notifications about ticket status changes relevant to their role.

**Why this priority**: Enhances user experience but tickets can still be tracked manually. Push notifications improve responsiveness but aren't blocking for core functionality.

**Independent Test**: Create ticket workflow (create → accept → complete) and verify notifications appear at each stage for relevant users.

**Acceptance Scenarios**:

1. **Given** ticket is created, **When** system assigns to technician, **Then** technician receives notification within 5 seconds
2. **Given** technician accepts ticket, **When** status changes to in-progress, **Then** employee receives notification within 5 seconds
3. **Given** technician completes ticket, **When** they add resolution notes, **Then** employee receives notification with notes visible
4. **Given** comment is added to ticket, **When** other party opens app, **Then** they receive notification of new comment within 5 seconds
5. **Given** user has unread notifications, **When** they open app, **Then** notification badge displays count and notifications are marked as read when viewed

---

### User Story 6 - Ticket History and Reporting (Priority: P3)

Users can view historical ticket data and generate reports for analysis.

**Why this priority**: Valuable for analytics and improvement but not essential for day-to-day operations. Can be added after core system is stable.

**Independent Test**: Create and complete multiple tickets, then verify history is searchable and reports can be generated independently.

**Acceptance Scenarios**:

1. **Given** employee has 50 completed tickets, **When** they search their history, **Then** they can filter by date range, category, and status
2. **Given** technician wants to review their work, **When** they view statistics, **Then** they see total tickets completed, average resolution time, and breakdown by category
3. **Given** admin needs monthly report, **When** they generate report, **Then** system exports data showing total tickets, completion rates, and technician performance metrics

---

### Edge Cases

- What happens when no technician matches the exact combination of category, sub-category, and region?
  - System suggests closest matches (e.g., same category but ALL UIT region)
  - Allow employee to manually select from broader list if no exact match

- How does system handle if technician is unavailable/on leave?
  - Admin can mark technicians as temporarily unavailable
  - System skips unavailable technicians in matching algorithm
  - **Note**: Since reassignment not allowed, employee must choose available technician carefully

- What if employee creates duplicate tickets for same issue?
  - System detects similar recent tickets (same category, similar description) and warns employee
  - Allow employee to proceed if genuinely different issue

- How are ticket priorities determined?
  - MVP: All tickets treated equally, displayed by creation time (oldest first)
  - Time elapsed displayed to show urgency
  - Future enhancement: allow explicit priority levels

- What happens if wrong technician is selected?
  - **Clarified**: Tickets CANNOT be reassigned in MVP
  - Employee and technician can communicate via comments to clarify
  - If truly wrong assignment, ticket must be marked complete by current technician and employee creates new ticket
  - Future enhancement: Allow admin reassignment

- How to handle tickets that need multiple technicians?
  - MVP: One technician per ticket
  - Technician can add comments suggesting colleague involvement (communication outside system)
  - Future enhancement: Allow collaborative/shared tickets

- What if employee or technician deletes comments by mistake?
  - MVP: Comments cannot be deleted, only added (prevents loss of information)
  - Future enhancement: Allow edit/delete with history tracking

- How is offline comment sync handled?
  - Comments created offline are queued locally
  - When connection restored, comments sync in chronological order
  - System prevents duplicate comments with unique client-side IDs

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST authenticate users with username/password credentials and issue JWT tokens for session management (Employee uses NIP as username, Technician and Admin use assigned usernames)
- **FR-002**: System MUST allow Employee to create ticket with: problem description, selected category, sub-category, and automatically detect their region
- **FR-003**: System MUST match tickets to appropriate technicians based on: category, sub-category, and region constraints
- **FR-004**: System MUST send in-app notifications when: ticket created (to technician), ticket accepted (to employee), ticket completed (to employee)
- **FR-005**: System MUST allow Technician to: view assigned tickets, accept/acknowledge tickets, mark tickets complete with optional notes
- **FR-006**: System MUST allow Admin to: CRUD operations on Employee data (NIP, Nama), CRUD operations on Technician data (Nama, Wilayah, Kategori, Sub-Kategori)
- **FR-007**: System MUST display ticket status: pending (created), in-progress (accepted by technician), completed (resolved)
- **FR-008**: System MUST persist all ticket data including: creation time, assignment time, acceptance time, completion time, and resolution notes
- **FR-009**: System MUST support regional technicians (assigned to specific regions) and central technicians (ALL UIT or no region constraint)
- **FR-010**: System MUST display ticket history for both employees (their submitted tickets) and technicians (their assigned tickets)
- **FR-011**: System MUST allow both employees and technicians to add comments to tickets, creating a conversation thread visible to both parties
- **FR-012**: System MUST track and display time elapsed since ticket creation and time since last status change (for visibility, not enforcement)
- **FR-013**: System MUST use Indonesian language for UI elements while preserving English technical terms (Hardware, SAP, VPN, etc.)
- **FR-014**: Tickets CANNOT be reassigned to different technicians after creation (ensures accountability and careful initial selection)

### Quality & Performance Requirements *(per constitution)*

- **QR-001**: Implementation MUST keep files under 700 lines (target 500 lines) - expect ~15-20 files for complete system
- **QR-002**: All business logic (ticket matching, status updates) MUST have unit tests; all screens MUST have widget tests
- **QR-003**: UI MUST maintain 60 FPS performance; ticket list scrolling must be smooth with 100+ tickets
- **QR-004**: UI MUST provide consistent experience following Material Design guidelines for Android
- **QR-005**: Code MUST follow Flutter/Dart naming conventions (snake_case files, PascalCase classes)
- **QR-006**: Notifications MUST appear within 5 seconds of triggering event
- **QR-007**: Ticket creation flow MUST complete in under 30 seconds (including technician selection)
- **QR-008**: System MUST handle offline mode gracefully (queue actions, sync when online)
- **QR-009**: Comment threads MUST update in real-time or within 5 seconds for both parties
- **QR-010**: Time tracking display MUST update every minute to show current elapsed time

### Key Entities

- **Employee**: Represents ticket reporters with attributes: id, nip (string, format: XXXXXX), nama (string), region (enum), created_tickets (list)
- **Technician**: Represents ticket resolvers with attributes: id, nama (string), wilayah (enum or "ALL UIT"), kategori_list (list of enums), sub_kategori_list (list of enums), assigned_tickets (list)
- **Admin**: Represents system managers with attributes: id, nama (string), nomor_wa (string), permissions (list)
- **Ticket**: Central entity with attributes: id, employee_id, technician_id, deskripsi (text), kategori (enum), sub_kategori (enum), status (enum: pending/in-progress/completed), created_at, accepted_at, completed_at, resolution_notes (optional text), comments (list of Comment objects)
- **Comment**: Represents conversation entries with attributes: id, ticket_id, user_id, user_type (employee/technician), text (string), created_at (timestamp)
- **Notification**: Represents in-app alerts with attributes: id, user_id, ticket_id, message (text), read_status (boolean), created_at

### Data Constants

**Categories (Enum)**:
- Hardware
- Jaringan/Koneksi  
- Zoom
- Akun
- Aplikasi

**Regions (Enum)**:
- Kantor Induk UIT JBM
- UPT Surabaya
- UPT Malang
- UPT Madiun
- UPT Probolinggo
- UPT Gresik
- UPT Bali

**Pre-populated Technicians** (see data structure section for complete list of 11 technicians with their categories, sub-categories, and regions)

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Employees can create ticket and select appropriate technician in under 30 seconds
- **SC-002**: 95% of tickets automatically matched to correct technician based on criteria
- **SC-003**: Notifications delivered to recipient within 5 seconds of status change
- **SC-004**: System handles 100 concurrent users without performance degradation
- **SC-005**: Average ticket resolution time under 48 hours for 80% of tickets (baseline to be established in first month)
- **SC-006**: 90% of employees successfully complete ticket creation on first attempt without assistance
- **SC-007**: Zero data loss - all tickets, comments, and status changes persisted correctly
- **SC-008**: Admin can complete CRUD operations on employees/technicians in under 10 seconds per operation
- **SC-009**: Comments appear for recipient within 5 seconds of posting (real-time communication)
- **SC-010**: Time elapsed displayed accurately and updates every minute without requiring manual refresh

## Technical Considerations

### State Management
- Use BLoC or Provider for managing: authentication state, ticket lists, notification state, comment threads
- Separate state management for each major feature (auth, tickets, notifications, comments, admin)

### Data Persistence & Backend
- **Backend**: Self-hosted REST API server
- **Database**: PostgreSQL for data persistence
- **Local Cache**: SQLite/Hive for offline capability and caching
- **Real-time Updates**: WebSocket or polling for comment threads and notifications
- **Authentication**: JWT token-based authentication with refresh tokens

### API Endpoints (Preliminary)
```
POST   /api/auth/login          - Authenticate user, return JWT
POST   /api/auth/refresh        - Refresh JWT token
GET    /api/tickets             - List tickets (filtered by role)
POST   /api/tickets             - Create new ticket
GET    /api/tickets/:id         - Get ticket details with comments
POST   /api/tickets/:id/accept  - Technician accepts ticket
POST   /api/tickets/:id/complete - Technician completes ticket
POST   /api/tickets/:id/comments - Add comment to ticket
GET    /api/technicians         - List technicians (for matching)
GET    /api/notifications       - Get user notifications
```

### Technician Matching Algorithm
```
Priority order for matching:
1. Exact match: category + sub-category + region
2. Category + sub-category + ALL UIT
3. Category + region (if sub-category not critical)
4. Category + ALL UIT
5. Manual selection fallback
```

### Notification Strategy
- In-app notifications for: new ticket assignment, ticket status changes, new comments
- WebSocket or polling for real-time notification delivery
- Badge counts on app icon for unread notifications
- Notification types: ticket_assigned, ticket_accepted, ticket_completed, new_comment
- Future: Push notifications via FCM for critical updates when app in background

### Comment System Strategy
- Real-time or near-real-time updates via WebSocket/polling
- Comments stored in order with timestamps
- Display format: conversation thread (like WhatsApp/Slack)
- Show commenter role (Employee/Technician) and timestamp
- Mark unread comments with indicator

### Offline Support
- Queue ticket creation, comments, and status updates locally
- Sync when connection restored in chronological order
- Show clear offline indicator to user
- Prevent conflicts with optimistic updates and client-generated UUIDs
- Display warning if attempting actions requiring immediate confirmation (like ticket completion)

## Clarification Log

**Date**: 2025-10-19

All open questions have been resolved. Key decisions:

| Decision Area | Choice Made | Rationale |
|--------------|-------------|-----------|
| **Backend Architecture** | Self-hosted REST API + PostgreSQL | Full control, integrates with existing PLN infrastructure, suitable for enterprise environment |
| **Authentication** | Username/password with JWT tokens | Simple to implement, no external dependencies, sufficient security for internal app |
| **File Attachments** | NOT included in MVP | Reduces complexity, faster delivery, can be added in v2 if needed |
| **Ticket Reassignment** | NOT allowed | Ensures accountability, encourages careful technician selection, simpler implementation |
| **Comments/Updates** | YES - Full conversation thread | Critical for communication, allows clarifications without external channels, improves issue resolution |
| **SLA/Time Tracking** | Track and display only, no enforcement | Provides visibility into performance without complex enforcement logic, good for MVP |
| **Multi-language** | Indonesian UI with English technical terms | Practical hybrid approach, serves PLN workforce, preserves standard technical terminology |

### Impact on Scope

**Added to MVP**:
- Comment/conversation system between employee and technician
- Time elapsed display (since creation and last update)
- Indonesian UI localization

**Deferred to Future Versions**:
- File attachment support (v2)
- Ticket reassignment capability (v2)
- SLA enforcement and escalation (v2)
- Active Directory integration (if needed)

**Removed from Consideration**:
- Firebase/Supabase alternatives (going with self-hosted)
- Full multi-language support (Indonesian only)

### Updated Requirements Count
- Functional Requirements: 14 (added 4 for comments, time tracking, language, reassignment policy)
- Quality Requirements: 10 (added 2 for comment real-time updates and time tracking performance)
- Key Entities: 6 (added Comment entity)

### Next Steps
Ready to proceed with `/speckit.plan` command to generate implementation plan with:
- REST API architecture design
- PostgreSQL data model
- Flutter app structure
- Authentication flow
- Comment system implementation