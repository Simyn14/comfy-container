FROM pytorch/pytorch:2.10.0-cuda13.0-cudnn9-runtime

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# System updates
RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    rm -rf /var/lib/apt/lists/*

# Setup ComfyUI
WORKDIR /app
RUN git clone --depth 1 https://github.com/Comfy-Org/ComfyUI.git .
RUN pip install --break-system-packages --no-cache-dir --upgrade pip && \
    pip install --break-system-packages --no-cache-dir -r requirements.txt
RUN mkdir -p /data/{models,output,input,custom_nodes}

# Setup Custom Nodes
WORKDIR /data/custom_nodes
## Setup ComfyUI-Manager
RUN git clone --depth 1 https://github.com/Comfy-Org/ComfyUI-Manager.git
RUN pip install --break-system-packages --no-cache-dir -r ComfyUI-Manager/requirements.txt
## Setup ComfyUI-Lora-Manager
RUN git clone --depth 1 https://github.com/willmiao/ComfyUI-Lora-Manager
RUN pip install --break-system-packages --no-cache-dir -r ComfyUI-Lora-Manager/requirements.txt
## Setup Crystools
RUN git clone --depth 1 https://github.com/crystian/ComfyUI-Crystools
RUN pip install --break-system-packages --no-cache-dir -r ComfyUI-Crystools/requirements.txt

# Run app
WORKDIR /app
EXPOSE 8188
CMD ["python", "main.py", \
     "--listen", "0.0.0.0", "--port", "8188", \
     "--base-directory", "/data"]
