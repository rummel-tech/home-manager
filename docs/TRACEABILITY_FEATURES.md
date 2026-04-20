# Home Manager — Feature Traceability Matrix

Maps each user-facing feature from OBJECTIVES.md through specification, tests, implementation, and release verification.

---

## Traceability Chain

```
OBJECTIVES.md (product description)
    → docs/SPECIFICATION.md / docs/ARCHITECTURE.md (specification)
    → docs/WORKFLOWS.md (primary user journeys and screen map)
        → frontend/packages/home_ui/test/ — widget/service unit tests
        → frontend/app/home_app/test/ — app-level widget tests
        → frontend/app/home_app/integration_test/app_test.dart — end-to-end workflow tests
            → Source implementation
                → docs/DEPLOYMENT.md smoke test (release gate)
```

---

## Development Status Note

Home Manager is at MVP stage. Backend serves mock data (in-memory, read-only). Frontend reads tasks, goals, and stats. Database persistence and CRUD operations are in progress.

---

## FR-1 · Task Management

| ID | Feature | Product Spec | Tests | Implementation | Release Gate |
|----|---------|-------------|-------|----------------|--------------|
| FR-1.1–1.3 | View tasks with title, priority, category, estimated time | OBJECTIVES.md FR-1.1–1.4 | `task_card_test` · `home_screen_test` — "Today's Tasks section displays" · `integration_test/app_test` — "Today's Tasks section displays", "App loads and displays home screen" | `frontend/packages/home_ui/lib/ui_components/task_card.dart` · `frontend/packages/home_ui/lib/screens/home_screen.dart` · `frontend/packages/home_ui/lib/services/home_api_service.dart` | Home screen loads with tasks |
| FR-1.5 | Mark tasks complete | OBJECTIVES.md FR-1.5 | None — gap (backend is read-only; completion is client-side only) | `frontend/packages/home_ui/lib/ui_components/task_card.dart` | — |
| FR-1.6 | View tasks by day (today's tasks) | OBJECTIVES.md FR-1.6 | `home_api_service_test` · `home_screen_test` · `integration_test/app_test` — "Today's Tasks section displays" | `frontend/packages/home_ui/lib/services/home_api_service.dart` · `frontend/packages/home_ui/lib/screens/home_screen.dart` | — |
| FR-1.7 | View tasks by week | OBJECTIVES.md FR-1.6 | `home_api_service_test` · `integration_test/app_test` — "App loads and displays home screen" | `frontend/packages/home_ui/lib/ui_components/weekly_tasks_preview.dart` · `frontend/packages/home_ui/lib/services/home_api_service.dart` | — |

---

## FR-2 · Weekly Planning

| ID | Feature | Product Spec | Tests | Implementation | Release Gate |
|----|---------|-------------|-------|----------------|--------------|
| FR-2.1–2.2 | Create and view weekly task plans | OBJECTIVES.md FR-2.1–2.2 | `home_api_service_test` · `integration_test/app_test` | `frontend/packages/home_ui/lib/ui_components/weekly_tasks_preview.dart` · `frontend/packages/home_ui/lib/services/home_api_service.dart` | — |
| FR-2.3 | View completion percentage | OBJECTIVES.md FR-2.3 | `home_screen_test` | `frontend/packages/home_ui/lib/screens/home_screen.dart` | — |
| FR-2.4 | Rollover incomplete tasks | OBJECTIVES.md FR-2.4 | None — gap (planned) | Planned | — |

---

## FR-3 · Goals

| ID | Feature | Product Spec | Tests | Implementation | Release Gate |
|----|---------|-------------|-------|----------------|--------------|
| FR-3.1–3.3 | View goals with progress (0–100%) and category | OBJECTIVES.md FR-3.1–3.3 | `goal_card_test` · `home_screen_test` — "Goals section displays" · `integration_test/app_test` — "Goals section displays" | `frontend/packages/home_ui/lib/ui_components/goal_card.dart` · `frontend/packages/home_ui/lib/screens/home_screen.dart` · `frontend/packages/home_ui/lib/services/home_api_service.dart` | Home screen shows goals |
| FR-3.4 | Mark goals complete | OBJECTIVES.md FR-3.4 | None — gap (backend read-only) | Planned | — |
| FR-3.5 | View active and completed goals | OBJECTIVES.md FR-3.5 | None — gap | Planned | — |

---

## FR-4 · Recurring Tasks

| ID | Feature | Product Spec | Tests | Implementation | Release Gate |
|----|---------|-------------|-------|----------------|--------------|
| FR-4.1–4.4 | Define and auto-generate recurring tasks | OBJECTIVES.md FR-4.1–4.4 | None — gap (planned) | Planned | — |

---

## FR-5 · Statistics

| ID | Feature | Product Spec | Tests | Implementation | Release Gate |
|----|---------|-------------|-------|----------------|--------------|
| FR-5.1–5.3 | Task completion rates, time by category, goal progress overview | OBJECTIVES.md FR-5.1–5.3 | `home_api_service_test` · `home_screen_test` | `frontend/packages/home_ui/lib/services/home_api_service.dart` · `frontend/packages/home_ui/lib/screens/home_screen.dart` | — |
| FR-5.4 | Overdue task alerts | OBJECTIVES.md FR-5.4 | None — gap | Planned | — |

---

## Authentication (Cross-cutting)

| Feature | Tests | Implementation | Release Gate |
|---------|-------|----------------|--------------|
| Login screen | None — gap | `frontend/packages/home_ui/lib/screens/login_screen.dart` | Login succeeds |
| API connectivity with configurable base URL | `home_api_service_test` | `frontend/packages/home_ui/lib/services/home_api_service.dart` | — |

---

## Integration Test Coverage

`frontend/app/home_app/integration_test/app_test.dart` covers:
- App loads and displays home screen
- Today's Tasks section displays
- Goals section displays
- Refresh button triggers data reload
- App maintains scroll position
- Pull to refresh works
- App handles errors gracefully
- Navigation structure is present
- Material Design 3 theme applied
- App responds to multiple interactions
- App attempts to load data from backend
- App displays loading or data state
- All major UI sections render

---

## Coverage Summary

| FR Group | Sub-features | Tests | Gaps |
|----------|-------------|-------|------|
| FR-1 Task Management | 7 | Widget + integration + service | Task CRUD (backend read-only — in progress) |
| FR-2 Weekly Planning | 4 | Partial | Rollover planned and untested |
| FR-3 Goals | 5 | Widget + integration | Goal CRUD, completion — in progress |
| FR-4 Recurring Tasks | 4 | None | Entire group — planned |
| FR-5 Statistics | 4 | Partial | Overdue alerts untested |

> **Priority gaps**: Backend persistence and CRUD endpoints are the core gap — once implemented, add `test_tasks_crud.py`, `test_goals_crud.py`; add login screen widget test; add task completion toggle test.

## Workflow Documentation

Primary user journeys documented in `docs/WORKFLOWS.md`:
- Workflow 1: Daily Task Management (view, complete tasks)
- Workflow 2: Weekly Planning (view, add tasks, rollover)
- Workflow 3: Goal Tracking (create, update, complete)
- Workflow 4: Statistics
- Workflow 5: Recurring Tasks (planned)
- Workflow 6: Refresh / Data Sync
