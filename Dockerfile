FROM vastai/comfy:cuda-12.8-auto

# Update to latest ComfyUI version
WORKDIR /opt/workspace-internal/ComfyUI
RUN git checkout master && \
    git pull && \
    git submodule update --init --recursive

# Install dependencies
RUN /venv/main/bin/pip install --upgrade pip && \
    /venv/main/bin/pip install -r requirements.txt

WORKDIR /opt/workspace-internal/ComfyUI/custom_nodes/

# Download custom nodes for Wan
RUN git clone --recursive https://github.com/chengzeyi/Comfy-WaveSpeed \
    && git clone --recursive https://github.com/city96/ComfyUI-GGUF \
    && git clone --recursive https://github.com/crystian/ComfyUI-Crystools \
    && git clone --recursive https://github.com/evanspearman/ComfyMath \
    && git clone --recursive https://github.com/Fannovel16/ComfyUI-Frame-Interpolation \
    && git clone --recursive https://github.com/giriss/comfy-image-saver \
    && git clone --recursive https://github.com/ka-puna/comfyui-yanc \
    && git clone --recursive https://github.com/kijai/ComfyUI-KJNodes comfyui-kjnodes \
    && git clone --recursive https://github.com/kijai/ComfyUI-WanVideoWrapper \
    && git clone --recursive https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite comfyui-videohelpersuite \
    && git clone --recursive https://github.com/liusida/ComfyUI-Login login \
    && git clone --recursive https://github.com/marhensa/sdxl-recommended-res-calc \
    && git clone --recursive https://github.com/mcmonkeyprojects/sd-dynamic-thresholding \
    && git clone --recursive https://github.com/rcsaquino/comfyui-custom-nodes \
    && git clone --recursive https://github.com/rgthree/rgthree-comfy \
    && git clone --recursive https://github.com/ShmuelRonen/ComfyUI-FreeMemory \
    && git clone --recursive https://github.com/ssitu/ComfyUI_UltimateSDUpscale \
    && git clone --recursive https://github.com/Stability-AI/stability-ComfyUI-nodes \
    && git clone --recursive https://github.com/filliptm/ComfyUI_Fill-Nodes.git \
    && git clone --recursive https://github.com/filliptm/ComfyUI-LTXVideo.git \
    && git clone --recursive https://github.com/WASasquatch/was-node-suite-comfyui

# For each extension, install the dependencies
RUN for extension in $(ls -d */); do \
    cd $extension && \
    if [ -f requirements.txt ]; then \
        /venv/main/bin/pip install -r requirements.txt; \
    fi; \
    cd ..; \
done

# Copy the download scripts
COPY dl-*.sh /opt/workspace-internal/ComfyUI/
RUN chmod +x /opt/workspace-internal/ComfyUI/*.sh
RUN mkdir -p /opt/workspace-internal/ComfyUI/models/{unet,loras,text_encoders,vae,diffusion_models,clip,checkpoints}

WORKDIR /
