FROM ruby:2.3-alpine@sha256:f67176f154d709747aee8ba2447bcd35403b7368d3e628466c45fa59ce69dbb1

MAINTAINER Clement Labbe <clement.labbe@rea-group.com>

RUN apk add --update \
    diffutils \
    ca-certificates && \
    rm /var/cache/apk/* && \
    rm -rf /usr/share/ri

COPY pkg/tagfish-latest.gem /cwd/
WORKDIR /cwd

RUN echo -e 'gem: --no-rdoc --no-ri' > /etc/gemrc
RUN gem install tagfish-latest.gem
RUN mkdir -p /root/.docker

ENTRYPOINT ["tagfish"]
