#!/bin/bash

export DOCKER_BUILDKIT=1
docker buildx build --output type=image,compression=zstd,compression-level=3 \
   . -t randbv97/vast-comfy-cuda128:latest --push

