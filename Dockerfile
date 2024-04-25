ARG ALPINE_VERSION=3.12
ARG GIT_TAG="undefined"
ARG GIT_REV="undefined"


FROM alpine:${ALPINE_VERSION}
WORKDIR /home/packager


RUN echo  "------------- my version " ${GIT_TAG1} ${GIT_REV}
ADD APKBUILD APKBUILD
ADD hwpc.post-install hwpc.post-install
RUN apk update && apk add alpine-sdk build-base sudo 
RUN adduser -D packager  \
    && addgroup packager abuild \
    && echo "packager ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/packager 

USER packager
RUN export GIT_TAG1=${GIT_TAG} \
    && export GIT_REV=${GIT_REV} \
    && abuild-keygen -a -i -n \
    && abuild -r 
# RUN abuild -r
