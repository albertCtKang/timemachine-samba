sudo docker run -it \
-e AFP_LOGIN=timemachine -e AFP_PASSWORD=timemachine -e AFP_NAME=TMBackup -e AFP_SIZE_LIMIT=1024000 \
--net=host -d vsdx/timemachine-samba:v1.0
