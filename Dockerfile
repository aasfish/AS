# Use Python 3.11 slim image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies and Python packages
RUN apt-get update && apt-get install -y \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir \
    flask \
    flask-login \
    flask-sqlalchemy \
    flask-talisman \
    flask-wtf \
    gunicorn \
    psycopg2-binary \
    sqlalchemy \
    werkzeug \
    matplotlib \
    pandas \
    reportlab \
    trafilatura \
    email-validator

# Copy application code
COPY . .

# Make scripts executable
RUN chmod +x init_admin.sh

# Create data directory
RUN mkdir -p /app/data && chmod 777 /app/data
RUN mkdir -p /app/certs && chmod 700 /app/certs

# Expose port
EXPOSE 5000

# Set environment variables
ENV FLASK_APP=app.py
ENV PYTHONUNBUFFERED=1

# Run gunicorn with SSL configuration
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "4", "--certfile", "/app/certs/server.crt", "--keyfile", "/app/certs/server.key", "--access-logfile", "-", "--error-logfile", "-", "--capture-output", "--log-level", "debug", "app:app"]