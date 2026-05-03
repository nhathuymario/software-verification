# Tổng hợp lỗi đã gặp khi deploy Interuth/NovaGear lên EC2

## 1. Local chạy được nhưng domain production lỗi

**Hiện tượng**

- Local `npm run dev` chạy bình thường.
- Production qua domain bị `403`, `401`, `502`.

**Nguyên nhân**

Local và production khác nhau:

```txt
Local: Browser -> Vite dev server -> backend local
Production: Browser -> Domain -> Nginx -> Docker frontend/backend
```

Ngoài ra browser local có thể còn token cũ trong `sessionStorage`, còn DB trên EC2 có thể khác DB local.

**Cách xử lý**

Trên browser, xóa token cũ:

```js
sessionStorage.clear()
localStorage.clear()
location.reload()
```

Production nên test bằng domain chính:

```txt
https://www.interuth.click/login
```

---

## 2. Vite hiện nhiều Network khi chạy `npm run dev`

**Hiện tượng**

```txt
Local:   http://localhost:5173/
Network: http://26.x.x.x:5173/
Network: http://192.168.x.x:5173/
Network: http://172.x.x.x:5173/
```

**Nguyên nhân**

Máy Windows có nhiều network interface: Wi-Fi, VPN, Docker, WSL, VMware/VirtualBox.

**Kết luận**

Không phải lỗi. Chỉ cần mở:

```txt
http://localhost:5173/
```

---

## 3. `docker compose down` báo không thấy file

**Hiện tượng**

```bash
docker compose down
no configuration file provided: not found
```

**Nguyên nhân**

Đang đứng sai thư mục, không có file `docker-compose.yml`.

**Cách xử lý**

```bash
cd ~/ltjava
sudo docker compose down
```

Tìm file compose:

```bash
sudo find / -name "docker-compose.yml" -o -name "compose.yml" 2>/dev/null
```

---

## 4. Docker Compose báo thiếu biến môi trường

**Hiện tượng**

```txt
WARN The "BACKEND_IMAGE" variable is not set
WARN The "FRONTEND_IMAGE" variable is not set
WARN The "IMAGE_TAG" variable is not set
```

**Nguyên nhân**

Docker Compose không tự đọc `.env.ec2`. Nó chỉ tự đọc `.env`.

**Cách xử lý**

Khi dùng `.env.ec2`, phải chạy:

```bash
sudo docker compose --env-file .env.ec2 pull
sudo docker compose --env-file .env.ec2 up -d --force-recreate --remove-orphans
```

---

## 5. GitHub Actions deploy xong nhưng EC2 vẫn chạy image cũ

**Hiện tượng**

`.env.ec2` đã có tag mới:

```env
IMAGE_TAG=c462f1d
```

Nhưng `docker ps` vẫn hiện tag cũ:

```txt
huyne1501/frontend-service:64466aa
huyne1501/backend-service:64466aa
```

**Nguyên nhân**

Workflow deploy thiếu `--env-file .env.ec2`, nên Compose không lấy tag mới.

**Cách sửa trong GitHub Actions**

```bash
sudo docker compose --env-file .env.ec2 config | grep image
sudo docker compose --env-file .env.ec2 pull
sudo docker compose --env-file .env.ec2 up -d --pull always --force-recreate --remove-orphans
sudo docker ps
sudo docker image prune -f
```

---

## 6. Lỗi `502 Bad Gateway` do Docker port mapping sai

**Hiện tượng**

Web báo:

```txt
502 Bad Gateway
```

**Nguyên nhân**

Nginx gọi:

```txt
127.0.0.1:8080 -> frontend
127.0.0.1:8081 -> backend
```

Nhưng Docker map sai port.

Frontend container đang chạy bằng:

```txt
npm run preview
```

nên app nghe port:

```txt
4173/tcp
```

nhưng compose từng map sai:

```yaml
ports:
  - "127.0.0.1:8080:80"
```

Backend cũng từng thiếu map ra host, chỉ hiện:

```txt
8081/tcp
```

**Cấu hình đúng**

