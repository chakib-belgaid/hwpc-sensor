ARG ALPINE_VERSION=3.12


FROM alpine:${ALPINE_VERSION}
WORKDIR /home/packager

ARG GIT_TAG
ARG GIT_REV 

# If you want these variables to be available in the running container
# ENV ALPINE_VERSION=$ALPINE_VERSION
# ENV GIT_TAG=$GIT_TAG
# ENV GIT_REV=$GIT_REV
ADD APKBUILD APKBUILD
ADD hwpc.post-install hwpc.post-install
RUN apk update && apk add alpine-sdk build-base sudo && \
    adduser -D packager  \
    && addgroup packager abuild \
    && echo "packager ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/packager 

USER packager
RUN abuild-keygen -a -i -n \
    && abuild -r 
# RUN abuild -r
