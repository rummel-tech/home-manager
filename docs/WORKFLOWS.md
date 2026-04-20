# Home Manager — Primary Workflows

Documents the main user-facing journeys through the Home Manager app.

---

## Navigation Structure

**HomeManagerScreen** is the central hub with:
- Today's Tasks section
- Weekly Tasks Preview (first 3 days)
- Goals section
- Statistics summary

Refresh button and pull-to-refresh reload all data.

---

## 1. Daily Task Management (Core Workflow)

### Step 1: View Today's Tasks
**Entry:** HomeManagerScreen → **Today's Tasks** section

- Filtered to current day of week (e.g. "Monday")
- Each task shows: title, priority badge, category icon, estimated time
- Completion checkbox on each task

### Step 2: Complete Tasks
- Tap the checkbox on a task → task marked complete (client-side)
- Completion rate shown in stats section

### Step 3: View All Tasks by Day
**Entry:** Today's Tasks section → **View Weekly** or tap a day in the weekly preview

- Full week view showing all 14 tasks across Mon–Sun
- Filter by category or priority

---

## 2. Weekly Planning

### View the Week
**Entry:** HomeManagerScreen → scroll to **Weekly Preview**

- Compact view of Mon, Tue, Wed (first 3 days)
- Tap to see full week

### Add a Task (Planned — CRUD in progress)
**Entry:** Weekly view → "+" on any day

1. Enter title, description
2. Assign priority: high, medium, low
3. Select category: cleaning, chores, cooking, errands, outdoor, organizing, maintenance, planning
4. Set estimated time (minutes)
5. Choose day of week
6. Save

### Rollover Incomplete Tasks (Planned)
- At end of week, system offers to move unfinished tasks to next week
- User can accept all, select specific tasks, or dismiss

---

## 3. Goal Tracking

### View Goals
**Entry:** HomeManagerScreen → **Goals** section

- Each goal card shows: title, category, progress bar (0–100%), target date
- "Add Goal" button in section header

### Create a Goal (Planned — CRUD in progress)
**Entry:** Goals section → **Add Goal**

1. Enter title and description
2. Select category (matches task categories)
3. Set target date
4. Save → goal appears at 0% progress

### Update Goal Progress
- Tap goal → update progress percentage (0–100%)
- Goals near 100% highlighted for completion

### Complete a Goal
- Tap goal → **Mark Complete**
- Goal moves to completed list

---

## 4. Statistics

**Entry:** HomeManagerScreen → **Statistics** section (or dedicated stats tab)

| Stat | Description |
|------|-------------|
| Task completion rate | % of tasks completed this week |
| Time by category | Estimated minutes per category |
| Goal progress | Average progress across active goals |
| Overdue tasks | Count of tasks past their due date |

---

## 5. Recurring Tasks (Planned)

**Entry:** Task creation → **Recurrence**

1. Set recurrence: daily, weekly, monthly, yearly
2. System auto-generates upcoming instances
3. Skip or reschedule individual occurrences
4. Track completion history per occurrence

---

## 6. Refresh / Data Sync

- **Refresh button** (top-right) triggers full reload from backend
- **Pull-to-refresh** gesture on the main list also reloads
- Loading indicators per section (tasks, goals, stats load independently)
- Error messages displayed per section if a load fails — other sections remain functional

---

## 7. Integration Points

### Vehicle Manager
- Shared maintenance calendar view (planned)
- Household asset overview combines home assets + vehicles

### Artemis
- Provides: task completion, goals, overdue alerts
- Consumes: calendar events for scheduling

---

## 8. Screen / Route Map

| Screen | Purpose |
|--------|---------|
| HomeManagerScreen | Main hub — today's tasks, weekly preview, goals, stats |
| WeeklyTasksScreen | Full 7-day task view |
| TaskDetailScreen | View/edit a single task (planned) |
| GoalDetailScreen | Goal progress and linked tasks (planned) |

---

## 9. Typical Workflow

```
HomeManagerScreen
    → Review Today's Tasks (3 tasks listed)
    → Tick off "Vacuum living room" → completed
    → Scroll to Goals section → "Paint garage" at 40%
    → Tap goal → update progress to 60%
    → Pull down to refresh → stats section updates completion rate
```