Trong `docker-compose.ec2.yml` và `docker-compose.yml` trên EC2:

```yaml
backend:
  ports:
    - "127.0.0.1:8081:8081"

frontend:
  ports:
    - "127.0.0.1:8080:4173"
```

**Kết quả đúng khi `docker ps`**

```txt
ltjava-frontend   127.0.0.1:8080->4173/tcp
ltjava-backend    127.0.0.1:8081->8081/tcp
```

---

## 7. Lỗi `interuth.click` và `www.interuth.click` trỏ khác nhau

**Hiện tượng**

```bash
curl -s ifconfig.me
nslookup interuth.click
nslookup www.interuth.click
```

Kết quả từng thấy:

```txt
EC2 current IP:       44.202.144.60
interuth.click:       103.18.6.109
www.interuth.click:   44.202.144.60
```

**Nguyên nhân**

- `www.interuth.click` trỏ đúng về DuckDNS/EC2.
- `interuth.click` không có `www` đi qua redirect/server của TenTen.

**Cách xử lý hiện tại**

Dùng domain chính:

```txt
https://www.interuth.click/login
```

Trong FE để:

```env
VITE_API_BASE_URL=/api
```

Không hardcode:

```env
VITE_API_BASE_URL=https://interuth.click/api
```

---

## 8. Lỗi `403` qua HTTPS do Nginx block 443 proxy sai

**Hiện tượng**

Backend direct trả:

```txt
HTTP/1.1 401
Username hoặc password không đúng
```

Nhưng qua HTTPS trả:

```txt
HTTP/2 403
```

**Nguyên nhân**

Nginx block HTTPS `443` đang proxy sai:

```nginx
location /api/ {
    proxy_pass http://127.0.0.1:8081/;
}
```

Với cấu hình này:

```txt
/api/auth/login
```

bị chuyển thành:

```txt
/auth/login
```

nên backend trả `403`.

**Cách tìm file Nginx thật đang chạy**

```bash
sudo grep -R "proxy_pass http://127.0.0.1:8081/" -n /etc/nginx
```

Đã phát hiện file thật:

```txt
/etc/nginx/sites-enabled/interuth.click
/etc/nginx/sites-available/interuth.click
```

**Cách sửa**

Mở file:

```bash
sudo nano /etc/nginx/sites-available/interuth.click
```

Đổi:

```nginx
location /api/ {
    proxy_pass http://127.0.0.1:8081/;
}
```

thành:

```nginx
location /api/ {
    proxy_pass http://127.0.0.1:8081/api/;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```

Reload Nginx:

```bash
sudo nginx -t
sudo systemctl reload nginx
```

Test lại:

```bash
curl -k -i --resolve www.interuth.click:443:127.0.0.1 \
  -X POST https://www.interuth.click/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"0000000000000","password":"123456"}'
```

Kết quả đúng sau khi fix:

```txt
HTTP/2 401
Username hoặc password không đúng
```

---

## 9. Lỗi `401 Username hoặc password không đúng`

**Hiện tượng**

```txt
HTTP/2 401
Username hoặc password không đúng
```

**Ý nghĩa**

Đường request đã đúng:

```txt
Browser -> Nginx HTTPS -> Backend /api/auth/login
```

Lỗi còn lại là tài khoản/mật khẩu trong MySQL EC2 không khớp.

**Nguyên nhân có thể**

- DB EC2 khác DB local.
- Chưa seed user admin.
- User `0000000000000` không tồn tại.
- Password hash trong DB không khớp.

**Cách kiểm tra DB**

```bash
sudo docker exec -it ltjava-mysql mysql -uroot -p
```

Nhập password:

```txt
123456
```

Sau đó:

```sql
USE LTJavaTest;
SHOW TABLES;
```

Nếu bảng là `users`:

```sql
SELECT id, username, email, role, enabled FROM users LIMIT 20;
```

Nếu không có user cần login thì cần seed/import lại data hoặc tạo user admin mới.

---

## 10. FE gửi `Authorization: ''` khi login

**Code cũ**

