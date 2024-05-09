FROM ubuntu:latest

RUN apt update && DEBIAN_FRONTEND=noninteractive TZ=US/LosAngeles apt install -y verilog git gtkwave wget unzip openjdk-11-jre

ENV VNC_RESOLUTION="1920x1200x16" \
    VNC_DPI="96"

RUN wget https://github.com/hneemann/Digital/releases/latest/download/Digital.zip
RUN unzip Digital.zip
RUN mv Digital /usr/local/Digital
COPY Digital.sh /usr/local/Digital
RUN chmod a+x /usr/local/Digital/Digital.sh

COPY menu /root/.fluxbox/menu