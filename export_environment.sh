#! /bin/bash

podman run --rm -it \
	--device nvidia.com/gpu=all \
	--security-opt=label=disable \
	-v $PWD:/mnt/host_dir \
	localhost/cuda-x11-docker:12.3.1 bash -c "sudo bash -c 'cat /etc/conda/environment.yml > /mnt/host_dir/environment.yml'"