```ts
api.post<LoginResponse>('/auth/login', { username, password }, { headers: { Authorization: '' } })
```

**Nguyên nhân lỗi**

Không nên gửi header `Authorization` rỗng khi login. JWT filter có thể hiểu sai và trả `403`.

**Cách sửa**

```ts
const { data } = await api.post<LoginResponse>('/auth/login', {
    username,
    password,
})
```

Nên xóa token cũ trước khi login:

```ts
sessionStorage.removeItem('token')
sessionStorage.removeItem('accessToken')
sessionStorage.removeItem('jwt')
```

---

## 11. ESLint `Unexpected any`

**Hiện tượng**

```txt
ESLint: Unexpected any. Specify a different type.
@typescript-eslint/no-explicit-any
```

Ví dụ:

```ts
(data as any).token
(api as any).defaults
```

**Ảnh hưởng**

- Dev có thể vẫn chạy.
- Nếu CI/Docker build có lint strict thì có thể fail.

**Cách sửa**

Khai báo type rõ:

```ts
export type LoginResponse = {
    token?: string
    accessToken?: string
    access_token?: string
    username?: string
    roles?: string[]
}
```

Dùng:

```ts
const token =
    data.token ||
    data.accessToken ||
    data.access_token ||
    ''
```

---

## 12. AWS Security Group không phải nguyên nhân

**Kết luận**

Security Group đã đúng vì có:

```txt
80   HTTP
443  HTTPS
22   SSH
```

Không cần mở thêm:

```txt
8080
8081
3306
6379
```

Vì các port này chỉ dùng nội bộ giữa Nginx và Docker trên EC2:

```txt
127.0.0.1:8080
127.0.0.1:8081
```

Nếu Security Group sai thường là timeout/không kết nối được, không phải `401` hoặc `403`.

---

## 13. Cấu hình Nginx cần nhớ

```nginx
location /api/ {
    proxy_pass http://127.0.0.1:8081/api/;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}

location /uploads/ {
    proxy_pass http://127.0.0.1:8081/uploads/;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
}

location / {
    proxy_pass http://127.0.0.1:8080;
    proxy_http_version 1.1;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
}
```

Sau khi sửa:

```bash
sudo nginx -t
sudo systemctl reload nginx
```

---

## 14. Bộ lệnh debug nhanh

Xem container:

```bash
sudo docker ps
```

Xem log:

```bash
sudo docker logs -f ltjava-backend
sudo docker logs -f ltjava-frontend
```

Kiểm tra image Compose đang dùng:

```bash
sudo docker compose --env-file .env.ec2 config | grep image
```

Pull và recreate:

```bash
cd ~/ltjava
sudo docker compose --env-file .env.ec2 pull
sudo docker compose --env-file .env.ec2 up -d --pull always --force-recreate --remove-orphans
```

Test frontend:

```bash
curl -I http://127.0.0.1:8080/login
```

Test backend direct:

```bash
curl -i -X POST http://127.0.0.1:8081/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"0000000000000","password":"123456"}'
```

Test HTTPS qua Nginx local:

```bash
curl -k -i --resolve www.interuth.click:443:127.0.0.1 \
  -X POST https://www.interuth.click/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"0000000000000","password":"123456"}'
```

Xem Nginx proxy:

```bash
sudo nginx -T | grep -nE "listen|server_name|location|proxy_pass|ssl_certificate"
```

Tìm proxy sai:

```bash
sudo grep -R "proxy_pass http://127.0.0.1:8081/" -n /etc/nginx
```

---

## 15. Trạng thái cuối cùng

Đã fix được:

```txt
Docker port frontend/backend: OK
Nginx HTTPS proxy /api: OK
Domain www.interuth.click về EC2: OK
API qua HTTPS không còn 403 do Nginx: OK
```

Kết quả cuối sau fix:

```txt
HTTP/2 401
Username hoặc password không đúng
```

Điều này nghĩa là hệ thống deploy/proxy đã đúng. Việc còn lại là xử lý dữ liệu user trong MySQL EC2.
