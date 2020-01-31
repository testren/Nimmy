FROM gitpod/workspace-full-vnc:latest

USER root

# Update apt repositories
RUN apt-get update

# Upgrade the image
RUN apt upgrade -y
RUN apt dist-upgrade -y

# Install linting dependencies
RUN apt install -y shellcheck firefox tree xclip

# Install mindmap dependencies
RUN wget https://www.edrawsoft.com/archives/mindmaster-7-amd64.deb -O /tmp/mindmaster.deb
## Mindmaster needs libsmime3.so which is provided by libnss3
RUN apt install -y libnss3
RUN apt install -y /tmp/mindmaster.deb

# Add custom functions
RUN if ! grep -qF 'ix()' /etc/bash.bashrc; then printf '%s\n' \
	'# Custom' \
	"ix() { curl -F 'f:1=<-' ix.io 2>/dev/null ;}" \
	"xcopy() { xclip -se C ;}" \
	>> /etc/bash.bashrc; fi

# Remove apt sources to clean up space
RUN rm -rf /var/lib/apt/lists/*

# Clean-up unneeded packages
RUN apt autoremove -y
