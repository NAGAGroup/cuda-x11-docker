FROM nvidia/cuda:11.6.1-devel-rockylinux8
RUN /bin/sh -c dnf install -y openssh-server rsync
RUN /bin/sh -c ssh-keygen -A
RUN /bin/sh -c dnf install xterm xorg-x11-xauth xorg-x11-fonts-* xorg-x11-utils -y
RUN /bin/sh -c dnf install mesa-dri-drivers -y
RUN /bin/sh -c dnf install gdb cmake -y
RUN /bin/sh -c dnf install passwd shadow-utils -y
RUN /bin/sh -c echo "root:naga_is_awesome" | chpasswd
RUN /bin/sh -c echo "export TERM=vt100" >> /root/.bashrc
EXPOSE 2222
CMD /sbin/sshd -D -p 2222
