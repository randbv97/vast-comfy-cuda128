#!/bin/bash

export DOCKER_BUILDKIT=1
docker pull randbv97/vast-comfy-cuda128:latest
docker buildx build --output type=image,compression=zstd,compression-level=3 \
   -f Dockerfile-qwen-image-edit . -t randbv97/vast-comfy-cuda128:latest-qwen-image-edit --push

