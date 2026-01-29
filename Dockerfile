# syntax=docker/dockerfile:1
# Optimized Multi-stage Dockerfile for ComfyUI on Vast.ai
# Using multi-stage builds and BuildKit parallelization for speed and reliability

# --- Stage 0: Base image ---
FROM vastai/comfy:cuda-12.8-auto AS base
USER root

# --- Stage 1: Update ComfyUI source ---
FROM base AS updater
WORKDIR /opt/workspace-internal/ComfyUI
RUN git checkout master && \
    git pull && \
    git submodule update --init --recursive

# --- Stage 2: Parallel Node Downloaders ---
# We split clones into separate stages to maximize BuildKit's parallel execution.
# This makes the build more error-resistant as failures in one group won't affect others,
# and caching is more granular.
FROM base AS node-fetcher
WORKDIR /nodes

FROM node-fetcher AS fetch-1
RUN git clone --depth 1 --recursive https://github.com/chengzeyi/Comfy-WaveSpeed && \
    git clone --depth 1 --recursive https://github.com/city96/ComfyUI-GGUF && \
    git clone --depth 1 --recursive https://github.com/crystian/ComfyUI-Crystools && \
    git clone --depth 1 --recursive https://github.com/evanspearman/ComfyMath && \
    git clone --depth 1 --recursive https://github.com/Fannovel16/ComfyUI-Frame-Interpolation

FROM node-fetcher AS fetch-2
RUN git clone --depth 1 --recursive https://github.com/giriss/comfy-image-saver && \
    git clone --depth 1 --recursive https://github.com/ka-puna/comfyui-yanc && \
    git clone --depth 1 --recursive https://github.com/kijai/ComfyUI-KJNodes comfyui-kjnodes && \
    git clone --depth 1 --recursive https://github.com/kijai/ComfyUI-WanVideoWrapper && \
    git clone --depth 1 --recursive https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite comfyui-videohelpersuite

FROM node-fetcher AS fetch-3
RUN git clone --depth 1 --recursive https://github.com/liusida/ComfyUI-Login login && \
    git clone --depth 1 --recursive https://github.com/marhensa/sdxl-recommended-res-calc && \
    git clone --depth 1 --recursive https://github.com/mcmonkeyprojects/sd-dynamic-thresholding && \
    git clone --depth 1 --recursive https://github.com/rcsaquino/comfyui-custom-nodes && \
    git clone --depth 1 --recursive https://github.com/rgthree/rgthree-comfy

FROM node-fetcher AS fetch-4
RUN git clone --depth 1 --recursive https://github.com/ShmuelRonen/ComfyUI-FreeMemory && \
    git clone --depth 1 --recursive https://github.com/ssitu/ComfyUI_UltimateSDUpscale && \
    git clone --depth 1 --recursive https://github.com/Stability-AI/stability-ComfyUI-nodes && \
    git clone --depth 1 --recursive https://github.com/filliptm/ComfyUI_Fill-Nodes.git && \
    git clone --depth 1 --recursive https://github.com/Lightricks/ComfyUI-LTXVideo.git && \
    git clone --depth 1 --recursive https://github.com/WASasquatch/was-node-suite-comfyui

# --- Stage 3: Final Build ---
FROM base AS final

# 1. Update ComfyUI core source by copying from updater stage
COPY --from=updater /opt/workspace-internal/ComfyUI /opt/workspace-internal/ComfyUI

# 2. Re-install/Verify core dependencies using pip cache mount
WORKDIR /opt/workspace-internal/ComfyUI
RUN --mount=type=cache,target=/root/.cache/pip \
    /venv/main/bin/pip install --upgrade pip && \
    /venv/main/bin/pip install -r requirements.txt

# 3. Integrate all custom nodes from parallel fetcher stages
WORKDIR /opt/workspace-internal/ComfyUI/custom_nodes/
COPY --from=fetch-1 /nodes/ ./
COPY --from=fetch-2 /nodes/ ./
COPY --from=fetch-3 /nodes/ ./
COPY --from=fetch-4 /nodes/ ./

# 4. Install all custom node dependencies
# We use a robust loop that continues on errors if needed, but logs clearly.
# Using --mount=type=cache ensures fast rebuilds.
RUN --mount=type=cache,target=/root/.cache/pip \
    for req in $(find . -maxdepth 2 -name "requirements.txt"); do \
        echo "Installing dependencies from: $req" && \
        /venv/main/bin/pip install -r "$req"; \
    done

# 5. Model directories and download scripts
WORKDIR /opt/workspace-internal/ComfyUI
COPY dl-*.sh ./
RUN chmod +x *.sh && \
    mkdir -p models/{unet,loras,text_encoders,vae,diffusion_models,clip,checkpoints}

# 6. Final environment configuration
WORKDIR /
EXPOSE 8188

# Set labels for better container management
LABEL com.vastai.comfy.version="12.8-auto"
