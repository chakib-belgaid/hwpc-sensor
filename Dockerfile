from alpine:3.12 
RUN apk add --no-cache python3-dev \
    && pip3 install --upgrade pip
