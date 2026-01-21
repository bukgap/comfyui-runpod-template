# ComfyUI RunPod Template (Tavris/Pixaroma Edition)

This project contains the Docker configuration to build a custom RunPod template for ComfyUI. It is based on the popular "Tavris1/ComfyUI-Easy-Install" (Pixaroma Community Edition) pack, adapted for a cloud server environment.

## Features
- **Base:** RunPod PyTorch 2.4 (Upgraded to **PyTorch 2.6.0 Stable**)
- **Persistence:** ComfyUI is automatically moved to `/workspace/ComfyUI` so your changes are saved.
- **Development Tools:**
  - **VS Code Server:** Full IDE in browser (Port 3000)
  - **FileBrowser:** Easy file management (Port 4000)
  - **JupyterLab:** Fixed & Ready (Port 8888)
- **High-Performance Extras:**
  - **SageAttention:** Extremely fast attention mechanism.
- **Pre-installed Nodes:**
  - ComfyUI Manager
  - ComfyUI-Easy-Use
  - Comfyroll Studio
  - rgthree-comfy
  - ComfyUI-GGUF
  - ComfyUI-Inpaint-CropAndStitch

## Configure RunPod
Create a "New Template" on RunPod with these settings:

- **Image Name:** `jemon97/comfyui-tavris:stable`
- **Container Disk:** `30 GB` (Minimum)
- **Volume Disk:** `50 GB` (Recommended)
- **Volume Mount Path:** `/workspace`
- **Expose Ports:**
  - `8188` (ComfyUI)
  - `8888` (JupyterLab)
  - `3000` (VS Code Server)
  - `4000` (FileBrowser)
  - `22` (SSH)

## Build & Deploy Guide

### 1. Prerequisites
- Docker Desktop installed and running.
- A Docker Hub account.

### 2. Build the Image
Navigate to this directory in PowerShell/Terminal and run:
```bash
# Replace 'jemon97' with your Docker Hub username if different
docker build -t jemon97/comfyui-tavris:v1 .
```

### 3. Push to Docker Hub
Upload the image so RunPod can access it:
```bash
docker push jemon97/comfyui-tavris:v1
```

### 4. Configure RunPod
Create a "New Template" on RunPod with these settings:

- **Image Name:** `jemon97/comfyui-tavris:stable` (or :v1)
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
