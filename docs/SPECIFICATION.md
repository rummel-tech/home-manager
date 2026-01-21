---
module: home-manager
version: 1.0.0
status: draft
last_updated: 2026-01-20
---

# Home Manager Specification

## Overview

The Home Manager module provides weekly home task management and goal tracking capabilities. It enables users to organize household tasks by category and day, track progress on home improvement goals, and view statistics about task completion. The module consists of a FastAPI backend (port 8020) with mock data and a Flutter web frontend with Material Design 3 styling.

## Authentication

This module uses the shared AWS Amplify authentication system. See [Authentication Architecture](../../../../docs/architecture/AUTHENTICATION.md) for complete details.

### Authentication Modes

| Mode | Description |
|------|-------------|
| Artemis-Integrated | User authenticates via Artemis, gains access to all permitted modules |
| Standalone | User authenticates directly in Home Manager app |

### Module Access

- **Module ID**: `home-manager`
- **Artemis Users**: Full access when `artemis_access: true`
- **Standalone Users**: Access when `home-manager` in `module_access` list

### Login Screen

Uses shared `auth_ui` package with identical UI to all other modules:
- Email/password authentication
- Google Sign-In
- Apple Sign-In
- Email verification flow
- Password reset flow

### API Authentication

All API endpoints require JWT Bearer token from AWS Cognito:
```http
Authorization: Bearer <access_token>
```

Backend validates tokens using AWS Cognito SDK and checks module access permissions.

## Design System

This module uses the shared Artemis Design System. See [Design System](../../../../docs/architecture/DESIGN_SYSTEM.md) for complete specifications.

### Design Principles

All UI components follow the shared design system to ensure visual consistency across the Artemis ecosystem:

- **Colors**: Rummel Blue primary (`#1E88E5`), Teal secondary (`#26A69A`)
- **Typography**: Material 3 type scale with system fonts
- **Spacing**: Consistent 4dp base unit scale (xs: 4dp, sm: 8dp, md: 16dp, lg: 24dp)
- **Components**: Shared button, card, input, and navigation styles

### Module-Specific Colors

| Element | Color | Token | Usage |
|---------|-------|-------|-------|
| Task Complete | `#388E3C` | `success` | Completed tasks, goals at 100% |
| Task Overdue | `#D32F2F` | `error` | Overdue tasks, missed deadlines |
| Task Upcoming | `#F57C00` | `warning` | Tasks due soon, goals near deadline |
| High Priority | `#D32F2F` | `error` | High priority indicator |
| Medium Priority | `#F57C00` | `warning` | Medium priority indicator |
| Low Priority | `#388E3C` | `success` | Low priority indicator |

### Category Icons and Colors

| Category | Icon | Color |
|----------|------|-------|
| Cleaning | `cleaning_services` | `#26A69A` |
| Chores | `checklist` | `#1E88E5` |
| Cooking | `restaurant` | `#F57C00` |
| Errands | `directions_car` | `#7B1FA2` |
| Outdoor | `grass` | `#388E3C` |
| Organizing | `inventory_2` | `#0288D1` |
| Maintenance | `build` | `#455A64` |
| Planning | `event` | `#1565C0` |

### Key Components

| Component | Specification |
|-----------|---------------|
| TaskCard | Card with checkbox, category icon, priority badge, time estimate |
| GoalCard | Card with progress bar, category badge, target date |
| DayColumn | Vertical list with day header, expandable task groups |
| StatsCard | Summary card with completion rate, total time |
| CategoryFilter | Chip group for filtering by category |
| ProgressBar | Linear progress with percentage label |

### Screen Layouts

All screens follow responsive breakpoints from the shared design system:
- Mobile (< 600dp): Single column with day tabs, bottom navigation
- Tablet (600-839dp): 3-day view with swipe navigation
- Desktop (>= 840dp): Full week view with 7 columns

## Data Models

### Task

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| id | String | PK, unique | Unique identifier |
| title | String | Required | Task name |
| description | String? | Optional | Detailed description |
| day | String | Required | Day of week (Monday-Sunday) |
| category | String | Required, enum | Task category |
| priority | String | Default: medium | Priority level |
| completed | bool | Default: false | Completion status |
| estimated_minutes | int? | Optional, >= 0 | Estimated duration |

**Categories:**
| Category | Icon | Description |
|----------|------|-------------|
| cleaning | 🧹 | House cleaning tasks |
| chores | 📋 | General household chores |
| cooking | 🍳 | Meal preparation |
| errands | 🚗 | Shopping and outside tasks |
| outdoor | 🌿 | Yard work and outdoor |
| organizing | 📦 | Organization and decluttering |
| maintenance | 🔧 | Home repairs and upkeep |
| planning | 📅 | Planning and administrative |

