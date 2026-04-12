# 🚀 Setup Nginx + HTTPS (Certbot) cho Docker App

Hướng dẫn này giúp bạn deploy ứng dụng Docker với **Nginx reverse proxy** và **HTTPS (Let's Encrypt)**.

---

## 🧱 Kiến trúc

```
User → HTTPS (443) → Nginx → Docker App (localhost:8080)
```

---

## 📦 Yêu cầu

- Ubuntu Server (EC2 hoặc VPS)
- Docker + Docker Compose
- Domain (ví dụ: `MIỀN`) đã trỏ về IP server
- Port mở:
  - 80 (HTTP)
  - 443 (HTTPS)

---

## 🔧 Bước 1: Cấu hình Docker

Sửa `docker-compose.yml` (frontend):

```yaml
ports:
  - "127.0.0.1:8080:80"
```

👉 Không dùng `80:80` để tránh conflict với Nginx

Chạy lại:

```bash
docker compose down
docker compose up -d
```

---

## 🌐 Bước 2: Cài Nginx

```bash
sudo apt update
sudo apt install nginx -y
```

---

## ⚙️ Bước 3: Cấu hình Nginx

Mở file config:

```bash
sudo nano /etc/nginx/sites-available/default
```

Thay toàn bộ nội dung:

```nginx
server {
    listen 80;
    server_name interuth.click;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Kiểm tra và reload:

```bash
sudo nginx -t
sudo systemctl restart nginx
```

---

## 🔐 Bước 4: Cài Certbot

```bash
sudo apt install certbot python3-certbot-nginx -y
```

---

## 🔑 Bước 5: Cấp HTTPS

```bash
sudo certbot --nginx -d MIỀN
```

### Khi được hỏi:

- Email → nhập email của bạn
- Terms → chọn `Y`
- Share email → `N`
- Redirect HTTP → chọn `2`

---

## 🎉 Kết quả

Truy cập:

```
MIỀN
```

✔ Có HTTPS 🔒
✔ Không còn “Not secure”
✔ Tự redirect từ HTTP → HTTPS

---

## 🔄 Gia hạn SSL (tự động)

Certbot tự setup cron job. Kiểm tra:

```bash
sudo certbot renew --dry-run
```

---

## 🛠️ Troubleshooting

### ❌ Lỗi Nginx default page

→ Kiểm tra `proxy_pass` đúng `127.0.0.1:8080`

---

### ❌ Port conflict

```bash
sudo lsof -i :80
```

→ đảm bảo Docker không chiếm port 80

---

### ❌ Certbot lỗi

```bash
sudo systemctl status nginx
```

→ đảm bảo Nginx đang chạy

---

## 📌 Ghi chú

- `init.sql` chỉ chạy khi MySQL init lần đầu
- Không cần mount lại nếu DB đã tồn tại
- Nên dùng instance ≥ 2GB RAM cho production

---

## 👨‍💻 Tác giả

Setup bởi bạn 😎
