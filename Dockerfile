FROM alpine:edge
MAINTAINER Clement Labbe <clement.labbe@rea-group.com>

RUN apk add --update ruby=2.2.3-r1 \
    ruby-dev=2.2.3-r1 \
    ruby-io-console=2.2.3-r1 \
    diffutils \
    linux-headers \
    build-base \
    ca-certificates=20150426-r3 && \
    rm /var/cache/apk/* && \
    rm -rf /usr/share/ri

RUN echo -e 'gem: --no-rdoc --no-ri' > /etc/gemrc \
    gem update --system 2.4.8 && \
    gem install bundler -v 1.10.6 && \
    rm -rf /usr/share/ri

COPY pkg/tagfish-latest.gem /cwd/
WORKDIR /cwd
RUN gem install tagfish-latest.gem

ENTRYPOINT ["tagfish"]
