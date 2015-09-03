# qtox over ssh X11Forwarding
FROM ubuntu:latest

# Set default locale for the environment
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

ENV QTOX_PKG qtox_1.0-1751_amd64.deb
ENV QTOX_BIN qTox_build_linux_x86-64_release.tar.xz

# make sure the package repository is up to date
RUN apt-get update -qq
RUN apt-get upgrade -y -qq

# install ssh and iceweasel
RUN apt-get install -y openssh-server

# various utils
RUN apt-get install -y git pulseaudio curl wget xz-utils bzip2 unzip -qq

# Create user "docker" and set the password to "docker"
RUN useradd -m -d /home/docker docker
RUN echo "docker:docker" | chpasswd

# Prepare ssh config folder
RUN mkdir -p /home/docker/.ssh
RUN chown -R docker:docker /home/docker
RUN chown -R docker:docker /home/docker/.ssh

RUN apt-get -y install libopenal1 libqt5core5a libqt5gui5 libqt5network5 libqt5widgets5 libqt5xml5 libqt5opengl5 libopencv-core2.4 libopencv-highgui2.4 libqt5sql5 libqt5sql5-sqlite libopencv-imgproc2.4 apt-transport-https libqt5svg5 libappindicator1 libqrencode3 libxss1 libxss-dev libdc1394-22 libdc1394-utils

# apparently tox's repos don't have qtox packages yet
# RUN echo "deb https://pkg.tox.chat/debian nightly main" > /etc/apt/sources.list.d/tox.list
# RUN wget -qO - https://pkg.tox.chat/debian/pkg.gpg.key | apt-key add -
# RUN apt-get install -y -qq apt-transport-https
# RUN apt-get update -qq
# RUN apt-get install -y qtox -qq

# RUN apt-get install -y -qq build-essential qt5-qmake qt5-default qttools5-dev-tools libqt5opengl5-dev libqt5svg5-dev libopenal-dev libxss-dev qrencode libqrencode-dev libglib2.0-dev libgdk-pixbuf2.0-dev libgtk2.0-dev
# RUN git clone https://github.com/tux3/qTox.git qTox
# RUN cd qTox

# ADD ./ffmpeg.sh .
# ADD ./toxcore.sh .

# RUN bash ffmpeg.sh
# RUN bash toxcore.sh

# RUN cd ../
# RUN qmake \
    # && make
# RUN cd libs/lib \
    # && export LD_LIBRARY_PATH="$PWD" \
    # && cd ../../

#ADD ./$QTOX_PKG /home/docker/$QTOX_BIN
#ADD ./$QTOX_PKG.sha256 /home/docker/$QTOX_BIN.sha256

ADD ./$QTOX_PKG /home/docker/$QTOX_PKG
ADD ./$QTOX_PKG.sha256 /home/docker/$QTOX_PKG.sha256

WORKDIR /home/docker

RUN sha256sum -c $QTOX_PKG.sha256
RUN dpkg -i $QTOX_PKG

#RUN sha256sum -c $QTOX_BIN.sha256

USER docker

RUN touch /home/docker/.Xauthority

# create tox config dir for possible shared volume mount without grumpy missing directory errors
RUN mkdir -p /home/docker/.config/tox/

# Create OpenSSH privilege separation directory, enable X11Forwarding
USER root

RUN mkdir -p /var/run/sshd
RUN echo X11Forwarding yes >> /etc/ssh/ssh_config

# Expose the SSH port
EXPOSE 22

# Start SSH
ENTRYPOINT ["/usr/sbin/sshd",  "-D"]