**Priority Levels:**
| Priority | Description |
|----------|-------------|
| high | Must complete today |
| medium | Should complete today |
| low | Can defer if needed |

**Relationships:**
- Task belongs to WeeklyTasks (via tasks list)

**Indexes (Planned):**
- user_id (for user-scoped queries)
- day (for daily filtering)
- category (for category filtering)
- completed (for status filtering)

**JSON Serialization:**
```json
{
  "id": "1",
  "title": "Laundry",
  "description": "Wash, dry, and fold clothes",
  "day": "Monday",
  "category": "chores",
  "priority": "high",
  "completed": false,
  "estimated_minutes": 60
}
```

### Goal

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| id | String | PK, unique | Unique identifier |
| title | String | Required | Goal name |
| description | String? | Optional | Detailed description |
| category | String | Required, enum | Goal category |
| target_date | String? | Optional, ISO date | Target completion date |
| progress | int | 0-100, default: 0 | Completion percentage |
| is_active | bool | Default: true | Active status |

**Relationships:**
- Goal can have multiple related Tasks (via category)

**Indexes (Planned):**
- user_id (for user-scoped queries)
- is_active (for filtering active goals)
- category (for category grouping)

**JSON Serialization:**
```json
{
  "id": "g1",
  "title": "Organize Garage",
  "description": "Sort through items, donate unused things, create storage system",
  "category": "organizing",
  "target_date": "2026-12-31",
  "progress": 25,
  "is_active": true
}
```

### WeeklyTasks

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| user_id | String | Required | User identifier |
| week_start | String? | Optional, ISO date | Start date of week |
| tasks | List\<Task\> | Required | Tasks for the week |

**Computed Properties (Planned):**
- `totalTasks`: Count of all tasks
- `completedTasks`: Count of completed tasks
- `completionRate`: Percentage complete
- `totalEstimatedMinutes`: Sum of estimated times
- `tasksByDay`: Tasks grouped by day
- `tasksByCategory`: Tasks grouped by category

**JSON Serialization:**
```json
{
  "user_id": "user-123",
  "week_start": "2026-01-20",
  "tasks": [
    {"id": "1", "title": "Laundry", "day": "Monday", ...},
    {"id": "2", "title": "Grocery Shopping", "day": "Monday", ...}
  ]
}
```

### DailyTasks

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| user_id | String | Required | User identifier |
| day | String | Required | Day name |
| tasks | List\<Task\> | Required | Tasks for the day |

**JSON Serialization:**
```json
{
  "user_id": "user-123",
  "day": "Monday",
  "tasks": [
    {"id": "1", "title": "Laundry", "category": "chores", ...},
    {"id": "2", "title": "Grocery Shopping", "category": "errands", ...}
  ]
}
```

### Stats

| Field | Type | Description |
|-------|------|-------------|
| tasks.total | int | Total tasks in week |
| tasks.completed | int | Completed task count |
| tasks.completion_rate | float | Percentage complete |
| tasks.total_estimated_minutes | int | Total estimated time |
| goals.total | int | Total goals |
| goals.active | int | Active goal count |
| goals.average_progress | float | Mean progress percentage |

**JSON Serialization:**
```json
{
  "user_id": "user-123",
  "tasks": {
    "total": 14,
    "completed": 5,
    "completion_rate": 35.7,
    "total_estimated_minutes": 610
  },
  "goals": {
    "total": 3,
    "active": 3,
    "average_progress": 41.7
  }
}
```

### Tool

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| id | String | PK, unique | Unique identifier |
| name | String | Required | Tool name |
| description | String? | Optional | Detailed description |
| category | String | Required, enum | Tool category |
| owned | bool | Default: true | Whether tool is owned |
| condition | String? | Default: good | Current condition |
| storage_location | String? | Optional | Where tool is stored |
| purchase_date | String? | Optional, ISO date | When purchased |
| notes | String? | Optional | Additional notes |

**Categories:**
| Category | Description |
|----------|-------------|
| power_tool | Electric/battery powered tools |
| hand_tool | Manual tools |
| measuring | Measuring instruments |
| safety | Safety equipment |
| garden | Gardening tools |
| cleaning | Cleaning equipment |

**Condition Values:**
| Condition | Description |
|-----------|-------------|
| excellent | Like new |
| good | Normal wear |
| fair | Significant wear |
| poor | Barely functional |
| needs_repair | Requires fixing |

