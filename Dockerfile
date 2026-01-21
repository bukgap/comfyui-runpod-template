# Use the official RunPod PyTorch image as the base.
FROM runpod/pytorch:2.4.0-py3.11-cuda12.4.1-devel-ubuntu22.04

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV NUNCHAKU_SKIP_CUDA_BUILD=1 
# ^ (Optional optimization if Nunchaku supports it, otherwise ignored)

# Set the working directory
WORKDIR /app

# Install system dependencies & Tools
RUN apt-get update && apt-get install -y \
    git \
    wget \
    curl \
    libgl1-mesa-glx \
    libglib2.0-0 \
    ninja-build \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# --- INSTALL VS CODE SERVER ---
RUN curl -fsSL https://code-server.dev/install.sh | sh

# --- INSTALL FILEBROWSER ---
RUN curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash

# --- UPGRADE TORCH TO STABLE 2.6.0 ---
RUN pip install --upgrade pip wheel setuptools
RUN pip install torch==2.6.0+cu126 torchvision torchaudio --index-url https://download.pytorch.org/whl/cu126

# Clone ComfyUI
RUN git clone https://github.com/comfyanonymous/ComfyUI.git

# --- INSTALL EXTRAS ---
# SageAttention (Compiles from source)
RUN pip install sageattention --no-build-isolation

# --- INSTALL CUSTOM NODES (Clean List) ---
WORKDIR /app/ComfyUI/custom_nodes

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


# --- INSTALL PYTHON DEPENDENCIES FOR NODES ---
WORKDIR /app/ComfyUI

# Install main requirements
RUN pip install --no-cache-dir -r requirements.txt

# Install requirements for all custom nodes
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
# 3000: VS Code Server
# 4000: FileBrowser
# 22: SSH
EXPOSE 8188 8888 3000 4000 22

# Set the command to run our start script
CMD ["/start_container.sh"]
