FROM nvcr.io/nvidia/cuda:12.3.1-devel-rockylinux9

# nvidia-container-runtime
ENV NVIDIA_DRIVER_CAPABILITIES \
        ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics,utility


# libglvnd
COPY 10_nvidia.json /usr/share/glvnd/egl_vendor.d/10_nvidia.json
RUN dnf install -y libglvnd-egl libglvnd-glx libglvnd-opengl libglvnd-gles libglvnd

# nvidia cuda drivers for nvidia-smi functionality
RUN dnf install -y nvidia-driver-cuda

# Setup SSH
RUN dnf install -y openssh-server rsync
RUN ssh-keygen -A

# Get access to more packages
RUN dnf install -y epel-release
RUN crb enable

# Use i3 as wm for remote graphical access
RUN dnf install -y i3

# TurboVNC + VirtualGL remote graphical access
RUN dnf install -y wget
RUN wget "https://sourceforge.net/projects/virtualgl/files/3.1/VirtualGL-3.1.x86_64.rpm/download"  -O /tmp/VirtualGL-3.1.x86_64.rpm
RUN dnf install /tmp/VirtualGL-3.1.x86_64.rpm -y
RUN wget "https://sourceforge.net/projects/turbovnc/files/3.0.3/turbovnc-3.0.3.x86_64.rpm/download" -O /tmp/turbovnc-3.0.3.x86_64.rpm
RUN dnf install /tmp/turbovnc-3.0.3.x86_64.rpm -y

# Setup User
ARG USERNAME=gpu-dev
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN dnf install passwd shadow-utils sudo -y

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
RUN chpasswd gpu-dev <<< "gpu-dev:naga_is_awesome"

# Extras that I have found useful for base image
RUN sudo dnf install -y kitty-terminfo git dnf-plugins-core

USER $USERNAME

# Dev tools
RUN sudo dnf install @"Development Tools" -y
RUN sudo dnf install gcc-toolset-12 -y 
WORKDIR /tmp
RUN curl -L -O "https://github.com/Kitware/CMake/releases/download/v3.28.2/cmake-3.28.2-linux-x86_64.sh"
RUN sudo sh cmake-3.28.2-linux-x86_64.sh --prefix=/usr/local/ --exclude-subdir
RUN curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
RUN bash Miniforge3-$(uname)-$(uname -m).sh -b -p /home/$USERNAME/conda
RUN source "${HOME}/conda/etc/profile.d/conda.sh"; source "${HOME}/conda/etc/profile.d/mamba.sh"; conda activate && conda init bash
RUN bash --login -c "mamba install cppcheck doxygen texlive-core ghostscript cmake-format npx prettier codespell pip ninja neovim nvim -y"
RUN bash --login -c "conda env export --no-builds | grep -v \"^prefix: \" > environment.yml"
RUN sudo mkdir /etc/conda
RUN sudo cp environment.yml /etc/conda

# Install bottom, a nice TUI process manager
RUN sudo dnf copr enable atim/bottom -y
RUN sudo dnf install bottom -y

# Install fish shell
RUN sudo dnf install fish -y

ENV CUDA_X11_DOCKER ""

WORKDIR /home/$USERNAME

RUN echo "source /opt/rh/gcc-toolset-12/enable" >> /home/$USERNAME/.bashrc

 # Source setup_env.sh in entrypoint
ENTRYPOINT ["/bin/bash", "-c", "bash -c \"sudo /sbin/sshd -D -p 2222&\" && /bin/bash", "--login", "-c"]
EXPOSE 2222
