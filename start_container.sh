#!/bin/bash

# 1. Start SSH Service
# RunPod base images typically have SSH configured, but we ensure the service is running.
service ssh start

# 2. Start JupyterLab (Background)
# We run this in the background so it doesn't block the script.
# --allow-root: Required to run as root.
# --NotebookApp.token='': Disables token authentication (be careful with this in production, but standard for RunPod dev mode).
jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token='' --NotebookApp.password='' &
echo "JupyterLab started on port 8888"

# 3. Start ComfyUI (Foreground)
# We run this in the foreground to keep the container active.
# --listen 0.0.0.0: Required to access the UI from your browser via RunPod proxy.
echo "Starting ComfyUI..."
cd /app/ComfyUI
python main.py --listen 0.0.0.0 --port 8188
