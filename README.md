# docker-alpine-ssmtp

Small Alpine image with 'ssmtp' SMTP client utility installed that can send email with optional attachment.

One use case is for sending email within a CI/CI pipeline, such as gitlab.

## Postfix mail server running on docker

If you want to run a simple mail server on Docker, see [my article here](https://fabianlee.org/2019/10/23/docker-running-a-postfix-container-for-testing-mail-during-development/).

## Github Container Registry

The [pipeline](.github/workflows/github-actions-buildOCI.yml) builds and pushes this image to the [Github Container Registry](https://github.com/fabianlee/docker-alpine-ssmtp/pkgs/container/docker-alpine-ssmtp).

```
docker pull ghcr.io/fabianlee/docker-alpine-ssmtp:latest
```
