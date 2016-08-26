# docker-timemachine
A docker container to compile the lastest version of Netatalk in order to run a Time Machine server with Samba as volume.

## Installation

To download the docker container and execute it, simply run:

`sudo docker run -h timemachine --name timemachine -e AFP_LOGIN=<YOUR_USER> -e AFP_PASSWORD=<YOUR_PASS> \
 -e AFP_NAME=<TIME_MACHINE_NAME> -e AFP_SIZE_LIMIT=<MAX_SIZE_IN_MB> -v /host/mnt/timemachine:/timemachine \
 -d -t -i --net=host vsdx/timemachine-samba`

If you don't want to specify the maximum volume size (and use all the space available), you can omit the `-e AFP_SIZE_LIMIT=<MAX_SIZE_IN_MB>` variable.

Now you have a docker instance to running timemachine with netatalk and Samba as Volume.

Note that --net=host doesn't work with ubuntu trusty 14.04: https://github.com/docker/docker/issues/5899

The following steps show the regarding activities for running Avahi in the container (Ubuntu version):
* Install `avahi-daemon`: run `sudo apt-get install avahi-daemon avahi-utils`* Copy the file from `avahi/nsswitch.conf` to `/etc/nsswitch.conf`
* Restart Avahi's daemon: `sudo /etc/init.d/avahi-daemon restart`

**Note:** In order to run Avahi in the container, please make sure dbus-daemon has been running.

* To start the service: `sudo /etc/init.d/dbus start`


