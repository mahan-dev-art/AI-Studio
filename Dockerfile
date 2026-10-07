```dockerfile
FROM python:3.11-slim

# Prevent Python from writing .pyc files and buffer logs
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Application directory
WORKDIR /app

# System dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       curl \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies first for better Docker caching
COPY requirements.txt .

RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir gunicorn

# Copy application
COPY . .

# Production environment
ENV PORT=5000

# Container port
EXPOSE 5000

# Run Flask with Gunicorn
CMD ["sh", "-c", "gunicorn --bind 0.0.0.0:${PORT:-5000} --workers 2 --threads 4 --timeout 120 app:app"]
```
