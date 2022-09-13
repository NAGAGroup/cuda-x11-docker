FROM nvidia/cuda:11.6.1-devel-rockylinux8
RUN dnf install -y openssh-server rsync
RUN ssh-keygen -A
RUN dnf install xterm xorg-x11-xauth xorg-x11-fonts-* xorg-x11-utils -y
RUN dnf install mesa-dri-drivers -y
RUN dnf install gdb cmake -y
RUN dnf install passwd shadow-utils -y

# rockylinux8 gcc-11-toolchain
RUN dnf install gcc-toolset-11-toolchain -y


RUN echo "root:naga_is_awesome" | chpasswd
RUN echo "export TERM=vt100" >> /root/.bashrc
EXPOSE 2222
CMD /sbin/sshd -D -p 2222
