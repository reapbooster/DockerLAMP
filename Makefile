include .env

default: up

COMPOSER_ROOT ?= /var/www/html
DRUPAL_ROOT ?= /var/www/html/web

## help	:	Print commands help.
.PHONY: help
ifneq (,$(wildcard docker.mk))
help : docker.mk
	@sed -n 's/^##//p' $<
else
help : Makefile
	@sed -n 's/^##//p' $<
endif

## up	:	Start up containers.
.PHONY: up
up:
	@echo "Starting up containers for $(PROJECT_NAME)..."
	docker-compose pull
	docker-compose up -d --remove-orphans
	@printf "\n\nIf this is a fresh launch, run 'make db-init'..."
	@printf "\n\nLoad the DB with: zcat prod-DB_FILENAME.sql.gz | mysql -u drupal -pdrupal -h db drupal"

## down	:	Stop containers.
.PHONY: down
down: stop

## start	:	Start containers without updating.
.PHONY: start
start:
	@echo "Starting containers for $(PROJECT_NAME) from where you left off..."
	@docker-compose start

## stop	:	Stop containers.
.PHONY: stop
stop:
	@echo "Stopping containers for $(PROJECT_NAME)..."
	@docker-compose stop

## prune	:	Remove containers and their volumes.
##		You can optionally pass an argument with the service name to prune single container
##		prune mariadb	: Prune `mariadb` container and remove its volumes.
##		prune mariadb solr	: Prune `mariadb` and `solr` containers and remove their volumes.
.PHONY: prune
prune:
	@echo "Removing containers for $(PROJECT_NAME)..."
	@docker-compose down -v $(filter-out $@,$(MAKECMDGOALS))

## ps	:	List running containers.
.PHONY: ps
ps:
	@docker ps --filter name='$(PROJECT_NAME)*'

## shell	:	Access `web` container via shell.
.PHONY: shell
shell:
	docker exec -ti $(PROJECT_NAME)_web bash

## root-shell        :       Access `web` container via ROOT shell.
.PHONY: root-shell
root-shell:
	docker exec -u0 -ti $(PROJECT_NAME)_web bash
	
## hsa-init	:	Custom INIT tasks specific to a given site.
.PHONY: db-init
hsa-init:
	@echo "Initializing Database and User for $(PROJECT_NAME)..."
	docker exec -it $(PROJECT_NAME)_db bash -c "mysql -u drupal -pdrupal -e \"SELECT * from variable where name like '%memcache%';\" drupal"
	docker exec -it $(PROJECT_NAME)_db bash -c "mysql -u drupal -pdrupal -e \"DELETE FROM variable where name like '%memcache%';\" drupal"
	docker exec -it $(PROJECT_NAME)_db bash -c "mysql -u drupal -pdrupal -e \"SELECT * from variable where name like '%memcache%';\" drupal"
	
## mysql-shell	:	Access `db` container via shell..
.PHONY: mysql-shell
mysql-shell:
	@echo "Initializing Database and User for $(PROJECT_NAME)..."
	docker exec -it $(PROJECT_NAME)_db bash -c "mysql -u drupal -pdrupal drupal"
