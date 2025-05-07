# Python sandbox environment
FROM alpine:latest

# Install common tools and Python
RUN apk update && \
    apk add --no-cache \
    bash \
    curl \
    wget \
    git \
    ca-certificates \
    tzdata \
    python3 \
    python3-dev \
    py3-pip \
    gcc \
    musl-dev

# Set Python 3 as the default python version
RUN ln -sf /usr/bin/python3 /usr/bin/python

# Install uv in a way that complies with PEP 668
# Method 1: Create a temporary virtual environment
RUN python -m venv /tmp/venv && \
    . /tmp/venv/bin/activate && \
    pip install uv && \
    cp /tmp/venv/bin/uv /usr/local/bin/ && \
    rm -rf /tmp/venv

# Verify uv installation
RUN which uv && uv --version

# Create directory for shared tasks with proper permissions
RUN mkdir -p /tasks && chmod 777 /tasks

# Set working directory
WORKDIR /tasks

# Keep container running
CMD ["tail", "-f", "/dev/null"]