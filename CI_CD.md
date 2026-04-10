# Huong dan CI/CD

## CI

Workflow: `.github/workflows/ci.yml`

CI se chay khi push len `main`, `develop`, `feature/**` hoac khi tao pull request vao `main`, `develop`.

Pipeline hien tai gom:

- Backend smoke test: `./mvnw -Dtest=LtJavaApplicationTests test`
- Frontend build: `npm ci` va `npm run build`
- Docker build cho backend va frontend

Luu y: frontend lint hien chua bat trong CI vi codebase dang co nhieu loi lint san co. Khi don lint xong, co the them lai buoc `npm run lint`.

## Docker Publish

Workflow: `.github/workflows/deploy.yml`

Workflow nay chi build va push Docker image len Docker Hub. Khong con deploy server, khong SSH, khong tao file compose tren Ubuntu.

Can khai bao GitHub Secrets:

- `DOCKERHUB_USERNAME`: Docker Hub username
- `DOCKERHUB_TOKEN`: Docker Hub access token

Image duoc push len:

```bash
<dockerhub-username>/backend-service:<git-sha>
<dockerhub-username>/backend-service:latest
<dockerhub-username>/frontend-service:<git-sha>
<dockerhub-username>/frontend-service:latest
```

Ban co the chay workflow thu cong trong tab GitHub Actions, hoac de no tu chay sau khi `CI` tren `main` thanh cong.

## Postman API test

Workflow: `.github/workflows/postman-api-test.yml`

Workflow nay chay thu cong vi cac file Postman hien dang rong. Sau khi them collection va environment vao:

- `LTJava/postman/collections/backend-api.postman_collection.json`
- `LTJava/postman/environments/dev.postman_environment.json`
- `LTJava/postman/environments/staging.postman_environment.json`

Ban co the chay workflow tren GitHub Actions va tai report HTML/JUnit/JSON tu artifacts.
