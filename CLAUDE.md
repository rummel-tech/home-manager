# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Home Manager is a comprehensive home management application for tracking weekly tasks, goals, home projects, tools, materials, resources, and home assets. It features a FastAPI backend and Flutter web frontend. The backend is stateless (in-memory data only), and the frontend is a Material Design 3 Flutter web app hosted on GitHub Pages.

**Key Features**:
- Weekly task management with categories and priorities
- Goal tracking with progress
- Home project management with tools, materials, and resources
- Tool inventory tracking
- Material/supplies tracking for projects
- Resource library (guides, videos, contacts, manuals)
- Home asset inventory with warranty and maintenance tracking

## Common Development Commands

### Backend (FastAPI - Python)

```bash
# Start development server
cd backend
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --reload --port 8020

# Build and run Docker container locally
cd backend
docker build -t home-manager:local .
docker run -p 8020:8000 home-manager:local

# Backend runs on http://localhost:8020
# API docs available at http://localhost:8020/docs
```

### Frontend (Flutter Web)

```bash
# Install dependencies
cd frontend/app/home_app
flutter pub get

# Run in Chrome for development
cd frontend/app/home_app
flutter run -d chrome

# Build for production
cd frontend/app/home_app
flutter build web --release

# Output: frontend/app/home_app/build/web/
```

### Testing

```bash
# Backend tests (note: no tests currently exist)
cd backend
pytest

# Frontend tests (note: no tests currently exist)
cd frontend/app/home_app
flutter test
```

## Architecture

### Backend Architecture (`backend/main.py`)

- **Stateless API**: All data is generated in-memory via helper functions (`_default_weekly_tasks()`, `_default_goals()`, `_default_tools()`, `_default_materials()`, `_default_resources()`, `_default_projects()`, `_default_assets()`)
- **No persistence**: Data resets on every request - suitable only for development/demo
- **User IDs**: Accepted as URL path parameters but currently ignored (all users get same mock data)
- **CORS**: Open policy allowing all origins - must be restricted for production

**Data Models (Pydantic)**:
- `Task`: id, title, description, day (Monday-Sunday), category, priority, completed, estimated_minutes
- `Goal`: id, title, description, category, target_date, progress (0-100), is_active
- `Tool`: id, name, description, category, owned, condition, storage_location, purchase_date, notes
- `Material`: id, name, description, quantity, unit, unit_cost, total_cost, supplier, purchased, notes
- `Resource`: id, name, type, url, description, notes
- `ProjectItem`: item_id, item_type (tool/material/resource), quantity_needed, notes
- `Project`: id, title, description, status, category, priority, dates, budget, actual_cost, tools[], materials[], resources[], tasks[], notes
- `Asset`: id, name, description, category, location, manufacturer, model_number, serial_number, purchase_date, purchase_price, warranty_expires, maintenance dates, condition, notes

**Task/Goal Categories**: cleaning, chores, cooking, errands, outdoor, organizing, maintenance, planning
**Tool Categories**: power_tool, hand_tool, measuring, safety, garden, cleaning
**Project Categories**: maintenance, renovation, repair, improvement, outdoor, organization
**Asset Categories**: appliance, hvac, plumbing, electrical, structural, furniture, outdoor, safety

**API Endpoints**:
- `GET /health` - Health check
- `GET /ready` - Readiness probe
- `GET /tasks/weekly/{user_id}` - All 14 weekly tasks
- `GET /tasks/today/{user_id}?date=YYYY-MM-DD` - Tasks filtered by day name
- `GET /tasks/category/{user_id}/{category}` - Tasks filtered by category
- `GET /goals/{user_id}` - All goals (3 mock goals)
- `GET /stats/{user_id}` - Aggregated statistics (completion rates, goal progress)
- `GET /tools/{user_id}` - All tools (8 mock tools)
- `GET /tools/{user_id}/item/{tool_id}` - Single tool by ID
- `GET /tools/{user_id}/category/{category}` - Tools by category
- `GET /tools/{user_id}/owned?owned=bool` - Tools by ownership
- `GET /materials/{user_id}` - All materials (5 mock materials)
- `GET /materials/{user_id}/item/{material_id}` - Single material by ID
- `GET /materials/{user_id}/purchased/{bool}` - Materials by purchase status
- `GET /materials/{user_id}/supplier/{supplier}` - Materials by supplier
- `GET /resources/{user_id}` - All resources (5 mock resources)
- `GET /resources/{user_id}/item/{resource_id}` - Single resource by ID
- `GET /resources/{user_id}/type/{type}` - Resources by type
- `GET /projects/{user_id}` - All projects (3 mock projects)
- `GET /projects/{user_id}/item/{project_id}` - Project with resolved tools/materials/resources
- `GET /projects/{user_id}/status/{status}` - Projects by status
- `GET /projects/{user_id}/category/{category}` - Projects by category
- `GET /assets/{user_id}` - All assets (8 mock assets)
- `GET /assets/{user_id}/item/{asset_id}` - Single asset by ID
- `GET /assets/{user_id}/category/{category}` - Assets by category
- `GET /assets/{user_id}/location/{location}` - Assets by location (partial match)
- `GET /assets/{user_id}/maintenance-due` - Assets needing maintenance
- `GET /assets/{user_id}/warranty-expiring?days=90` - Assets with expiring warranties

