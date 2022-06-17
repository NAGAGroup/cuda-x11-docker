FROM nvidia/cuda:11.6.0-devel-ubuntu20.04
ENV DEBIAN_FRONTEND=nointeractive
ENV TZ=America/Los_Angeles
RUN apt update && apt install openssh-server sudo x11-utils -y
RUN apt install build-essential gdb rsync git -y

RUN git clone https://github.com/Kitware/CMake.git
RUN apt install libssl-dev ninja-build -y
RUN cd CMake && git checkout tags/v3.22.5 && ./bootstrap && make -j && make install && cd .. && rm -rf CMake 

RUN echo 'root:cugal' | chpasswd
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
RUN echo "export TERM=vt100\nexport DISPLAY=:0" >> /root/.bashrc

RUN echo "service ssh restart\nwhile [ 1 ]; do sleep 1; done" > start.sh

EXPOSE 22

