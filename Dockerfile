# Build Stage
FROM --platform=linux/amd64 ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y clang

## Add source code to the build stage. ADD prevents git clone being cached when it shouldn't
ADD . /xHTTP
WORKDIR /xHTTP

## Build
RUN clang -ggdb -O0 example2.c xhttp.c -o xhttp_server

## Package Stage
FROM --platform=linux/amd64 ubuntu:20.04
COPY --from=builder /xHTTP/xhttp_server /xhttp_server

#env AFL_NO_FORKSRV=1
CMD ["/xhttp_server"]
