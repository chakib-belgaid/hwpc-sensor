ARG ALPINE_VERSION=3.12
FROM alpine:${ALPINE_VERSION}
WORKDIR /home/packager
ENV GIT_TAG="undefined"
ENV GIT_REV="undefined"
ADD APKBUILD APKBUILD
ADD hwpc.post-install hwpc.post-install
RUN apk update && apk add alpine-sdk build-base sudo 
RUN adduser -D packager  \
    && addgroup packager abuild \
    && echo "packager ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/packager 

USER packager

RUN abuild-keygen -a -i -n 
RUN abuild -r 
# RUN abuild -r
