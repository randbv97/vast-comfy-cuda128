#!/bin/bash

cd models

# Function to download a file if it doesn't exist
download_file() {
    local path=$1
    local url=$2
    if [ ! -f $path ]; then
        wget $url -O $path &
    fi
}

download_file checkpoints/ltx-2-19b-dev-fp8.safetensors https://huggingface.co/Lightricks/LTX-2/resolve/main/ltx-2-19b-dev-fp8.safetensors
download_file text_encoders/gemma_3_12B_it_fp4_mixed.safetensors https://huggingface.co/Comfy-Org/ltx-2/resolve/main/split_files/text_encoders/gemma_3_12B_it_fp4_mixed.safetensors
download_file loras/ltx-2-19b-distilled-lora-384.safetensors https://huggingface.co/Lightricks/LTX-2/resolve/main/ltx-2-19b-distilled-lora-384.safetensors

mkdir -p latent_upscale_models
download_file latent_upscale_models/ltx-2-spatial-upscaler-x2-1.0.safetensors https://huggingface.co/Lightricks/LTX-2/resolve/main/ltx-2-spatial-upscaler-x2-1.0.safetensors