**JSON Serialization:**
```json
{
  "id": "tool-1",
  "name": "Cordless Drill",
  "description": "18V cordless drill with battery and charger",
  "category": "power_tool",
  "owned": true,
  "condition": "excellent",
  "storage_location": "Garage - Tool Cabinet",
  "purchase_date": "2023-06-15",
  "notes": "DeWalt 20V MAX"
}
```

### Material

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| id | String | PK, unique | Unique identifier |
| name | String | Required | Material name |
| description | String? | Optional | Detailed description |
| quantity | float | Default: 1.0 | Amount needed/on hand |
| unit | String | Default: each | Unit of measure |
| unit_cost | float? | Optional | Cost per unit |
| total_cost | float? | Optional | Total cost |
| supplier | String? | Optional | Where to purchase |
| purchased | bool | Default: false | Whether purchased |
| notes | String? | Optional | Additional notes |

**Unit Values:**
| Unit | Description |
|------|-------------|
| each | Individual items |
| ft | Linear feet |
| in | Inches |
| sq_ft | Square feet |
| gallon | Gallons |
| lb | Pounds |
| oz | Ounces |
| box | Box/package |
| bag | Bag |

**JSON Serialization:**
```json
{
  "id": "mat-1",
  "name": "2x4 Lumber (8ft)",
  "description": "Kiln-dried whitewood studs",
  "quantity": 10,
  "unit": "each",
  "unit_cost": 5.98,
  "total_cost": 59.80,
  "supplier": "Home Depot",
  "purchased": true,
  "notes": "For garage shelf project"
}
```

### Resource

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| id | String | PK, unique | Unique identifier |
| name | String | Required | Resource name |
| type | String | Required, enum | Resource type |
| url | String? | Optional | Link to resource |
| description | String? | Optional | Detailed description |
| notes | String? | Optional | Additional notes |

**Resource Types:**
| Type | Description |
|------|-------------|
| document | PDF, documents |
| video | Video tutorials |
| guide | How-to guides |
| contact | Service providers |
| reference | Reference materials |
| manual | Product manuals |
| permit | Building permits |

**JSON Serialization:**
```json
{
  "id": "res-1",
  "name": "DIY Garage Shelving Guide",
  "type": "guide",
  "url": "https://example.com/garage-shelving",
  "description": "Step-by-step guide for building garage storage shelves",
  "notes": "Good reference for shelf project"
}
```

### ProjectItem

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| item_id | String | Required | Reference to tool/material/resource |
| item_type | String | Required, enum | Type of item |
| quantity_needed | float? | Optional | Amount needed (for materials) |
| notes | String? | Optional | Project-specific notes |

**Item Types:** tool, material, resource

**JSON Serialization:**
```json
{
  "item_id": "tool-1",
  "item_type": "tool",
  "quantity_needed": null,
  "notes": "For drilling pilot holes"
}
```

### Project

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| id | String | PK, unique | Unique identifier |
| title | String | Required | Project name |
| description | String? | Optional | Detailed description |
| status | String | Default: planned | Project status |
| category | String | Required, enum | Project category |
| priority | String? | Default: medium | Priority level |
| start_date | String? | Optional, ISO date | When started |
| target_date | String? | Optional, ISO date | Target completion |
| completed_date | String? | Optional, ISO date | When completed |
| budget | float? | Optional | Planned budget |
| actual_cost | float? | Optional | Actual spending |
| tools | List\<ProjectItem\> | Default: [] | Required tools |
| materials | List\<ProjectItem\> | Default: [] | Required materials |
| resources | List\<ProjectItem\> | Default: [] | Related resources |
| tasks | List\<String\> | Default: [] | Related task IDs |
| notes | String? | Optional | Additional notes |

**Status Values:**
| Status | Description |
|--------|-------------|
| planned | Not yet started |
| in_progress | Currently active |
| on_hold | Paused |
| completed | Finished |
| cancelled | Abandoned |

**Project Categories:**
| Category | Description |
|----------|-------------|
| maintenance | Regular upkeep |
| renovation | Major updates |
| repair | Fixing issues |
| improvement | Enhancements |
| outdoor | Yard/exterior |
| organization | Storage/organizing |

**Relationships:**
- Project has many Tools (via ProjectItem)
- Project has many Materials (via ProjectItem)
- Project has many Resources (via ProjectItem)
- Project has many Tasks (via task IDs)

**JSON Serialization:**
```json
{
  "id": "proj-1",
  "title": "Garage Storage Shelves",
  "description": "Build sturdy shelving units along garage walls",
  "status": "in_progress",
  "category": "improvement",
  "priority": "high",
  "start_date": "2026-01-15",
  "target_date": "2026-02-15",
  "budget": 300.00,
  "actual_cost": 167.78,
  "tools": [
    {"item_id": "tool-1", "item_type": "tool", "notes": "For drilling pilot holes"}
  ],
  "materials": [
    {"item_id": "mat-1", "item_type": "material", "quantity_needed": 10}
  ],
  "resources": [
    {"item_id": "res-1", "item_type": "resource"}
  ],
  "tasks": [],
  "notes": "Need to clear out garage first"
}
```

