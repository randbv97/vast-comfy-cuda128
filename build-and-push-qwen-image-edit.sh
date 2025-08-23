docker pull randbv97/vast-comfy-cuda128:latest
docker build -f Dockerfile-qwen-image-edit . -t randbv97/vast-comfy-cuda128:latest-qwen-image-edit
docker push randbv97/vast-comfy-cuda128:latest-qwen-image-edit
