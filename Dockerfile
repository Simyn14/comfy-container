FROM pytorch/pytorch:2.10.0-cuda12.8-cudnn9-runtime

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    rm -rf /var/lib/apt/lists/*
RUN git clone --depth 1 https://github.com/Comfy-Org/ComfyUI.git .
RUN pip install --break-system-packages --no-cache-dir --upgrade pip && \
    pip install --break-system-packages --no-cache-dir -r requirements.txt
RUN mkdir -p /data/{models,output,input,custom_nodes}

EXPOSE 8188
ENTRYPOINT ["python", "main.py", \
            "--listen", "0.0.0.0", "--port", "8188", \
            "--base-directory", "/data"]