### Asset

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| id | String | PK, unique | Unique identifier |
| name | String | Required | Asset name |
| description | String? | Optional | Detailed description |
| category | String | Required, enum | Asset category |
| location | String? | Optional | Where in home |
| manufacturer | String? | Optional | Brand/manufacturer |
| model_number | String? | Optional | Model identifier |
| serial_number | String? | Optional | Serial number |
| purchase_date | String? | Optional, ISO date | When purchased |
| purchase_price | float? | Optional | Original cost |
| warranty_expires | String? | Optional, ISO date | Warranty end date |
| last_maintenance | String? | Optional, ISO date | Last service date |
| next_maintenance | String? | Optional, ISO date | Next service due |
| condition | String? | Default: good | Current condition |
| notes | String? | Optional | Additional notes |

**Asset Categories:**
| Category | Description |
|----------|-------------|
| appliance | Major appliances |
| hvac | Heating/cooling systems |
| plumbing | Water heater, fixtures |
| electrical | Panels, systems |
| structural | Foundation, roof |
| furniture | Major furniture |
| outdoor | External equipment |
| safety | Safety systems |

**JSON Serialization:**
```json
{
  "id": "asset-1",
  "name": "Refrigerator",
  "description": "French door refrigerator with ice maker",
  "category": "appliance",
  "location": "Kitchen",
  "manufacturer": "Samsung",
  "model_number": "RF28R7551SR",
  "purchase_date": "2022-03-15",
  "purchase_price": 2499.00,
  "warranty_expires": "2027-03-15",
  "condition": "excellent",
  "notes": "Extended warranty purchased"
}
```

## Use Cases

### UC-001: View Weekly Tasks

**Actor:** User

**Preconditions:**
- User has access to the home manager

**Flow:**
1. User requests weekly task view
2. System retrieves tasks for current week
3. System groups tasks by day
4. System returns weekly task data

**Postconditions:**
- Weekly tasks displayed with status

**Acceptance Criteria:**
- [ ] All 7 days shown (Monday-Sunday)
- [ ] Tasks grouped under correct day
- [ ] Completion status visible
- [ ] Category icons displayed

### UC-002: View Today's Tasks

**Actor:** User

**Preconditions:**
- User has access to the home manager

**Flow:**
1. User requests today's tasks (or specific date)
2. System determines day from date
3. System retrieves tasks for that day
4. System returns daily tasks with details

**Postconditions:**
- Today's tasks displayed with priority

**Acceptance Criteria:**
- [ ] Correct day identified from date
- [ ] Tasks sorted by priority
- [ ] Estimated time shown
- [ ] Category visible

### UC-003: Complete Task

**Actor:** User

**Preconditions:**
- Task exists and is not completed

**Flow:**
1. User marks task as complete (checkbox)
2. System updates task.completed = true
3. System recalculates statistics
4. UI updates to show completion

**Postconditions:**
- Task marked complete
- Stats reflect new completion

**Acceptance Criteria:**
- [ ] Task status changes visually
- [ ] Completion rate updates
- [ ] Can undo completion

### UC-004: Create Task (Planned)

**Actor:** User

**Preconditions:**
- User is authenticated

**Flow:**
1. User opens create task form
2. User enters title, description, day, category
3. User sets priority and estimated time
4. User saves task
5. System creates task and adds to week

**Postconditions:**
- New task added to appropriate day

**Acceptance Criteria:**
- [ ] Task appears on correct day
- [ ] All fields saved
- [ ] Stats update to include new task

### UC-005: Manage Goals

**Actor:** User

**Preconditions:**
- User has access to the home manager

**Flow:**
1. User views goals list
2. User can update goal progress
3. User can create new goals
4. User can mark goals complete

**Postconditions:**
- Goals reflect current status

**Acceptance Criteria:**
- [ ] Progress updates visually (progress bar)
- [ ] Goal categories match task categories
- [ ] Target dates displayed
- [ ] Can deactivate completed goals

### UC-006: Track Home Statistics

**Actor:** User

**Preconditions:**
- Tasks and goals exist

**Flow:**
1. User requests statistics view
2. System aggregates task completion data
3. System aggregates goal progress data
4. System returns comprehensive stats

**Postconditions:**
- Statistics displayed

**Acceptance Criteria:**
- [ ] Task completion rate shown
- [ ] Total estimated time displayed
- [ ] Goal progress averaged
- [ ] Category breakdown available

