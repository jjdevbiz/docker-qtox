# qtox over ssh X11Forwarding

FROM debian:stable

# make sure the package repository is up to date
# and blindly upgrade all packages
RUN apt-get update -qq
RUN apt-get upgrade -y -qq

# install ssh and iceweasel
RUN apt-get install -y openssh-server

# various utils
RUN apt-get install -y pulseaudio curl wget xz-utils bzip2 unzip -qq

# Create user "docker" and set the password to "docker"
RUN useradd -m -d /home/docker docker
RUN echo "docker:docker" | chpasswd

# Prepare ssh config folder
RUN mkdir -p /home/docker/.ssh
RUN chown -R docker:docker /home/docker
RUN chown -R docker:docker /home/docker/.ssh

RUN touch /home/docker/.Xauthority

## apparently tox's repos are broken with no pubkey atm
# Mindlessly copied package install directions from https://github.com/tux3/qTox/blob/master/INSTALL.md#simple-install
RUN echo "deb https://pkg.tox.chat/ debian nightly" > /etc/apt/sources.list.d/tox.list
#RUN wget -qO - https://pkg.tox.chat/pubkey.gpg | apt-key add -
RUN apt-get install -y apt-transport-https -qq
RUN apt-get update -qq
RUN apt-get install -y qtox -qq



# create tox config dir for possible shared volume mount without grumpy missing directory errors
RUN mkdir -p /home/docker/.config/tox/

# Create OpenSSH privilege separation directory, enable X11Forwarding
RUN mkdir -p /var/run/sshd
RUN echo X11Forwarding yes >> /etc/ssh/ssh_config

# Expose the SSH port
EXPOSE 22

# Start SSH
ENTRYPOINT ["/usr/sbin/sshd",  "-D"]
