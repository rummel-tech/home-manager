# Home Manager

Weekly home task management and goal tracking application with FastAPI backend and Flutter web frontend.

## 🏠 Features

- **Weekly Task Management**: Organize home tasks across the week
- **Today's Tasks**: Quick view of tasks for the current day
- **Goals Tracking**: Set and monitor home improvement goals with progress tracking
- **Category Organization**: Tasks organized by category (cleaning, chores, cooking, errands, outdoor, organizing, maintenance, planning)
- **Priority Levels**: High, medium, and low priority task management
- **Time Estimates**: Track estimated time for each task
- **Statistics Dashboard**: View completion rates and progress
- **Responsive UI**: Beautiful Flutter web interface with Material Design 3

## 📁 Project Structure

```
home-manager/
├── backend/                    # FastAPI backend
│   ├── main.py                # API endpoints
│   ├── requirements.txt       # Python dependencies
│   └── Dockerfile             # Container configuration
├── frontend/                   # Flutter frontend
│   ├── app/home_app/          # Main Flutter application
│   └── packages/home_ui/      # Reusable UI components
└── .github/workflows/         # CI/CD workflows
    ├── deploy-frontend.yml    # GitHub Pages deployment
    └── deploy-backend.yml     # AWS ECS deployment
```

## 🏃 Quick Start

### Backend Development

```bash
cd backend
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --reload --port 8020
```

Visit: http://localhost:8020/docs

### Frontend Development

```bash
cd frontend/app/home_app
flutter pub get
flutter run -d chrome
```

### Docker

```bash
cd backend
docker build -t home-manager:local .
docker run -p 8020:8000 home-manager:local
```

## 📡 API Endpoints

- `GET /health` - Health check probe
- `GET /ready` - Readiness probe
- `GET /tasks/weekly/{user_id}` - Get all weekly tasks
- `GET /tasks/today/{user_id}` - Get today's tasks (optional date param)
- `GET /tasks/category/{user_id}/{category}` - Get tasks by category
- `GET /goals/{user_id}` - Get all goals
- `GET /stats/{user_id}` - Get statistics (completion rates, progress)

### Example Usage

```bash
# Get weekly tasks
curl http://localhost:8020/tasks/weekly/user-123

# Get today's tasks
curl http://localhost:8020/tasks/today/user-123

# Get tasks by category
curl http://localhost:8020/tasks/category/user-123/cleaning

# Get goals
curl http://localhost:8020/goals/user-123

# Get statistics
curl http://localhost:8020/stats/user-123
```

## 🚢 Deployment

### Prerequisites

**GitHub Secrets** (for automated deployment):
- `AWS_ROLE_TO_ASSUME` - AWS IAM role ARN for OIDC authentication

**GitHub Pages** (for frontend):
1. Go to Settings → Pages
2. Source: Deploy from a branch
3. Branch: `gh-pages` (created automatically)

### Automatic Deployment

Push to `main` branch triggers automatic deployment:

```bash
git add .
git commit -m "Update home manager"
git push origin main
```

**Backend**: Builds Docker image and pushes to AWS ECR
**Frontend**: Builds Flutter web app and deploys to GitHub Pages

### Manual Deployment

Trigger via GitHub Actions UI:
1. Go to **Actions** tab
2. Select workflow (Frontend or Backend)
3. Click **Run workflow**

### Access URLs

After deployment:
- **Frontend**: https://srummel.github.io/home-manager/
- **Backend API**: http://<ECS_IP>:8000/docs

## 🔧 Configuration

### Update API URL

For production, update the backend URL in:

**File**: `frontend/packages/home_ui/lib/services/home_api_service.dart`

```dart
HomeApiService({this.baseUrl = 'https://api.yourdomain.com'});
```

### CORS Configuration

The backend allows all origins by default. For production, update in `backend/main.py`:

```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://srummel.github.io"],  # Specific origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

## 🏗️ Architecture

**Backend**: FastAPI (Python 3.11)
- RESTful API design
- Automatic OpenAPI/Swagger documentation
- Docker containerization
- AWS ECS deployment

**Frontend**: Flutter Web
- Material Design 3
- Responsive layouts
- Component-based architecture
- GitHub Pages hosting

## 📦 Task Categories

- **Cleaning**: House cleaning tasks
- **Chores**: General household chores
- **Cooking**: Meal preparation and kitchen tasks
- **Errands**: Shopping and outside tasks
- **Outdoor**: Yard work and outdoor maintenance
- **Organizing**: Organization and decluttering
- **Maintenance**: Home maintenance and repairs
- **Planning**: Planning and administrative tasks

## 📊 Features in Detail

### Task Management
- **Daily View**: See all tasks for today
- **Weekly View**: Full week overview with completion tracking
- **Priority System**: Visual indicators for task priority
- **Time Tracking**: Estimated time for each task
- **Categories**: Organize tasks by type

### Goals
- **Progress Tracking**: Visual progress bars
- **Categories**: Organize goals by type
- **Target Dates**: Set deadlines for goals
- **Descriptions**: Detailed goal descriptions

### Statistics
- **Completion Rates**: Track task completion percentages
- **Time Estimates**: Total estimated time for tasks
- **Goal Progress**: Average progress across all goals
- **Active Goals**: Number of currently active goals

## 🧪 Testing

### Backend Tests
```bash
cd backend
pytest
```

### Frontend Tests
```bash
cd frontend/app/home_app
flutter test
```

## 📝 Development Workflow

1. **Create feature branch**
   ```bash
   git checkout -b feature/my-feature
   ```

2. **Make changes and test locally**
   ```bash
   # Backend
   uvicorn backend.main:app --reload

   # Frontend
   flutter run -d chrome
   ```

3. **Commit and push**
   ```bash
   git add .
   git commit -m "Add my feature"
   git push origin feature/my-feature
   ```

4. **Create Pull Request**
5. **Merge to main** (triggers auto-deployment)

## 🔐 Security

- Backend uses CORS middleware for cross-origin protection
- Secrets stored in GitHub Secrets (never in code)
- AWS authentication via OIDC (no static credentials)
- Container image scanning enabled in ECR

## 🎯 Roadmap

- [ ] User authentication (JWT)
- [ ] Persistent storage (PostgreSQL)
- [ ] Task editing and creation
- [ ] Goal management (create, update, delete)
- [ ] Recurring tasks
- [ ] Task reminders and notifications
- [ ] Calendar integration
- [ ] Mobile app (iOS/Android)
- [ ] Shopping list integration
- [ ] Family/roommate task sharing

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

MIT License - See LICENSE file for details

## 🆘 Support

- **Issues**: https://github.com/srummel/home-manager/issues
- **Discussions**: https://github.com/srummel/home-manager/discussions

## 🔗 Related Projects

- **Workout Planner**: AI-powered fitness coaching platform
  - Repository: https://github.com/srummel/workout-planner
- **Meal Planner**: Weekly meal planning application
  - Repository: https://github.com/srummel/meal-planner

## Documentation

- [Architecture](docs/ARCHITECTURE.md) - System design
- [Deployment](docs/DEPLOYMENT.md) - Deployment guide
- [Changelog](./CHANGELOG.md) - Version history

---

[Platform Documentation](../../../docs/) | [Product Overview](../../../docs/products/home-manager.md)
