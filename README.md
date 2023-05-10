# CUDA + X11 + Container == HAPPY_DEV
This container image provides access to the Rocky Linux 9 image for CUDA 12.0 with additional packages
installed to support X11 forwarding.

## Getting Started
Follow the instructions [here](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#) to get the NVIDIA Container Toolkit 
installed. I was able to get the CentOS8 repo to work on my Fedora 35-38 installations. Despite the image name,
I use `podman`, but the following commands should be similar for `docker`.

## Usage
```shell
# first start the docker container
podman run --rm --security-opt=label=disable -d -p 2222:2222 ghcr.io/nagagroup/cuda-x11-docker:12.0.1
# then connect via ssh
ssh -X gpu-dev@localhost -p 2222
```
The password is ``naga_is_awesome``. It may also be helpful to add the following to your ``~/.ssh/config`` 
file on the host(e.g. not the container) to automatically enable X11 forwarding for ssh. 
This is useful when using IDEs that support remote development.
```
ForwardAgent yes 
ForwardX11 yes
```

### What next?
Once connected try installing and running ``glxgears``! You can install extra packages as well 
when starting your container by chaining commands before the start script. Happy programming!