## UI Workflows

### Screen: Home Manager Dashboard

**Purpose:** Overview of tasks, goals, and statistics

**Entry Points:**
- Main app navigation
- Dashboard widget

**Components:**
- TodayTasksCard: Today's tasks with quick complete
- WeeklyTasksPreview: First 3 days summary
- GoalsList: Active goals with progress bars
- StatsCard: Completion rates and totals
- QuickActions: Add task, view all tasks

**Actions:**
| Action | Trigger | Result |
|--------|---------|--------|
| Complete Task | Checkbox tap | Mark task complete |
| View All Tasks | Button tap | Navigate to weekly view |
| View Goal | Goal tap | Show goal details |
| Add Task | FAB tap | Open task form (planned) |

**Navigation:**
- View All → Weekly Tasks Screen
- Goal tap → Goal Detail (planned)

### Screen: Weekly Tasks (Planned)

**Purpose:** Full week task view with all days

**Entry Points:**
- Dashboard "View All" button

**Components:**
- WeekSelector: Navigate between weeks
- DayColumns: Vertical list per day
- TaskCard: Task with checkbox, category icon
- FilterChips: Filter by category
- SortOptions: Sort by priority, time

**Actions:**
| Action | Trigger | Result |
|--------|---------|--------|
| Complete Task | Checkbox | Toggle completion |
| Edit Task | Task tap | Open editor (planned) |
| Filter | Chip tap | Filter task list |
| Previous Week | Arrow | Load previous week |
| Next Week | Arrow | Load next week |

**Navigation:**
- Task tap → Task Editor
- Back → Dashboard

### Screen: Task Editor (Planned)

**Purpose:** Create or edit a task

**Entry Points:**
- Add task action
- Edit task action

**Components:**
- TitleField: Task name input
- DescriptionField: Optional details
- DaySelector: Day picker (Mon-Sun)
- CategorySelector: Category dropdown
- PrioritySelector: Priority radio buttons
- DurationInput: Estimated minutes
- SaveButton: Confirm changes

**Actions:**
| Action | Trigger | Result |
|--------|---------|--------|
| Save | Button tap | Save task, return |
| Cancel | Back/cancel | Discard changes |
| Delete | Delete button | Remove task |

**Navigation:**
- Save → Previous screen
- Delete → Previous screen with task removed

### Screen: Goal Manager (Planned)

**Purpose:** View and manage home improvement goals

**Entry Points:**
- Dashboard goals section
- Main navigation

**Components:**
- GoalList: All goals with progress
- GoalCard: Title, category, progress bar, target date
- CreateGoalButton: Add new goal
- FilterTabs: Active, Completed, All

**Actions:**
| Action | Trigger | Result |
|--------|---------|--------|
| Update Progress | Slider | Change goal progress |
| Create Goal | Button | Open goal form |
| Complete Goal | Button | Set progress to 100% |
| Delete Goal | Menu action | Remove goal |

**Navigation:**
- Goal tap → Goal Detail
- Create → Goal Editor

## API Specification

### GET /health

**Description:** Health check endpoint

**Authentication:** None

**Response 200:**
```json
{"status": "ok"}
```

### GET /ready

**Description:** Readiness probe

**Authentication:** None

**Response 200:**
```json
{"status": "ready"}
```

### GET /tasks/weekly/{user_id}

**Description:** Get all tasks for the week

**Authentication:** None (planned: JWT Bearer)

**Path Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| user_id | string | Yes | User identifier |

**Query Parameters:**
| Name | Type | Default | Description |
|------|------|---------|-------------|
| week_start | string | current week | ISO date for week start |

**Response 200:**
```json
{
  "user_id": "user-123",
  "week_start": "2026-01-20",
  "tasks": [
    {
      "id": "1",
      "title": "Laundry",
      "day": "Monday",
      "category": "chores",
      "priority": "high",
      "completed": false,
      "estimated_minutes": 60
    }
  ]
}
```

### GET /tasks/today/{user_id}

**Description:** Get tasks for today (or specified date)

**Authentication:** None (planned: JWT Bearer)

**Path Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| user_id | string | Yes | User identifier |

**Query Parameters:**
| Name | Type | Default | Description |
|------|------|---------|-------------|
| date | string | today | ISO date (YYYY-MM-DD) |

**Response 200:**
```json
{
  "user_id": "user-123",
  "day": "Monday",
  "tasks": [
    {"id": "1", "title": "Laundry", "category": "chores", ...},
    {"id": "2", "title": "Grocery Shopping", "category": "errands", ...}
  ]
}
```

### GET /tasks/category/{user_id}/{category}

