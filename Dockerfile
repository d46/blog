FROM alpine
MAINTAINER Daghan Gunay <daghangunay@gmail.com>

RUN apk --no-cache add \
	ca-certificates \
	curl \
	tar

ENV HUGO_VERSION 0.32.4
RUN curl -sSL https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz | tar -v -C /usr/local/bin -xz --strip-components 1 && \
	mv /usr/local/bin/hugo_${HUGO_VERSION}_Linux-64bit /usr/local/bin/hugo

WORKDIR /usr/src/blog/

# add files
COPY . /usr/src/blog/

CMD [ "./release.sh" ]
