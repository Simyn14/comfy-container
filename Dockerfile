FROM docker.io/pytorch/pytorch:2.10.0-cuda12.8-cudnn9-runtime

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && \
    apt-get install -y git ffmpeg libgl1 libglib2.0-0 python3-pip && \
    rm -rf /var/lib/apt/lists/*
RUN git clone  --depth 1 https://github.com/Comfy-Org/ComfyUI.git .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir --prefer-binary -r requirements.txt
RUN mkdir -p /data/models /data/output /data/input /data/custom_nodes

EXPOSE 8188
ENTRYPOINT ["python", "main.py", \
            "--listen", "0.0.0.0", "--port", "8188", \
            "--models-directory", "/data/models", \
            "--output-directory", "/data/output", \
            "--input-directory", "/data/input"]
