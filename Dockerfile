FROM almalinux as builder

#USER root

#RUN dnf group install -y "Development Tools"
#RUN dnf group info "Development Tools"
RUN dnf install -y tar wget cmake gcc 

WORKDIR /build

COPY CMakeLists.txt config.h fan-control.c ./

RUN wget http://www.airspayce.com/mikem/bcm2835/bcm2835-1.73.tar.gz && tar xvfz bcm2835-1.73.tar.gz && rm -f bcm2835-1.73.tar.gz
RUN mkdir bcm2835 && cd bcm2835-1.73/ && ./configure && make && make install && cd ..

RUN cmake . && make


FROM almalinux
WORKDIR /app
COPY --from=builder /build/fan-control ./fan-control

ENTRYPOINT ["bash", "-c", "./fan-control"]
