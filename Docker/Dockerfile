#Imagen base 
FROM ubuntu

RUN ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

# Everything you need for RadStudio plus some utilities that may come in handy
RUN \
 apt-get -y update && \
 apt-get -y upgrade && \
 apt-get -y dist-upgrade && \
 apt-get -y install joe wget p7zip-full curl unzip build-essential zlib1g-dev libcurl4-gnutls-dev && \
 apt-get -y install mysecureshell && \
 apt-get -y autoremove && \
 apt-get -y autoclean

# Copy PAServer to container and unzip it
COPY LinuxPAServer19.0.tar.gz /root/LinuxPAServer19.0.tar.gz
RUN \
 cd /root && \
 tar xzvf LinuxPAServer19.0.tar.gz && \
 cd PAServer-19.0 && \
 mkdir scratch-dir 

# RUN \
#  cd /root && \
#  cd PAServer-19.0 && \
#  mkdir app

# Working directory
WORKDIR /root/PAServer-19.0

# Start PAServer
CMD ["/root/PAServer-19.0/paserver","-password=1234"]

# Publish PAServer default port
EXPOSE 64211