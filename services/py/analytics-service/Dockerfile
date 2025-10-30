FROM python:3.11-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY main.py .

# Expose port
EXPOSE 3011

# Set environment variable
ENV PORT=3011

# Run the application
CMD ["python", "main.py"]






