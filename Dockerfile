# Multi-stage Dockerfile for DevFlow Enterprise Delivery Platform
FROM maven:3.9.6-eclipse-temurin-17 AS backend-build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B || true
COPY backend ./backend
COPY src ./src
RUN mvn clean package -DskipTests || true

FROM node:20-alpine AS frontend-build
WORKDIR /app
COPY package*.json ./
RUN npm ci --legacy-peer-deps || npm install --legacy-peer-deps
COPY frontend ./frontend
COPY public ./public
COPY src ./src
COPY index.html vite.config.ts tsconfig*.json ./
RUN npm run build || true

FROM eclipse-temurin:17-jre-jammy
WORKDIR /opt/devflow
EXPOSE 8080 3000

ENV SPRING_PROFILES_ACTIVE=prod \
    SERVER_PORT=8080 \
    PORT=3000

COPY --from=backend-build /app/target/*.jar /opt/devflow/devflow.jar
COPY --from=frontend-build /app/dist /opt/devflow/static

ENTRYPOINT ["java", "-jar", "/opt/devflow/devflow.jar"]
