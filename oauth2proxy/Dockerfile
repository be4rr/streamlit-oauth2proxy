FROM ubuntu:20.04

ARG CPU_ARCH=amd64
ARG OAUTH2_PROXY_VERSION=7.4.0

RUN set -x && \
  apt update && \
  apt install --no-install-recommends --no-install-suggests -y \
  wget gettext-base ca-certificates

RUN update-ca-certificates

RUN wget https://github.com/oauth2-proxy/oauth2-proxy/releases/download/v${OAUTH2_PROXY_VERSION}/oauth2-proxy-v${OAUTH2_PROXY_VERSION}.linux-${CPU_ARCH}.tar.gz && \
  tar xf oauth2-proxy-v${OAUTH2_PROXY_VERSION}.linux-${CPU_ARCH}.tar.gz -C /usr/local/bin/ --strip-components 1 && \
  rm oauth2-proxy-v${OAUTH2_PROXY_VERSION}.linux-${CPU_ARCH}.tar.gz

COPY ./oauth2proxy/oauth2proxy.conf.template /etc/oauth2proxy.conf.template
COPY ./oauth2proxy/startup.sh /startup.sh

CMD [ "sh", "startup.sh" ]
