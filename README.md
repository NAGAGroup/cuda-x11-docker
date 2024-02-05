# CUDA + X11 + Container == HAPPY_DEV
This container image uses NVIDIA's Rocky Linux image as a base, with additional packages
that make it immediately ready for C++/CUDA development. It contains up-to-date versions of
cmake, ninja, conan and other tools, as well as gcc toolchains for C++ development. The toolchains installed are the default system gcc toolchain in addition to a more up-to-date toolchain for enabling newer C++ features. To get the specific, newer, gcc toolset installed, please take a look at the Dockerfile, as this version choice will change over time. 

Also provided are the i3 window manager, TurboVNC and VirtualGL for remote visualization support. Scientific computing often requires a visualization component, and although tools like ParaView support remote rendering, we've found performance to be better with TurboVNC and VirtualGL. This setup is also more flexible, allowing high performance remote 3D visualization on GPUs for apps that don't support remote rendering. 

Finally, some additional tools that we find useful, like fish shell, neovim and a few others are included. 

Detailed instructions for working with these tools, and enabling GPU-accelerated containers can be found in their respective documentation. For example, instructions for enabling GPUs in a container can be found in the NVIDIA Container Toolkit documentation. 

## Conda for Up-to-Date Tools
Unsurprisingly, finding the latest tools in the Rocky Linux repos is not possible. There are a number of ways to get these tools, but we have found conda to be the easiest to work with. We have carefully selected packages such that only executables are installed via conda to ensure that the system is not polluted with conda libraries that hide the system libraries. The only tool we do not install via conda is cmake, as the cmake provided via our enabled conda repos is altered to be compatible with conda's environment management.

### Conda Licensing
Some might see conda and have licensing worries, especially if the intended use case is in a corporate environment. But, we have made sure to not enable the Anaconda repos, instead installing everything from conda-forge. Somewhat recently, there was some controversy around licensing when using conda to install from non-Anaconda repos, but it has been cleared up that conda-forge packages are not subject to the Anaconda licensing. See this conda-forge [blog post](https://conda-forge.org/blog/2020/11/20/anaconda-tos/) for more details.

## SSH-ing into the Container
We prefer rootless containers, so the default user is gpu-dev. Additionally, we have chosen port 2222 for ssh instead of 22. This port needs to be mapped to the host in the run command. From there, you can ssh into the container with the following command:

```bash
ssh -p 2222 gpu-dev@localhost  # replace localhost with IP if the container is running on a remote machine
```


## Running the Container
We provide an example run command that maps the ssh port and passes through the GPU devices using podman.

```bash
podman run -d --rm -p 2222:2222 --device nvidia.com/gpu=all --security-opt=label=disable ghcr.io/nagagroup/cuda-x11-docker:latest  # default command starts up sshd
```

