# Home Manager Architecture

## Overview

The Home Manager is a Flutter application for home maintenance tracking and task management, supported by a Python/FastAPI backend service.

## System Components

```
┌─────────────────────┐
│   Flutter App       │
│   (home-manager)    │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│   FastAPI Service   │
│   (port 8020)       │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│   PostgreSQL/SQLite │
└─────────────────────┘
```

## Frontend Architecture

### Project Structure

```
home-manager/
├── lib/
│   ├── main.dart           # App entry point
│   ├── config/             # Environment configuration
│   ├── models/             # Data models
│   ├── services/           # API services
│   └── screens/            # UI screens
├── packages/               # Feature packages (if modular)
└── test/                   # Unit tests
```

### Key Components

- **Task Dashboard**: Overview of pending maintenance
- **Room Manager**: Organization by room/area
- **Scheduler**: Recurring task management
- **Service Providers**: Contractor tracking

## Backend Architecture

### Service Structure

```
services/home-manager/
├── main.py                 # FastAPI app
├── routers/                # API endpoints
├── models/                 # Pydantic models
├── database.py             # Database operations
└── tests/                  # Pytest suite
```

### Key Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/tasks` | GET/POST | Task CRUD |
| `/rooms` | GET/POST | Room CRUD |
| `/providers` | GET/POST | Service provider CRUD |
| `/schedules` | GET/POST | Recurring schedules |

## Data Models

### Task
- id, title, description
- room_id, priority, status
- due_date, recurrence_rule

### Room
- id, name, type
- tasks, assets

### ServiceProvider
- id, name, specialty
- contact_info, rating

## Related Documentation

- [Module README](../README.md)
- [Service README](../../../../services/home-manager/README.md)
- [Deployment Guide](./DEPLOYMENT.md)
- [Platform Architecture](../../../../docs/ARCHITECTURE.md)

---

[Back to Module](../) | [Platform Documentation](../../../../docs/)
