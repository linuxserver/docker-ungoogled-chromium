FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm

# set version label
ARG BUILD_DATE
ARG VERSION
ARG UGC_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE="Ungoogled Chromium"

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /kclient/public/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/ungoogled-chromium-logo.png && \
  mkdir -p \
    /usr/share/icons/hicolor/192x192/apps/ && \
  cp \
    /kclient/public/icon.png \
    /usr/share/icons/hicolor/192x192/apps/ungoogled-chromium-logo.png && \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install -y \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libnss3 \
    libxcomposite1 \
    libxdamage1 \
    libxkbcommon0 \
    thunar \
    xz-utils && \
  if [ -z ${UGC_VERSION+x} ]; then \
    UGC_VERSION=$(curl -sX GET "https://api.github.com/repos/ungoogled-software/ungoogled-chromium-portablelinux/releases/latest" \
      | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  curl -o \
    /tmp/ugc.tar.xz -L \
    "https://github.com/ungoogled-software/ungoogled-chromium-portablelinux/releases/download/${UGC_VERSION}/ungoogled-chromium_${UGC_VERSION}_linux.tar.xz" && \
  mkdir -p \
    /opt/ungoogledchromium && \
  tar xf \
    /tmp/ugc.tar.xz -C \
    /opt/ungoogledchromium --strip-components=1 && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /root/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
