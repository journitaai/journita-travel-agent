# Render-optimized Dockerfile for Python 3.11
FROM python:3.11-slim

# Set environment variables for Python and Render
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PORT=10000

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Set working directory
WORKDIR /app

# Install Poetry
RUN pip install poetry==1.7.1

# Copy dependency files first (better caching)
COPY pyproject.toml poetry.lock* ./

# Configure poetry for container environment
RUN poetry config virtualenvs.create false \
    && poetry config virtualenvs.in-project false

# Install dependencies (production only for Render free tier)
RUN poetry install --only=main --no-interaction --no-ansi

# Copy application code
COPY agents/ ./agents/
COPY production_server.py ./
COPY langgraph.json ./
COPY __init__.py ./

# Create a non-root user (Render best practice)
RUN useradd --create-home --shell /bin/bash app \
    && chown -R app:app /app

# Switch to non-root user
USER app

# Render uses PORT environment variable
EXPOSE $PORT

# Command for Render deployment
CMD uvicorn production_server:app --host 0.0.0.0 --port $PORT
