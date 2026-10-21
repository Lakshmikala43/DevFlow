# DevFlow Setup & Developer Guide

## Windows Local Setup

### 1. Prerequisites Check
Ensure the following tools are installed and available in your PowerShell / Command Prompt:
- **Java 17+**: Verify with `java -version`
- **Maven 3.8+**: Verify with `mvn -v`
- **Node.js 18+ & npm**: Verify with `node -v` and `npm -v`
- **Python 3.8+**: Verify with `python --version`

### 2. Running DevFlow Locally

#### Option A: Quick Full-Stack Dev Server
```powershell
# From the DevFlow root folder:
npm install
npm run dev
```

#### Option B: Dedicated Spring Boot Backend
```powershell
mvn clean package -DskipTests
mvn spring-boot:run
```
The Spring Boot backend will boot on `http://localhost:8080`.
The in-memory H2 console is available at `http://localhost:8080/h2-console` (JDBC URL: `jdbc:h2:mem:devflow_db`).

#### Option C: Docker Compose Full Stack
```powershell
docker-compose up -d
```

### 3. Measuring Production SLOC
```powershell
python scripts/measure_loc.py
```

### 4. Running Automated Tests
```powershell
# Backend unit & integration tests
mvn test

# Frontend test runner
npm test
```
