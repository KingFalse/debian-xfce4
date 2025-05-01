FROM python:3.10-slim-bookworm

LABEL authors="KingFalse <yzsl@live.com>"

RUN sed -i 's@deb.debian.org@mirrors.ustc.edu.cn@g' /etc/apt/sources.list.d/debian.sources

RUN apt update && \
    apt install -y xfce4 dbus-x11 xfce4-terminal novnc tigervnc-standalone-server tigervnc-tools chromium fonts-noto-cjk &&  \
    sed -i '/^CHROMIUM_FLAGS="/s/"$/ --no-sandbox --start-maximized"/' /usr/bin/chromium &&  \
    apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "password" | vncpasswd -f > /vncpasswd

ENV TZ=Asia/Shanghai \
    DISPLAY=:0 \
    SCR_WIDTH=1440 \
    SCR_HEIGHT=900 \
    SCR_DEPTH=24 \
    SHELL=/bin/bash

COPY ./xsettings.xml /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/

CMD vncserver $DISPLAY -geometry "$SCR_WIDTH"x"$SCR_HEIGHT" -depth $SCR_DEPTH -SecurityTypes VncAuth -rfbauth /vncpasswd -xstartup startxfce4 & /usr/share/novnc/utils/novnc_proxy