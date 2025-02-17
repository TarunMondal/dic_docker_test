# === Frontend Build Stage ===
FROM node:18-alpine AS frontend-builder

WORKDIR /frontend
COPY frontend/package*.json ./
RUN npm install

COPY frontend/ ./
RUN npm run build

# === Backend Build Stage ===
FROM python:3.10-slim AS backend-builder

WORKDIR /backend
COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY backend/ .

# === Frontend Runtime Stage ===
FROM node:18-alpine AS frontend

WORKDIR /app
COPY frontend/package*.json ./
RUN npm install

COPY frontend/ ./
ENV PORT=8001
ENV HOST=0.0.0.0
ENV WDS_SOCKET_PORT=8001

EXPOSE 8001
CMD ["npm", "start"]

# === Backend Runtime Stage ===
FROM python:3.10-slim AS backend

WORKDIR /app

# Install dependencies in the final stage
COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY backend/ .

EXPOSE 8000
# Specify the full path to uvicorn
CMD ["python", "-m", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]