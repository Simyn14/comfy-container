FROM python:3.13-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    rm -rf /var/lib/apt/lists/*
RUN git clone --depth 1 https://github.com/Comfy-Org/ComfyUI.git .
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir --prefer-binary -r requirements.txt
RUN mkdir -p /data/models /data/output /data/input /data/custom_nodes

EXPOSE 8188
ENTRYPOINT ["python", "main.py", \
            "--listen", "0.0.0.0", "--port", "8188", \
            "--models-directory", "/data/models", \
            "--output-directory", "/data/output", \
            "--input-directory", "/data/input"]
