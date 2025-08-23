#!/bin/bash

export DOCKER_BUILDKIT=1
docker pull randbv97/vast-comfy-cuda128:latest
docker buildx build --output type=image,compression=zstd,compression-level=3 \
   -f Dockerfile-wan22-fun-camera-control . -t randbv97/vast-comfy-cuda128:latest-wan22-fun-camera-control --push

