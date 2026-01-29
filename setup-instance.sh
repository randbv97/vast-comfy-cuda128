#!/bin/bash

# setup-instance.sh
# Shell script version of the ComfyUI Dockerfile for running within a Vast.ai instance
# Base image expected: vastai/comfy:cuda-12.8-auto

set -e

echo "Starting setup for ComfyUI on CUDA 12.8 base image..."

# --- 1. Update ComfyUI core source ---
echo "Updating ComfyUI core source..."
cd /workspace/ComfyUI

# Ensure we are on master and get latest
git checkout master || git checkout -b master
git pull origin master
git submodule update --init --recursive

# --- 2. Re-install/Verify core dependencies ---
echo "Verifying core dependencies..."
/venv/main/bin/pip install --upgrade pip
/venv/main/bin/pip install -r requirements.txt

# --- 3. Install/Update Custom Nodes ---
echo "Installing custom nodes..."
mkdir -p /workspace/ComfyUI/custom_nodes/
cd /workspace/ComfyUI/custom_nodes/

# Helper function to clone or update custom nodes
clone_or_update() {
    local url=$1
    local target_dir=${2:-$(basename "$url" .git)}
    
    if [ -d "$target_dir" ]; then
        echo "Updating $target_dir..."
        cd "$target_dir" && git pull && cd ..
    else
        echo "Cloning $target_dir..."
        git clone --depth 1 --recursive "$url" "$target_dir"
    fi
}

# Group 1: Performance and Core Utilities
clone_or_update https://github.com/chengzeyi/Comfy-WaveSpeed
clone_or_update https://github.com/city96/ComfyUI-GGUF
clone_or_update https://github.com/crystian/ComfyUI-Crystools
clone_or_update https://github.com/evanspearman/ComfyMath
clone_or_update https://github.com/Fannovel16/ComfyUI-Frame-Interpolation

# Group 2: UI and Workflow management
clone_or_update https://github.com/giriss/comfy-image-saver
clone_or_update https://github.com/ka-puna/comfyui-yanc
clone_or_update https://github.com/kijai/ComfyUI-KJNodes comfyui-kjnodes
clone_or_update https://github.com/kijai/ComfyUI-WanVideoWrapper
clone_or_update https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite comfyui-videohelpersuite

# Group 3: Integration and Logic
clone_or_update https://github.com/liusida/ComfyUI-Login login
clone_or_update https://github.com/marhensa/sdxl-recommended-res-calc
clone_or_update https://github.com/mcmonkeyprojects/sd-dynamic-thresholding
clone_or_update https://github.com/rcsaquino/comfyui-custom-nodes
clone_or_update https://github.com/rgthree/rgthree-comfy

# Group 4: Advanced Generation and Specialized Nodes
clone_or_update https://github.com/ShmuelRonen/ComfyUI-FreeMemory
clone_or_update https://github.com/ssitu/ComfyUI_UltimateSDUpscale
clone_or_update https://github.com/Stability-AI/stability-ComfyUI-nodes
clone_or_update https://github.com/filliptm/ComfyUI_Fill-Nodes.git
clone_or_update https://github.com/Lightricks/ComfyUI-LTXVideo.git
clone_or_update https://github.com/WASasquatch/was-node-suite-comfyui

# --- 4. Install all custom node dependencies ---
echo "Installing custom node dependencies..."
# We use a loop similar to the Dockerfile to find all requirements.txt
for req in $(find . -maxdepth 2 -name "requirements.txt"); do
    echo "Installing dependencies from: $req"
    /venv/main/bin/pip install -r "$req" || echo "Warning: Failed to install some dependencies in $req, continuing..."
done

# --- 5. Model directories and download scripts ---
echo "Setting up model directories..."
cd /workspace/ComfyUI
mkdir -p models/{unet,loras,text_encoders,vae,diffusion_models,clip,checkpoints}

# If the dl-*.sh scripts were copied to the instance, make them executable
# This assumes the user scp'd them to the ComfyUI dir or they are in the current working dir
chmod +x dl-*.sh 2>/dev/null || true

echo "Setup complete! You can now start ComfyUI using the default entrypoint or by running:"
echo "   /venv/main/bin/python /workspace/ComfyUI/main.py --listen"
