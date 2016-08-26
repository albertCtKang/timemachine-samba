FROM ubuntu:14.04
MAINTAINER Albert Kang <albertkang@gnap.com>

##################
##   BUILDING   ##
##################

# Prerequisites
RUN apt-get --quiet --yes update
ENV DEBIAN_FRONTEND noninteractive
RUN ln -s -f /bin/true /usr/bin/chfn

# Versions to use
ENV timemachine_path /data/timemachine

# Install prerequisites:
RUN apt-get --quiet --yes install netatalk avahi-autoipd cifs-utils samba

# Compiling netatalk
WORKDIR /usr/local/src
RUN apt-get --quiet --yes autoclean \
    &&  apt-get --quiet --yes autoremove \
    &&  apt-get --quiet --yes clean

# Add default user and group
RUN  mkdir -p ${timemachine_path}
RUN  chmod 775 ${timemachine_path}

ADD init_service.sh /usr/local/src/init_service.sh
ADD avahi/nsswitch.conf /etc/nsswitch.conf
ADD avahi/afpd.service /etc/avahi/services/afpd.service

RUN update-rc.d dbus defaults
RUN update-rc.d avahi-daemon defaults
RUN update-rc.d netatalk defaults
RUN update-rc.d samba defaults

VOLUME ["${timemachine_path}"]

CMD [ "/bin/bash", "/usr/local/src/init_service.sh" ]


