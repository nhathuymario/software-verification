#!/bin/bash

echo "🚀 Start Docker..."
docker-compose up -d --build

echo "⏳ Waiting for services (10s)..."
sleep 10

echo "🔍 Running SonarQube scan..."

cd LTJava || exit

mvn clean verify sonar:sonar -DskipTests \
  -Dsonar.projectKey=LTJava \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.token=sqp_f6ed37c6304b29b6b7c7957b77de9b8164696737







echo "✅ Done!"