### Frontend Architecture (Flutter Web)

**Package Structure**:
- `frontend/app/home_app/` - Main application entry point
- `frontend/packages/home_ui/` - Reusable screens, widgets, and services

**Key Components**:
- `main.dart` - App entry point with Material Design 3 theming
- `screens/home_screen.dart` - `HomeManagerScreen` (main dashboard) and `WeeklyTasksScreen` (full week view)
- `services/home_api_service.dart` - HTTP client for backend communication
- `ui_components/task_card.dart` - Task display with category icons, priority badges, completion checkbox
- `ui_components/goal_card.dart` - Goal display with progress bar
- `ui_components/weekly_tasks_preview.dart` - First 3 days summary widget

**State Management**: Basic `StatefulWidget` with `setState()` - no Redux, Provider, or other state management framework.

**Data Flow**:
1. `HomeManagerScreen.initState()` calls `_loadData()`
2. Four independent parallel loads: today's tasks, weekly tasks, goals, stats
3. Each has independent loading/error state
4. `HomeApiService` handles HTTP requests to `http://localhost:8020`
5. Responses decoded to model objects and stored in state
6. UI rebuilds via `setState()` with each data load completion

**Hardcoded Values**:
- User ID: `"user-123"` (in `home_screen.dart`)
- API Base URL: `http://localhost:8020` (in `home_api_service.dart`)
- Category icon mapping: Hardcoded in `TaskCard` widget

### Data Flow Between Frontend and Backend

1. Frontend makes HTTP GET requests to backend endpoints
2. Backend generates mock data on every request
3. Frontend receives JSON, decodes to Dart objects
4. UI components display data with Material Design 3 styling
5. Task completion checkboxes update local state only (no backend persistence)

## Important Patterns and Conventions

### Backend Patterns
- **Helper functions**: Prefix with underscore (`_default_weekly_tasks()`)
- **JSON field names**: snake_case (e.g., `estimated_minutes`)
- **Default values**: Use Pydantic Field defaults (e.g., `completed: bool = False`)
- **Date handling**: `_day_name_from_date_str()` converts ISO dates to day names

### Frontend Patterns
- **Widget naming**: PascalCase for classes, camelCase for variables/methods
- **Private members**: Prefix with underscore (e.g., `_loadingTasks`)
- **Component composition**: Small, focused widgets that accept data via constructors
- **Error handling**: Catch exceptions in API calls, store error strings in state
- **Package structure**: UI components in `home_ui` package, imported as local dependency

### Categories
The following categories are supported throughout the application:
- `cleaning` - House cleaning tasks
- `chores` - General household chores
- `cooking` - Meal preparation
- `errands` - Shopping and outside tasks
- `outdoor` - Yard work
- `organizing` - Organization and decluttering
- `maintenance` - Home repairs
- `planning` - Planning and administrative tasks

## Configuration for Production

### Update Backend URL in Frontend
File: `frontend/packages/home_ui/lib/services/home_api_service.dart`

Change the default baseUrl from `http://localhost:8020` to production API URL.

### Restrict CORS in Backend
File: `backend/main.py`

Update the CORS middleware to allow only specific origins:
```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://srummel.github.io"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

## Deployment

**Backend**: Automatic deployment to AWS ECR on push to `main` branch via `.github/workflows/deploy-backend.yml`. Requires `AWS_ROLE_TO_ASSUME` secret.

**Frontend**: Automatic deployment to GitHub Pages on push to `main` branch via `.github/workflows/deploy-frontend.yml`. Publishes to `gh-pages` branch.

**Frontend URL**: https://srummel.github.io/home-manager/

## Current Limitations

1. **No data persistence**: All data is in-memory and resets on every request
2. **No authentication**: User ID is path parameter only, no validation
3. **Read-only**: No POST/PUT/DELETE endpoints for tasks or goals
4. **No state synchronization**: Task completion is client-side only
5. **Static mock data**: Same 14 tasks and 3 goals for all users
6. **No tests**: Test infrastructure mentioned but no test files exist

## Future Development Roadmap

The README.md lists these planned features:
- User authentication (JWT)
- PostgreSQL database integration
- Task CRUD operations (create, update, delete)
- Goal management endpoints
- Recurring tasks
- Notifications and reminders
- Calendar integration
- Mobile apps (iOS/Android)
- Family/roommate task sharing

When implementing these features, you'll need to:
1. Add database models and migrations (SQLAlchemy recommended)
2. Replace `_default_*()` functions with database queries
3. Add authentication middleware
4. Implement POST/PUT/DELETE endpoints
5. Add proper error handling and validation
6. Update frontend to handle CRUD operations
7. Consider state management framework (Provider, Riverpod, Bloc) for complex state
