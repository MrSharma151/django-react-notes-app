# ---------------------------------------------------------
# Base Python image (official). Python 3.9 is stable for Django.
# ---------------------------------------------------------
FROM python:3.9


# ---------------------------------------------------------
# Set working directory inside container.
# All commands will run from /app.
# ---------------------------------------------------------
WORKDIR /app


# ---------------------------------------------------------
# Install required system dependencies for mysqlclient
# mysqlclient needs:
#   - gcc for compilation
#   - default-libmysqlclient-dev for MySQL headers
#   - pkg-config for build configuration
#
# rm -rf /var/lib/apt/lists/* reduces image size
# ---------------------------------------------------------
RUN apt-get update \
    && apt-get install -y gcc default-libmysqlclient-dev pkg-config \
    && rm -rf /var/lib/apt/lists/*


# ---------------------------------------------------------
# Copy requirements first for Docker layer caching.
# If only code changes, this layer stays cached → faster builds.
# ---------------------------------------------------------
COPY requirements.txt .


# ---------------------------------------------------------
# Install Python dependencies from requirements.txt
# --no-cache-dir makes image smaller.
# ---------------------------------------------------------
RUN pip install --no-cache-dir -r requirements.txt


# ---------------------------------------------------------
# Copy the entire Django project into the image.
# After this step, /app contains manage.py, notesapp/, api/, etc.
# ---------------------------------------------------------
COPY . .


# ---------------------------------------------------------
# Expose port 8000 (Django/Gunicorn runs on this port)
# Nginx will connect to this upstream service.
# ---------------------------------------------------------
EXPOSE 8000


# ---------------------------------------------------------
# Start Django application using Gunicorn
# Gunicorn is recommended for production (faster & more stable)
# notesapp.wsgi → must match your project folder containing wsgi.py
#
# This command is overridden by docker-compose `command:` if defined.
# ---------------------------------------------------------
CMD ["gunicorn", "notesapp.wsgi:application", "--bind", "0.0.0.0:8000"]

