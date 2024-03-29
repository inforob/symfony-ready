DOCKER_BE = webserver
DOCKER_DATABASE = database
USER_APP = application

ssh-database:
	@docker-compose exec ${DOCKER_DATABASE} bash
ssh-root:
	@docker-compose exec ${DOCKER_BE} bash
ssh:
	@docker-compose exec ${DOCKER_BE} bash -c "su application"
install:
	@docker-compose exec ${DOCKER_BE} bash -c "/opt/script.sh --url ${APP}"
	@docker-compose exec ${DOCKER_BE} bash -c "chown -R ${USER_APP}:${USER_APP} /var/www/projects/${APP}"
	./webserver/shell/localhost.sh add_host ${APP}
remove:
	@docker-compose exec ${DOCKER_BE} bash -c "/opt/script.sh --remove ${APP}"
	./webserver/shell/localhost.sh remove_host ${APP}
clone:
	@docker-compose exec ${DOCKER_BE} bash -c "/opt/script.sh --clone ${REPOSITORY} ${APP}"
vhost:
	@docker-compose exec ${DOCKER_BE} bash -c "/opt/script.sh --vhost ${APP}"
	./webserver/shell/localhost.sh add_host ${APP}	
run:
	@docker-compose up -d
stop:
	@docker-compose stop
down:
	@docker-compose down
build:
	@docker-compose up -d --build
restart:
	$(MAKE) stop && $(MAKE) run