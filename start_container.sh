#!/bin/bash

# --- 1. SETUP PERSISTENT WORKSPACE ---
echo "Checking workspace..."

# Define paths
WORKSPACE_DIR="/workspace"
COMFY_APP_DIR="/app/ComfyUI"
COMFY_WORK_DIR="$WORKSPACE_DIR/ComfyUI"

# If ComfyUI is not in the persistent volume, move it there
if [ ! -d "$COMFY_WORK_DIR" ]; then
    echo "First run detected. Moving ComfyUI to persistent volume..."
    mv "$COMFY_APP_DIR" "$WORKSPACE_DIR/"
else
    echo "Persistent ComfyUI found. Linking..."
    rm -rf "$COMFY_APP_DIR" # Remove the app copy to save space/confusion
fi

# Create a symlink so /app/ComfyUI always points to the workspace version
ln -s "$COMFY_WORK_DIR" "$COMFY_APP_DIR"

# Ensure other directories exist
mkdir -p "$WORKSPACE_DIR/logs"

# --- 2. START SERVICES ---

# CRITICAL: CD to a safe directory to avoid "getcwd() failed" errors if the original CWD was moved
cd "$WORKSPACE_DIR"

# A. SSH
service ssh start

# B. JupyterLab
echo "Starting JupyterLab..."
jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token='' --NotebookApp.password='' --ServerApp.allow_origin='*' --ServerApp.allow_remote_access=True --ServerApp.disable_check_xsrf=True > "$WORKSPACE_DIR/logs/jupyter.log" 2>&1 &

# C. VS Code Server (Port 3000)
echo "Starting VS Code Server..."
mkdir -p "$WORKSPACE_DIR/.vscode/extensions"
code-server --bind-addr 0.0.0.0:3000 --auth none --user-data-dir "$WORKSPACE_DIR/.vscode" --extensions-dir "$WORKSPACE_DIR/.vscode/extensions" "$WORKSPACE_DIR" > "$WORKSPACE_DIR/logs/code-server.log" 2>&1 &



# E. ComfyUI (Port 8188)
echo "Starting ComfyUI..."
cd "$COMFY_WORK_DIR"
python main.py --listen 0.0.0.0 --port 8188