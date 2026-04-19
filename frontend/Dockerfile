FROM mcr.microsoft.com/playwright:v1.59.1-jammy

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

RUN npm run build

EXPOSE 4173

CMD ["sh", "-lc", "npm run preview -- --host 0.0.0.0 --port 4173"]
