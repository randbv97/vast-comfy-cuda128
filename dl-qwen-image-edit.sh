#!/bin/bash

cd models

# Function to download a file if it doesn't exist
download_file() {
    local path=$1
    local url=$2
    if [ ! -f $path ]; then
        wget $url -O $path
    fi
}

download_file unet/Qwen_Image_Edit-Q8_0.gguf https://huggingface.co/QuantStack/Qwen-Image-Edit-GGUF/resolve/main/Qwen_Image_Edit-Q8_0.gguf
download_file loras/Qwen-Image-Lightning-4steps-V1.0.safetensors https://huggingface.co/lightx2v/Qwen-Image-Lightning/resolve/main/Qwen-Image-Lightning-4steps-V1.0.safetensors
download_file text_encoders/qwen_2.5_vl_7b.safetensors https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b.safetensors
download_file vae/qwen_image_vae.safetensors https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/vae/qwen_image_vae.safetensors
