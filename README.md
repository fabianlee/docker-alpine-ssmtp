# docker-alpine-ssmtp

Small Alpine image with 'ssmtp' SMTP client utility that can send email with optional attachment.

One use case is for sending email within a CI/CI pipeline, such as gitlab.

## Run ssmtp mail client

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

## Run in Gitlab pipeline

```
send_email:
  stage: send_email
  retry: 0
  image: ghcr.io/fabianlee/docker-alpine-ssmtp:1.0.2
  script:
    - |
      echo "root=this@domain.com" > /etc/ssmtp/ssmtp.conf
      echo "mailhub=" >> /etc/ssmtp/ssmtp.conf
    - |
      echo -e "From: adslj\nSubject: sdlj\n\nThis is test body" | ssmtp to@domain.com
    #- |
    #  echo -e "From: adslj\nSubject: sdlj\n\nThis is test body" | (cat - && uuencode /path/docker-logo.png attachment.png) |ssmtp to@domain.com
```

## Github Container Registry

The [pipeline](.github/workflows/github-actions-buildOCI.yml) builds and pushes this image to the [Github Container Registry](https://github.com/fabianlee/docker-alpine-ssmtp/pkgs/container/docker-alpine-ssmtp).

```
docker pull ghcr.io/fabianlee/docker-alpine-ssmtp:latest
```

## Postfix mail server running on docker

If you want to run a backing mail server on Docker, see [my article here](https://fabianlee.org/2019/10/23/docker-running-a-postfix-container-for-testing-mail-during-development/).

