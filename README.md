# CUDA + X11 + DOCKER == HAPPY_DEV
CUDA can get finicky. For example a gcc version on my Fedora installation was just not working at one point and I had to compile gcc from scratch. I decided to give ``nvidia-docker`` a look and it's great, but I often write graphical applications so I needed some way to visualize. Turns out one get x11 forwarding through docker, either via some command-line argument wizardry or x11 forwarding via ssh. The problem is the CUDA docker images don't have x11 essentials or C/C++ tools by default. Hence I developed this image which includes the latest ``cmake`` git version (will be downgraded to latest stable release), ``build-essentials``, ``ssh`` tools, etc. 

## Getting Started
Follow the instructions [here](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#) to get the NVIDIA Container Toolkit installed. I was able to get the CentOS8 repo to work on my Fedora 35 install.

## Usage
There are two primary methods for getting X11 to work properly
- ssh X11 forwarding
- docker arguments and ``xhost``

### SSH X11 Forwarding
```shell
# first start the docker container
docker run --rm -d --gpus all -p 2222:22 jackm97/cuda-x11-docker:latest bash start.sh
# then connect via ssh
ssh -X root@localhost -p 2222
```
The password is ``naga_is_awesome``. It may also be helpful to add the following to your ``~/.ssh/config`` file on the host(e.g. not the container) to automatically enable X11 forwarding for ssh. This is useful when using IDEs that support remote development.
```
ForwardAgent yes 
ForwardX11 yes
```

### xhost
Start the container using
```shell
xhost +SI:localuser:root
docker run --rm -d --gpus all -p 2222:22 \
            -e DISPLAY=$DISPLAY \
            -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
            --ipc=host \
            jackm97/cuda-x11-docker:latest bash start.sh
```
Now you can ssh normally without X11 forwarding and it should work.

### What next?
Once connected try installing and running ``glxgears``! You can install extra packages as well when starting your container by chaining commands before the start script. Happy programming!

## DockerHub
The image is hosted on [DockerHub](https://hub.docker.com/repository/docker/jackm97/cuda-x11-docker)
