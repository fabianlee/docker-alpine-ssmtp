OWNER := fabianlee
PROJECT := docker-alpine-ssmtp
VERSION := 1.0.0
OPV := ${OWNER}/${PROJECT}:${VERSION}
SHELL := bash

# you may need to change to "sudo docker" if not a member of 'docker' group
# add user to docker group: sudo usermod -aG docker $USER
DOCKERCMD := docker

BUILD_TIME := $(shell date -u '+%Y-%m-%d_%H:%M:%S')
# unique id from last git commit
MY_GITREF := $(shell git rev-parse --short HEAD)

# values for sending test email
MAIL := 192.168.2.216
FROM := flee@domain.com
TO := admin@domain.com
SUBJECT := my subject
ATTACHMENT := docker-logo.png

## builds docker image
docker-build:
	@echo MY_GITREF is $(MY_GITREF)
	$(DOCKERCMD) build -f Dockerfile -t $(OPV) .

## cleans docker image
clean:
	$(DOCKERCMD) image rm $(OPV) | true

## runs container in foreground, testing a couple of override values
docker-run-fg:
	$(DOCKERCMD) run -it --network host --rm $(OPV)

## runs container in foreground, override entrypoint to use use shell
docker-debug:
	$(DOCKERCMD) run -it --rm --entrypoint "/bin/sh" $(OPV)

## run container in background
docker-run-bg:
	$(DOCKERCMD) run -d --network host --rm --name $(PROJECT) $(OPV)

## get into console of container running in background
docker-cli-bg:
	$(DOCKERCMD) exec -it $(PROJECT) /bin/sh

## send text email
docker-cli-email:
	## create template of commands to run inside container
	MAIL=$(MAIL) FROM=$(FROM) SUBJECT='$(SUBJECT)' TO=$(TO) envsubst<assets/message-plain.sh > /tmp/message-plain.sh
	## run in background then use exec to run commands inside container
	$(DOCKERCMD) run -d --rm --name myclient $(OPV) watch "date >>/var/log/date.log"
	docker exec -i myclient /bin/sh < /tmp/message-plain.sh
	## cleanup
	$(DOCKERCMD) stop myclient | true

## send email with attachment
docker-cli-email-att:
	## create template of commands to run inside container
	MAIL=$(MAIL) FROM=$(FROM) SUBJECT='$(SUBJECT)' TO=$(TO) envsubst<assets/message-attachment.sh > /tmp/message-attachment.sh
	## run in background then use exec to run commands inside container
	$(DOCKERCMD) run -d --rm --name myclient $(OPV) watch "date >>/var/log/date.log"
	## copy binary attachment into image
	docker cp assets/$(ATTACHMENT) myclient:/$(ATTACHMENT)
	docker exec -i myclient /bin/sh < /tmp/message-attachment.sh
	## cleanup
	$(DOCKERCMD) stop myclient | true

## tails logs
docker-logs:
	$(DOCKERCMD) logs -f $(PROJECT)

## stops container running in background
docker-stop:
	$(DOCKERCMD) stop $(PROJECT)

## pushes to hub
docker-push:
	$(DOCKERCMD) push $(OPV)