**Description:** Get tasks by category

**Authentication:** None (planned: JWT Bearer)

**Path Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| user_id | string | Yes | User identifier |
| category | string | Yes | Task category |

**Response 200:**
```json
{
  "user_id": "user-123",
  "category": "cleaning",
  "tasks": [
    {"id": "3", "title": "Vacuum Living Room", "day": "Tuesday", ...},
    {"id": "5", "title": "Clean Bathrooms", "day": "Wednesday", ...}
  ]
}
```

### GET /goals/{user_id}

**Description:** Get all goals for user

**Authentication:** None (planned: JWT Bearer)

**Path Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| user_id | string | Yes | User identifier |

**Response 200:**
```json
{
  "user_id": "user-123",
  "goals": [
    {
      "id": "g1",
      "title": "Organize Garage",
      "description": "Sort through items, donate unused things",
      "category": "organizing",
      "target_date": "2026-12-31",
      "progress": 25,
      "is_active": true
    }
  ]
}
```

### GET /stats/{user_id}

**Description:** Get statistics for user

**Authentication:** None (planned: JWT Bearer)

**Path Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| user_id | string | Yes | User identifier |

**Response 200:**
```json
{
  "user_id": "user-123",
  "tasks": {
    "total": 14,
    "completed": 0,
    "completion_rate": 0.0,
    "total_estimated_minutes": 610
  },
  "goals": {
    "total": 3,
    "active": 3,
    "average_progress": 41.7
  }
}
```

### POST /tasks/{user_id} (Planned)

**Description:** Create a new task

**Authentication:** Required (JWT Bearer)

**Request Body:**
```json
{
  "title": "string - required",
  "description": "string - optional",
  "day": "string - required (Monday-Sunday)",
  "category": "string - required",
  "priority": "string - optional (default: medium)",
  "estimated_minutes": "int - optional"
}
```

**Response 201:**
```json
{
  "id": "new-task-id",
  "title": "New Task",
  "day": "Monday",
  "category": "chores",
  "completed": false
}
```

### PATCH /tasks/{user_id}/{task_id} (Planned)

**Description:** Update a task

**Authentication:** Required (JWT Bearer)

**Request Body:**
```json
{
  "title": "string - optional",
  "completed": "boolean - optional",
  "priority": "string - optional"
}
```

### DELETE /tasks/{user_id}/{task_id} (Planned)

**Description:** Delete a task

**Authentication:** Required (JWT Bearer)

**Response 204:** No content

### POST /goals/{user_id} (Planned)

**Description:** Create a new goal

**Authentication:** Required (JWT Bearer)

**Request Body:**
```json
{
  "title": "string - required",
  "description": "string - optional",
  "category": "string - required",
  "target_date": "string - optional (ISO date)",
  "progress": "int - optional (default: 0)"
}
```

### PATCH /goals/{user_id}/{goal_id} (Planned)

**Description:** Update a goal

**Authentication:** Required (JWT Bearer)

**Request Body:**
```json
{
  "progress": "int - optional (0-100)",
  "is_active": "boolean - optional"
}
```

### GET /tools/{user_id}

**Description:** Get all tools for user

**Authentication:** None (planned: JWT Bearer)

**Path Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| user_id | string | Yes | User identifier |

**Response 200:**
```json
{
  "user_id": "user-123",
  "tools": [
    {
      "id": "tool-1",
      "name": "Cordless Drill",
      "category": "power_tool",
      "owned": true,
      "condition": "excellent"
    }
  ]
}
```

### GET /tools/{user_id}/item/{tool_id}

**Description:** Get a specific tool by ID

**Path Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| user_id | string | Yes | User identifier |
| tool_id | string | Yes | Tool identifier |

**Response 200:**
```json
{
  "user_id": "user-123",
  "tool": { "id": "tool-1", "name": "Cordless Drill", ... }
}
```

### GET /tools/{user_id}/category/{category}

**Description:** Get tools filtered by category

**Path Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| user_id | string | Yes | User identifier |
| category | string | Yes | Tool category |

### GET /tools/{user_id}/owned

**Description:** Get tools filtered by ownership status

**Query Parameters:**
| Name | Type | Default | Description |
|------|------|---------|-------------|
| owned | bool | true | Ownership filter |

### GET /materials/{user_id}

**Description:** Get all materials for user

**Path Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| user_id | string | Yes | User identifier |

**Response 200:**
```json
{
  "user_id": "user-123",
  "materials": [
    {
      "id": "mat-1",
      "name": "2x4 Lumber (8ft)",
      "quantity": 10,
      "unit": "each",
      "purchased": true
    }
  ]
}
```

### GET /materials/{user_id}/item/{material_id}

