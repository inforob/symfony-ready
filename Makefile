DOCKER_BE = webserver
DOCKER_DATABASE = database
USER_APP = application
MAIL_APP = mail

mail:
	@docker-compose exec ${MAIL_APP} bash -c "su root"
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

generate-ssh-keys:
	@docker-compose exec ${DOCKER_BE} bash -c "mkdir -p /var/www/projects/${APP}/config/jwt"
	@docker-compose exec ${DOCKER_BE} bash -c "openssl genrsa -passout pass:c5ed41c3b057fac9ceb9647aa78db200 -out /var/www/projects/${APP}/config/jwt/private.pem -aes256 4096"
	@docker-compose exec ${DOCKER_BE} bash -c "openssl rsa -pubout -passin pass:c5ed41c3b057fac9ceb9647aa78db200 -in /var/www/projects/${APP}/config/jwt/private.pem -out /var/www/projects/${APP}/config/jwt/public.pem"
