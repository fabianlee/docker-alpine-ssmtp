# docker-alpine-ssmtp

Small Alpine image with 'ssmtp' SMTP client utility that can send email with optional attachment.

One use case is for sending email within a CI/CD pipeline, such as gitlab.

## Run ssmtp mail client from CLI

```
# install build tool
sudo apt install -y make

# modify Makefile: MAIL, FROM, TO

# build local docker image
make docker-build

# send text email, then one with binary attachment
make docker-cli-email
make docker-cli-email-att
```

## Run ssmtp mail client from Gitlab pipeline

```
send_email:
  stage: send_email
  retry: 0
  image: ghcr.io/fabianlee/docker-alpine-ssmtp:1.0.2
  script:
    - |
      echo "root=$FROM" > /etc/ssmtp/ssmtp.conf
      echo "mailhub=$MAIL" >> /etc/ssmtp/ssmtp.conf
      echo "FromLineOverride=YES" >> /etc/ssmtp/ssmtp.conf
      echo "UseTLS=false" >> /etc/ssmtp/ssmtp.conf
      echo "Debug=YES" >> /etc/ssmtp/ssmtp.conf
    - |
      echo -e "From: flee@domain.com\nTo: admin@domain.com\nSubject: hello world\n\nthis is the body" | ssmtp admin@domain.com
    #- |
    #  echo -e "From: flee@domain.com\nTo: admin@domain.com\nSubject: hello world\n\nthis is the body" | (cat - && uuencode artifact.pdf attachment.pdf) | ssmtp admin@domain.com
```

## Image built and pushed into Github Container Registry

The [pipeline](.github/workflows/github-actions-buildOCI.yml) builds and pushes this image to the [Github Container Registry](https://github.com/fabianlee/docker-alpine-ssmtp/pkgs/container/docker-alpine-ssmtp).

```
docker pull ghcr.io/fabianlee/docker-alpine-ssmtp:latest
```

## Postfix mail server running on docker

It can be difficult to find an open mail relay to send a test email.  

If you want to run a local mail server on Docker, see [my article here](https://fabianlee.org/2019/10/23/docker-running-a-postfix-container-for-testing-mail-during-development/).

