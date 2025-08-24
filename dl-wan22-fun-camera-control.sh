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

download_file vae/Wan2_1_VAE_bf16.safetensors https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2_1_VAE_bf16.safetensors
download_file text_encoders/umt5-xxl-enc-bf16.safetensors https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/umt5-xxl-enc-bf16.safetensors
download_file diffusion_models/Wan2_2-Fun-Control-Camera-A14B-HIGH_fp8_e4m3fn_scaled_KJ.safetensors https://huggingface.co/Kijai/WanVideo_comfy_fp8_scaled/resolve/main/Fun/Wan2_2-Fun-Control-Camera-A14B-HIGH_fp8_e4m3fn_scaled_KJ.safetensors
download_file diffusion_models/Wan2_2-Fun-Control-Camera-A14B-LOW_fp8_e4m3fn_scaled_KJ.safetensors https://huggingface.co/Kijai/WanVideo_comfy_fp8_scaled/resolve/main/Fun/Wan2_2-Fun-Control-Camera-A14B-LOW_fp8_e4m3fn_scaled_KJ.safetensors
download_file loras/Wan2.2-Lightning_I2V-A14B-4steps-lora_HIGH_fp16.safetensors https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan22-Lightning/Wan2.2-Lightning_I2V-A14B-4steps-lora_HIGH_fp16.safetensors
download_file loras/Wan2.2-Lightning_I2V-A14B-4steps-lora_LOW_fp16.safetensors https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan22-Lightning/Wan2.2-Lightning_I2V-A14B-4steps-lora_LOW_fp16.safetensors
