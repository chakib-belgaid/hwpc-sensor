from alpine:3.12 
WORKDIR /home/packager
ADD APKBUILD APKBUILD
RUN apk update && apk add alpine-sdk build-base sudo 
RUN adduser -D packager  \
&& addgroup packager abuild \
&& echo "packager ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/packager \
&& sudo -u packager sh  \
&& abuild-keygen -a -i -n

USER packager

RUN abuild-keygen -a -i -n
# RUN abuild -r