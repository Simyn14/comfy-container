FROM pytorch/pytorch:2.10.0-cuda13.0-cudnn9-runtime

ENV PATH="/venv/bin:$PATH"
ENV PYTHONUNBUFFERED=1
ENV DEBIAN_FRONTEND=noninteractive

# System updates and setup environment
RUN apt-get update && apt-get install -y --no-install-recommends git python3-venv && \
    mkdir -p /app /data/input /data/output /data/models /data/custom_nodes && \
    python3 -m venv /venv && pip install --no-cache-dir --upgrade pip && \
    rm -rf /var/lib/apt/lists/*

# Setup ComfyUI Manager
WORKDIR /data/custom_nodes
RUN git clone --depth 1 https://github.com/Comfy-Org/ComfyUI-Manager.git && \
    pip install --no-cache-dir -r ComfyUI-Manager/requirements.txt

# Setup ComfyUI
WORKDIR /app
RUN git clone --depth 1 https://github.com/Comfy-Org/ComfyUI.git . && \
    pip install --no-cache-dir -r requirements.txt

# Run app
EXPOSE 8188
CMD ["python", "main.py", \
     "--listen", "0.0.0.0", "--port", "8188", \
     "--base-directory", "/data"]
