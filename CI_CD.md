# Huong dan CI/CD

## CI

Workflow: `.github/workflows/ci.yml`

CI se chay khi push len `main`, `develop`, `feature/**` hoac khi tao pull request vao `main`, `develop`.

Pipeline hien tai gom:

- Backend smoke test: `./mvnw -Dtest=LtJavaApplicationTests test`
- Frontend build: `npm ci` va `npm run build`
- Docker build cho backend va frontend

Luu y: frontend lint hien chua bat trong CI vi codebase dang co nhieu loi lint san co. Khi don lint xong, co the them lai buoc `npm run lint`.

## Docker Publish and EC2 Deploy

Workflow: `.github/workflows/deploy.yml`

Workflow nay build Docker image, push len Docker Hub, sau do SSH vao EC2 va chay `docker compose`.

Can khai bao GitHub Secrets:

- `DOCKERHUB_USERNAME`: Docker Hub username
- `DOCKERHUB_TOKEN`: Docker Hub access token
- `EC2_HOST`: public IP hoac domain cua EC2
- `EC2_USER`: user SSH, thuong la `ubuntu` hoac `ec2-user`
- `EC2_SSH_KEY`: private key dung de SSH vao EC2
- `EC2_PORT`: optional, mac dinh `22`
- `MYSQL_DATABASE`: ten database MySQL tren server
- `MYSQL_ROOT_PASSWORD`: mat khau root MySQL
- `GEMINI_API_KEY`: API key cho backend

Image duoc push len:

```bash
<dockerhub-username>/ltjava-backend:<git-sha-7>
<dockerhub-username>/ltjava-backend:latest
<dockerhub-username>/ltjava-frontend:<git-sha-7>
<dockerhub-username>/ltjava-frontend:latest
```

File compose deploy nam o `docker-compose.ec2.yml`. Workflow se copy file nay len EC2 thanh `docker-compose.yml`, tao `.env`, sau do chay:

```bash
docker compose pull
docker compose up -d --remove-orphans
```

Can chuan bi san tren EC2:

- Docker va Docker Compose plugin
- mo cong `80` tren Security Group
- thu muc deploy `/opt/ltjava`
- server duoc phep ket noi Docker Hub

## Postman API test

Workflow: `.github/workflows/postman-api-test.yml`

Workflow nay chay thu cong vi cac file Postman hien dang rong. Sau khi them collection va environment vao:

- `LTJava/postman/collections/backend-api.postman_collection.json`
- `LTJava/postman/environments/dev.postman_environment.json`
- `LTJava/postman/environments/staging.postman_environment.json`

Ban co the chay workflow tren GitHub Actions va tai report HTML/JUnit/JSON tu artifacts.
