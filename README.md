# ComfyUI RunPod Template (Tavris/Pixaroma Edition)

This project contains the Docker configuration to build a custom RunPod template for ComfyUI. It is based on the popular "Tavris1/ComfyUI-Easy-Install" (Pixaroma Community Edition) pack, adapted for a cloud server environment.

## Features
- **Base:** RunPod PyTorch 2.8.0 (CUDA 12.8.1, Python 3.11)
- **ComfyUI:** Latest version pre-installed.
- **New High-Performance Extras:**
  - **SageAttention:** Extremely fast attention mechanism (v2.2.0).
  - **Nunchaku:** Efficient 4-bit inference engine for neural networks.
- **Pre-installed Nodes:**
  - ComfyUI Manager (for easy installation of other nodes)
  - ComfyUI-Easy-Use
  - Comfyroll Studio
  - rgthree-comfy
  - ComfyUI-GGUF
  - ComfyUI-Inpaint-CropAndStitch
  - ComfyUI-nunchaku
- **Tools:**
  - JupyterLab (Port 8888)
  - SSH (Port 22)
  - Auto-start script for seamless deployment.

## Build & Deploy Guide

### 1. Prerequisites
- Docker Desktop installed and running.
- A Docker Hub account.

### 2. Build the Image
Navigate to this directory in PowerShell/Terminal and run:
```bash
# Replace 'jubied1' with your Docker Hub username if different
docker build -t jubied1/comfyui-tavris:v1 .
```

### 3. Push to Docker Hub
Upload the image so RunPod can access it:
```bash
docker push jubied1/comfyui-tavris:v1
```

### 4. Configure RunPod
Create a "New Template" on RunPod with these settings:

- **Image Name:** `jubied1/comfyui-tavris:stable` (or :v1)
- **Container Disk:** `30 GB` (Minimum)
- **Volume Disk:** `50 GB` (Recommended for storing models)
- **Expose Ports:**
  - `8188` (ComfyUI)
  - `8888` (JupyterLab)
  - `22` (SSH)
- **Environment Variables (Optional):**
  - Key: `HF_HOME` | Value: `/workspace/huggingface` (To cache models on the permanent volume)

## Usage

1. **Deploy:** Launch a GPU Pod using your new template.
2. **Connect to ComfyUI:**
   - Click **Connect** -> **HTTP [8188]**.
3. **Connect to JupyterLab:**
   - Click **Connect** -> **HTTP [8888]**.
4. **Install More Nodes:**
   - Open ComfyUI Manager inside the UI to install "ControlNet Aux", "RMBG", or any other nodes that were skipped during the build to ensure stability.

## File Structure
- `Dockerfile`: The blueprint for the image.
- `start_container.sh`: Startup script that launches SSH, Jupyter, and ComfyUI.
