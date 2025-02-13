# === Frontend Stage ===
FROM node:18 AS frontend

WORKDIR /app

# Copy package files and install dependencies
COPY frontend/package.json frontend/package-lock.json ./
RUN npm install

# Copy the rest of the frontend files and build React
COPY frontend /app
RUN npm run build

# === Backend Stage ===
FROM python:3.10 AS backend

WORKDIR /app

COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY backend /app

# === Final Stage (Serve React from FastAPI) ===
FROM python:3.10

WORKDIR /app

COPY --from=backend /app /app

# Ensure frontend is built correctly
COPY --from=frontend /app/build /app/frontend/build

RUN pip install --no-cache-dir -r /app/requirements.txt

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
