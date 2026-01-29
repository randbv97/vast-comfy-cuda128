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

download_file diffusion_models/ltx2-phr00tmerge-sfw-v5.safetensors https://huggingface.co/Phr00t/LTX2-Rapid-Merges/resolve/main/sfw/ltx2-phr00tmerge-sfw-v5.safetensors
download_file text_encoders/gemma_3_12B_it_fp8_scaled.safetensors https://huggingface.co/Comfy-Org/ltx-2/resolve/main/split_files/text_encoders/gemma_3_12B_it_fp8_scaled.safetensors
download_file text_encoders/ltx-2-19b-embeddings_connector_dev_bf16.safetensors https://huggingface.co/Kijai/LTXV2_comfy/resolve/main/text_encoders/ltx-2-19b-embeddings_connector_dev_bf16.safetensors
download_file vae/LTX2_audio_vae_bf16.safetensors https://huggingface.co/Kijai/LTXV2_comfy/resolve/main/VAE/LTX2_audio_vae_bf16.safetensors
download_file vae/LTX2_video_vae_bf16.safetensors https://huggingface.co/Kijai/LTXV2_comfy/resolve/main/VAE/LTX2_video_vae_bf16.safetensors

