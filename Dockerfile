# Use the official RunPod PyTorch image as the base.
# We will upgrade Torch inside this image to match your specific version.
FROM runpod/pytorch:2.4.0-py3.11-cuda12.4.1-devel-ubuntu22.04

# Set environment variables
ENV PYTHONUNBUFFERED=1

# Set the working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    wget \
    libgl1-mesa-glx \
    libglib2.0-0 \
    ninja-build \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Clone ComfyUI
RUN git clone https://github.com/comfyanonymous/ComfyUI.git

# --- UPGRADE TORCH TO SPECIFIC VERSION ---
# We install the exact version requested: 2.7.1+cu128
RUN pip install --upgrade pip wheel setuptools
RUN pip install torch==2.7.1+cu128 torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128

# --- INSTALL EXTRAS (SageAttention & Nunchaku) ---
# SageAttention (Compiles from source, may take time)
RUN pip install sageattention --no-build-isolation

# --- INSTALL CUSTOM NODES (Tavris1 / Pixaroma Pack) ---
WORKDIR /app/ComfyUI/custom_nodes

# Fix for potential git clone errors (timeouts/auth)
RUN git config --global http.postBuffer 524288000 && \
    git config --global http.sslVerify true

# 1. ComfyUI Manager
RUN git clone https://github.com/ltdrdata/ComfyUI-Manager.git

# 2. ComfyUI-Easy-Use
RUN git clone https://github.com/yolain/ComfyUI-Easy-Use.git

# 3. Comfyroll Studio
RUN git clone https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes.git

# 4. rgthree-comfy
RUN git clone https://github.com/rgthree/rgthree-comfy.git

# 5. ComfyUI-GGUF
RUN git clone https://github.com/City96/ComfyUI-GGUF.git

# 6. ComfyUI-Inpaint-CropAndStitch
RUN git clone https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch.git

# 7. ComfyUI-nunchaku
RUN git clone https://github.com/nunchaku-ai/ComfyUI-nunchaku.git


# --- INSTALL PYTHON DEPENDENCIES FOR NODES ---
WORKDIR /app/ComfyUI

# Install main requirements
RUN pip install --no-cache-dir -r requirements.txt

# Install requirements for all custom nodes
# We loop through them to ensure all dependencies are met
RUN for dir in custom_nodes/*; do \
    if [ -f "$dir/requirements.txt" ]; then \
        echo "Installing requirements for $dir..."; \
        pip install --no-cache-dir -r "$dir/requirements.txt"; \
    fi; \
done

# Copy the start script
COPY ../start_container.sh /start_container.sh
RUN chmod +x /start_container.sh

# Expose ports:
# 8188: ComfyUI
# 8888: JupyterLab
# 22: SSH
EXPOSE 8188 8888 22

# Set the command to run our start script
CMD ["/start_container.sh"]
