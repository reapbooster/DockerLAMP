include .env

default: up

COMPOSER_ROOT ?= /var/www/html
DRUPAL_ROOT ?= /var/www/html/web

## help		:	Print commands help.
.PHONY: help
ifneq (,$(wildcard docker.mk))
help : docker.mk
	@sed -n 's/^##//p' $<
else
help : Makefile
	@sed -n 's/^##//p' $<
endif

## up		:	Pull new images and start up containers (won't prune old ones).
.PHONY: up
up:
	@echo "Starting up containers for $(PROJECT_NAME)..."
	docker-compose pull
	docker-compose up -d --remove-orphans
	@printf "\n\nIf this is a fresh launch, run 'make db-init'..."
	@printf "\n\nLoad the DB with: zcat prod-DB_FILENAME.sql.gz | mysql -u drupal -pdrupal -h db drupal"

## down		:	Stop containers (won't prune).
.PHONY: down
down: stop

## start		:	Start existing containers without updating.
.PHONY: start
start:
	@echo "Starting containers for $(PROJECT_NAME) from where you left off..."
	@docker-compose start

## stop		:	Stop containers (won't prune).
.PHONY: stop
stop:
	@echo "Stopping containers for $(PROJECT_NAME)..."
	@docker-compose stop

## prune		:	Remove containers and their volumes (DB will be lost!).
##			You can optionally pass an argument with the service name to prune single container
##			prune mariadb	: Prune `mariadb` container and remove its volumes.
##			prune mariadb solr	: Prune `mariadb` and `solr` containers and remove their volumes.
.PHONY: prune
prune:
	@echo "Removing containers for $(PROJECT_NAME)..."
	@docker-compose down -v $(filter-out $@,$(MAKECMDGOALS))

## ps		:	List running containers.
.PHONY: ps
ps:
	@docker ps --filter name='$(PROJECT_NAME)*'

## shell		:	Access `web` container via shell.
.PHONY: shell
shell:
	docker exec -ti $(PROJECT_NAME)_web bash

## shell-node	:	Access `node` container via shell..
.PHONY: shell-node
shell-node:
	docker exec -it $(PROJECT_NAME)_node bash

## shell-db	:	Access `db` container via shell..
.PHONY: shell-db
shell-db:
	docker exec -it $(PROJECT_NAME)_db bash -c "mysql -u $(MYSQL_USER) -p$(MYSQL_PW) $(MYSQL_DB)"

## root-shell-web	:       Access `web` container via ROOT shell.
.PHONY: root-shell-web
root-shell-web:
	docker exec -u0 -ti $(PROJECT_NAME)_web bash
	
## hsa-init	:	Custom INIT tasks specific to a given site.
.PHONY: db-init
hsa-init:
	@echo "Initializing Database and User for $(PROJECT_NAME)..."
	docker exec -it $(PROJECT_NAME)_db bash -c "mysql -u drupal -pdrupal -e \"SELECT * from variable where name like '%memcache%';\" drupal"
	docker exec -it $(PROJECT_NAME)_db bash -c "mysql -u drupal -pdrupal -e \"DELETE FROM variable where name like '%memcache%';\" drupal"
	docker exec -it $(PROJECT_NAME)_db bash -c "mysql -u drupal -pdrupal -e \"SELECT * from variable where name like '%memcache%';\" drupal"
	