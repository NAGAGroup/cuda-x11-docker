FROM nvidia/cuda:12.0.1-devel-rockylinux9
RUN dnf install -y openssh-server rsync
RUN ssh-keygen -A
RUN dnf install xterm xorg-x11-xauth xorg-x11-fonts-* xorg-x11-utils -y
RUN dnf install mesa-dri-drivers -y
RUN dnf install gdb cmake -y
RUN dnf install passwd shadow-utils -y

RUN dnf install epel-release -y
RUN dnf install 'dnf-command(config-manager)'
RUN dnf config-manager --set-enabled crb
RUN dnf install @"Development Tools" -y

RUN echo "root:naga_is_awesome" | chpasswd
RUN echo "export TERM=vt100" >> /root/.bashrc
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
RUN echo "X11Forwarding yes" >> /etc/ssh/sshd_config
EXPOSE 2222
CMD /sbin/sshd -D -p 2222
