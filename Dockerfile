ARG ALPINE_VERSION=3.12
ARG GIT_TAG="undefined"
ARG GIT_REV="undefined"
FROM alpine:${ALPINE_VERSION}
WORKDIR /home/packager
ENV GIT_TAG=$GIT_TAG
ENV GIT_REV=$GIT_REV
ADD APKBUILD APKBUILD
ADD hwpc.post-install hwpc.post-install
RUN apk update && apk add alpine-sdk build-base sudo 
RUN adduser -D packager  \
    && addgroup packager abuild \
    && echo "packager ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/packager 

USER packager
RUN echo  "------------- my version " ${GIT_TAG} ${GIT_REV}
RUN abuild-keygen -a -i -n 

RUN sed -i "s/pkgver=0.0.0/pkgver=$GIT_TAG/g" APKBUILD \
    && sed -i "s/pkgrel=0/pkgrel=$GIT_REV/g" APKBUILD 
RUN abuild -r 
# RUN abuild -r