**Description:** Get a specific material by ID

### GET /materials/{user_id}/purchased/{purchased}

**Description:** Get materials filtered by purchase status

**Path Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| purchased | bool | Yes | Purchase status filter |

### GET /materials/{user_id}/supplier/{supplier}

**Description:** Get materials filtered by supplier

### GET /resources/{user_id}

**Description:** Get all resources for user

**Response 200:**
```json
{
  "user_id": "user-123",
  "resources": [
    {
      "id": "res-1",
      "name": "DIY Garage Shelving Guide",
      "type": "guide",
      "url": "https://example.com/garage-shelving"
    }
  ]
}
```

### GET /resources/{user_id}/item/{resource_id}

**Description:** Get a specific resource by ID

### GET /resources/{user_id}/type/{resource_type}

**Description:** Get resources filtered by type

### GET /projects/{user_id}

**Description:** Get all projects for user

**Response 200:**
```json
{
  "user_id": "user-123",
  "projects": [
    {
      "id": "proj-1",
      "title": "Garage Storage Shelves",
      "status": "in_progress",
      "category": "improvement",
      "budget": 300.00,
      "tools": [...],
      "materials": [...],
      "resources": [...]
    }
  ]
}
```

### GET /projects/{user_id}/item/{project_id}

**Description:** Get a specific project by ID with resolved tools, materials, and resources

**Response 200:**
```json
{
  "user_id": "user-123",
  "project": { ... },
  "resolved_tools": [
    { "id": "tool-1", "name": "Cordless Drill", "project_notes": "For drilling" }
  ],
  "resolved_materials": [
    { "id": "mat-1", "name": "2x4 Lumber", "quantity_needed": 10 }
  ],
  "resolved_resources": [
    { "id": "res-1", "name": "DIY Guide" }
  ]
}
```

### GET /projects/{user_id}/status/{status}

**Description:** Get projects filtered by status (planned, in_progress, on_hold, completed, cancelled)

### GET /projects/{user_id}/category/{category}

**Description:** Get projects filtered by category

### GET /assets/{user_id}

**Description:** Get all home assets for user

**Response 200:**
```json
{
  "user_id": "user-123",
  "assets": [
    {
      "id": "asset-1",
      "name": "Refrigerator",
      "category": "appliance",
      "location": "Kitchen",
      "manufacturer": "Samsung",
      "warranty_expires": "2027-03-15"
    }
  ]
}
```

### GET /assets/{user_id}/item/{asset_id}

**Description:** Get a specific asset by ID

### GET /assets/{user_id}/category/{category}

**Description:** Get assets filtered by category

### GET /assets/{user_id}/location/{location}

**Description:** Get assets filtered by location (partial match)

### GET /assets/{user_id}/maintenance-due

**Description:** Get assets with upcoming or overdue maintenance

### GET /assets/{user_id}/warranty-expiring

**Description:** Get assets with warranties expiring soon

**Query Parameters:**
| Name | Type | Default | Description |
|------|------|---------|-------------|
| days | int | 90 | Days to look ahead |

## Implementation Status

### Data Models

| Model | Status | Notes |
|-------|--------|-------|
| Task | ✅ Implemented | Pydantic model in backend |
| Goal | ✅ Implemented | Pydantic model in backend |
| WeeklyTasks | ✅ Implemented | Container model |
| DailyTasks | ✅ Implemented | Container model |
| Stats | ✅ Implemented | Computed response |
| Tool | ✅ Implemented | Tool inventory model |
| Material | ✅ Implemented | Project materials model |
| Resource | ✅ Implemented | Reference resources model |
| ProjectItem | ✅ Implemented | Junction model for project relationships |
| Project | ✅ Implemented | Home project model with tools/materials/resources |
| Asset | ✅ Implemented | Home inventory/asset model |

### API Endpoints

