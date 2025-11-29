# Deployment

This application is deployed via the centralized [infrastructure repository](https://github.com/srummel/infrastructure).

## Deployment Process

All CI/CD pipelines and deployment workflows are maintained in the infrastructure repository for:
- Centralized credential management
- Consistent deployment patterns
- Easier maintenance across multiple applications

## How to Deploy

### Option 1: Automatic (Push to main)

Deployments can be triggered automatically by pushing to the `main` branch:

```bash
git add .
git commit -m "Update application"
git push origin main
```

This requires a trigger workflow in `.github/workflows/deploy.yml` that calls the infrastructure repository.

### Option 2: Manual Deployment

Deploy manually via the infrastructure repository:

#### Deploy Frontend

```bash
gh workflow run deploy-home-manager-frontend.yml \
  --repo srummel/infrastructure
```

Or via GitHub UI:
1. Go to https://github.com/srummel/infrastructure/actions
2. Select "Deploy Home Manager Frontend"
3. Click "Run workflow"
4. Click "Run workflow" button

#### Deploy Backend

```bash
gh workflow run deploy-home-manager-backend.yml \
  --repo srummel/infrastructure
```

Or via GitHub UI:
1. Go to https://github.com/srummel/infrastructure/actions
2. Select "Deploy Home Manager Backend"
3. Click "Run workflow"
4. Click "Run workflow" button

## Deployment Status

View deployment status and logs:
- https://github.com/srummel/infrastructure/actions

## Application URLs

After successful deployment:
- **Frontend**: https://srummel.github.io/home-manager/
- **Backend API**: http://<ECS_IP>:8020/docs
  - Health check: http://<ECS_IP>:8020/health
  - API docs: http://<ECS_IP>:8020/docs

## Local Development

Backend:
```bash
cd backend
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --reload --port 8020
```

Frontend:
```bash
cd frontend/app/home_app
flutter pub get
flutter run -d chrome
```

## Infrastructure Configuration

Deployment configuration is stored in the infrastructure repository:
- Workflow: `.github/workflows/deploy-home-manager-*.yml`
- Config: `config/home-manager.yml`
- ECS Task Definition: `aws/ecs-task-definitions/home-manager.json`

## Troubleshooting

If deployment fails:
1. Check workflow logs in infrastructure repository
2. Verify AWS credentials are configured correctly
3. Check CloudWatch logs: `aws logs tail /ecs/home-manager --follow`
4. Verify ECS task is running: `aws ecs list-tasks --cluster app-cluster --service-name home-manager-service`

For more information, see the [Infrastructure Repository](https://github.com/srummel/infrastructure).
