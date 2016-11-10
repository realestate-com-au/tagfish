FROM ruby:2.3.1-alpine@sha256:8d5ca285f1a24ed333aad70cfa54157f77ff130f810c91d566

MAINTAINER Clement Labbe <clement.labbe@rea-group.com>

RUN apk add --update \
    make \
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
