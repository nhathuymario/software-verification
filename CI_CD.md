# Huong dan CI/CD

## CI

Workflow: `.github/workflows/ci.yml`

CI se chay khi push len `main`, `develop`, `feature/**` hoac khi tao pull request vao `main`, `develop`.

Pipeline hien tai gom:

- Backend smoke test: `./mvnw -Dtest=LtJavaApplicationTests test`
- Frontend build: `npm ci` va `npm run build`
- Docker build cho backend va frontend

Luu y: frontend lint hien chua bat trong CI vi codebase dang co nhieu loi lint san co. Khi don lint xong, co the them lai buoc `npm run lint`.

## Deploy

Workflow: `.github/workflows/deploy.yml`

Deploy co the chay thu cong tu tab GitHub Actions, hoac tu dong sau khi workflow `CI` tren branch `main` thanh cong.

Deploy workflow da co cac bao ve co ban:

- Khong cho chay deploy song song (`concurrency`) de tranh ghi de service.
- Kiem tra service `backend` da `running` sau khi `docker compose up`.
- Kiem tra log backend co dong `Started LtJavaApplication` de xac nhan app boot thanh cong.
- Neu deploy loi, workflow tu dong rollback ve commit truoc do va chay lai `docker compose up -d --build`.

Can khai bao GitHub Secrets:

- `SSH_HOST`: IP hoac domain cua server
- `SSH_USERNAME`: user SSH tren server
- `SSH_KEY`: private key SSH co quyen vao server
- `SSH_PORT`: cong SSH, co the de `22`
- `DEPLOY_PATH`: duong dan repo tren server, vi du `/opt/LTJava`

Server can cai san:

- Git
- Docker
- Docker Compose plugin

Lenh deploy tren server:

```bash
cd "$DEPLOY_PATH"
PREV_COMMIT="$(git rev-parse HEAD)"
git fetch origin main
git pull --ff-only origin main
docker compose up -d --build
docker compose ps --status running
docker compose logs --tail=300 backend | grep "Started LtJavaApplication"
docker image prune -f
```

Neu mot trong cac buoc verify that bai, workflow se rollback:

```bash
git reset --hard "$PREV_COMMIT"
docker compose up -d --build
```

Neu dung AI that, them `GEMINI_API_KEY` vao file `.env` tren server de `docker-compose.yml` truyen vao backend.

## Postman API test

Workflow: `.github/workflows/postman-api-test.yml`

Workflow nay chay thu cong vi cac file Postman hien dang rong. Sau khi them collection va environment vao:

- `LTJava/postman/collections/backend-api.postman_collection.json`
- `LTJava/postman/environments/dev.postman_environment.json`
- `LTJava/postman/environments/staging.postman_environment.json`

Ban co the chay workflow tren GitHub Actions va tai report HTML/JUnit/JSON tu artifacts.
