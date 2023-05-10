FROM nvidia/cuda:12.0.1-devel-rockylinux9

# Setup SSH
RUN dnf install -y openssh-server rsync
RUN ssh-keygen -A
RUN echo "X11Forwarding yes" >> /etc/ssh/sshd_config

# Setup X11 
RUN dnf install xorg-x11-xauth xorg-x11-fonts-* xorg-x11-utils -y
RUN dnf install mesa-dri-drivers -y

# Setup Dev Tools
RUN dnf install gdb cmake -y
RUN dnf install epel-release -y
RUN dnf install 'dnf-command(config-manager)'
RUN dnf config-manager --set-enabled crb
RUN dnf install @"Development Tools" -y

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
RUN echo "export TERM=xterm-256color" >> /home/gpu-dev/.bashrc


USER $USERNAME
EXPOSE 2222
CMD sudo /sbin/sshd -D -p 2222