| Endpoint | Status | Notes |
|----------|--------|-------|
| GET /health | ✅ Implemented | Health check |
| GET /ready | ✅ Implemented | Readiness probe |
| GET /tasks/weekly/{user_id} | ✅ Implemented | Returns 14 mock tasks |
| GET /tasks/today/{user_id} | ✅ Implemented | Filters by day name |
| GET /tasks/category/{user_id}/{cat} | ✅ Implemented | Filters by category |
| GET /goals/{user_id} | ✅ Implemented | Returns 3 mock goals |
| GET /stats/{user_id} | ✅ Implemented | Aggregated stats |
| GET /tools/{user_id} | ✅ Implemented | Returns 8 mock tools |
| GET /tools/{user_id}/item/{id} | ✅ Implemented | Get tool by ID |
| GET /tools/{user_id}/category/{cat} | ✅ Implemented | Filter by category |
| GET /tools/{user_id}/owned | ✅ Implemented | Filter by ownership |
| GET /materials/{user_id} | ✅ Implemented | Returns 5 mock materials |
| GET /materials/{user_id}/item/{id} | ✅ Implemented | Get material by ID |
| GET /materials/{user_id}/purchased/{bool} | ✅ Implemented | Filter by purchase status |
| GET /materials/{user_id}/supplier/{name} | ✅ Implemented | Filter by supplier |
| GET /resources/{user_id} | ✅ Implemented | Returns 5 mock resources |
| GET /resources/{user_id}/item/{id} | ✅ Implemented | Get resource by ID |
| GET /resources/{user_id}/type/{type} | ✅ Implemented | Filter by type |
| GET /projects/{user_id} | ✅ Implemented | Returns 3 mock projects |
| GET /projects/{user_id}/item/{id} | ✅ Implemented | Get project with resolved items |
| GET /projects/{user_id}/status/{status} | ✅ Implemented | Filter by status |
| GET /projects/{user_id}/category/{cat} | ✅ Implemented | Filter by category |
| GET /assets/{user_id} | ✅ Implemented | Returns 8 mock assets |
| GET /assets/{user_id}/item/{id} | ✅ Implemented | Get asset by ID |
| GET /assets/{user_id}/category/{cat} | ✅ Implemented | Filter by category |
| GET /assets/{user_id}/location/{loc} | ✅ Implemented | Filter by location |
| GET /assets/{user_id}/maintenance-due | ✅ Implemented | Assets needing maintenance |
| GET /assets/{user_id}/warranty-expiring | ✅ Implemented | Expiring warranties |
| POST /tasks | ⬜ Planned | Create task |
| PATCH /tasks/{id} | ⬜ Planned | Update task |
| DELETE /tasks/{id} | ⬜ Planned | Delete task |
| POST /goals | ⬜ Planned | Create goal |
| PATCH /goals/{id} | ⬜ Planned | Update goal |
| POST /tools | ⬜ Planned | Create tool |
| POST /materials | ⬜ Planned | Create material |
| POST /resources | ⬜ Planned | Create resource |
| POST /projects | ⬜ Planned | Create project |
| POST /assets | ⬜ Planned | Create asset |

### UI Screens

| Screen | Status | Notes |
|--------|--------|-------|
| Login | ⬜ Planned | Uses shared auth_ui package |
| Register | ⬜ Planned | Uses shared auth_ui package |
| Home Dashboard | ✅ Implemented | Overview screen |
| Weekly Tasks | ⬜ Planned | Full week view |
| Task Editor | ⬜ Planned | Create/edit form |
| Goal Manager | ⬜ Planned | Goal management |
| Statistics | ⬜ Planned | Detailed stats view |

### Authentication

| Component | Status | Notes |
|-----------|--------|-------|
| AWS Amplify Integration | ⬜ Planned | Shared Cognito User Pool |
| Shared auth_ui Package | ⬜ Planned | Login/register screens |
| Token Validation | ⬜ Planned | Backend JWT verification |
| Module Access Control | ⬜ Planned | Cognito custom attributes |

### Frontend Services

| Service | Status | Notes |
|---------|--------|-------|
| HomeApiService | ✅ Implemented | HTTP client |
| getWeeklyTasks() | ✅ Implemented | Fetches weekly tasks |
| getTodayTasks() | ✅ Implemented | Fetches daily tasks |
| getGoals() | ✅ Implemented | Fetches goals |
| getStats() | ✅ Implemented | Fetches statistics |
| getTasksByCategory() | ✅ Implemented | Category filter |

### UI Components

| Component | Status | Notes |
|-----------|--------|-------|
| TaskCard | ✅ Implemented | With category icons |
| GoalCard | ✅ Implemented | With progress bar |
| WeeklyTasksPreview | ✅ Implemented | 3-day summary |

**Legend:** ✅ Implemented | 🚧 Partial | ⬜ Planned

## Technical Notes

### Backend
- Framework: FastAPI
- Port: 8020
- Storage: In-memory mock data (no database)
- CORS: Open policy (all origins allowed)

### Frontend
- Framework: Flutter Web
- Package: frontend/packages/home_ui
- State Management: StatefulWidget with setState()
- API Base URL: http://localhost:8020

### Key Implementation Details
- Mock data provides 14 tasks across 7 days (2 per day)
- Mock data provides 3 goals with varying progress
- User ID accepted but currently ignored (same data for all)
- Date parsing handles ISO and YYYY-MM-DD formats
- Category icons hardcoded in TaskCard widget
- Task completion is client-side only (no persistence)
