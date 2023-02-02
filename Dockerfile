FROM alpine:3.17.1

# latest certs
RUN apk add ca-certificates && update-ca-certificates

# timezone support
ENV TZ=UTC
RUN apk add --update tzdata &&\
    cp /usr/share/zoneinfo/${TZ} /etc/localtime &&\
    echo $TZ > /etc/timezone

# install ssmtp client
RUN apk add --no-cache curl mutt ssmtp bash

# writeable ssmtp conf file
RUN mkdir -p /etc/ssmtp; touch /etc/ssmtp/ssmtp.conf; chmod 666 /etc/ssmtp/ssmtp.conf

RUN addgroup -S mygroup && adduser -S myuser -G mygroup
USER myuser

# if debugging
#ENTRYPOINT [ "/bin/sh" ]
