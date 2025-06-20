FROM python:3.13-alpine

ENV CITUS_HOST=master
ENV POSTGRES_DB=postgres
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres
ENV LABEL_SELECTOR="app=citus,role=worker"
ENV POD_NAMESPACE=default
ENV SCAN_INTERVAL_SECONDS=20


# Set working directory
WORKDIR /app

# Install required Python libraries
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY citus-k8s-manager.py .

# Create directory for healthcheck
RUN mkdir -p /healthcheck

# Set environment variables for healthcheck
ENV PYTHONUNBUFFERED=1

# Set entrypoint
ENTRYPOINT ["python", "citus-k8s-manager.py"]
