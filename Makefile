.SILENT:
## Colors
COLOR_RESET   = \033[0m
COLOR_INFO    = \033[32m
COLOR_COMMENT = \033[33m

## Help
help:
	printf "${COLOR_COMMENT}Usage:${COLOR_RESET}\n"
	printf " make [target]\n\n"
	printf "${COLOR_COMMENT}Available targets:${COLOR_RESET}\n"
	awk '/^[a-zA-Z\-\_0-9\.@]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf " ${COLOR_INFO}%-16s${COLOR_RESET} %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

###############
# Environment #
###############

## Setup environment & Install & Build application
permission:
	printf "${COLOR_COMMENT}Change Permission:${COLOR_RESET}\n"
	sudo chown ${USER}:82 app/src -R
	sudo find app/src -type d -exec chmod 775 {} \;
	sudo find app/src -type f -exec chmod 664 {} \;
	sudo chmod u+x app/src/bin/magento
build:
	printf "${COLOR_COMMENT}Build Application Images:${COLOR_RESET}\n"
	docker-compose build
setup:
	printf "${COLOR_COMMENT}Init Docker Containers:${COLOR_RESET}\n"
	docker-compose up
install:
	printf "${COLOR_COMMENT}Install Application:${COLOR_RESET}\n"
	sudo service apache2 stop
	sudo mkdir -p app/src
	sudo chown ${USER}:82 app/composer -R
	$(MAKE) build
	$(MAKE) setup
	$(MAKE) mage_install
	$(MAKE) permission
	$(MAKE) grunt_init
remove:
	printf "${COLOR_COMMENT}Remove Docker Containers:${COLOR_RESET}\n"
	docker-compose stop
	docker-compose rm
start:
	docker-compose start
stop:
	docker-compose stop
restart:
	docker-compose restart
networks:
	printf "${COLOR_COMMENT}Create Docker Networks:${COLOR_RESET}\n"
	docker network create backend_network
	docker network create frontend_network
############
# View Log #
############
log_app:
	docker-compose logs app
log_mysql:
	docker-compose logs mysql
log_server:
	docker-compose logs webserver
log_grunt:
	docker-compose logs grunt

########################
# Magento command line #
########################
add_aliases:
	@echo 'alias docker-log="docker-compose logs"' >> ~/.aliases
	@echo 'alias docker-app="docker-compose exec app"' >> ~/.aliases
	@echo 'alias docker-cli="docker-compose run --rm cli"' >> ~/.aliases
	@echo 'alias docker-mage="docker-compose run --rm cli mage"' >> ~/.aliases
	@echo 'alias docker-grunt="docker-compose exec grunt grunt"' >> ~/.aliases
	# bash use source ~/.bashrc or . ~/.bashrc
	# zsh use source ~/.zshrc or . ~/.zshrc
rm_cache:
	docker-compose exec app rm -rf var/cache
	docker-compose exec app mage cache:cl
	docker-compose exec app mage cache:fl
rm_pagecache:
	docker-compose exec app rm -rf var/page_cache
rm_view:
	docker-compose exec app rm -rf var/view_preprocessed
rm_session:
	docker-compose exec app rm -rf var/session
rm_fullcache:
	$(MAKE) rm_cache
	$(MAKE) rm_pagecache
	$(MAKE) rm_view
	$(MAKE) rm_session
mage_install:
	docker-compose run --rm cli mage-install
mage_di:
	docker-compose exec app mage set:di:com
mage_static:
	docker-compose exec app mage set:static:dep
mage_update:
	docker-compose exec app mage set:up
mage_temp_hint:
	docker-compose exec app mage dev:template-hints
mage_temp_hint_block:
	docker-compose exec app mage dev:template-hints-blocks
mage_check:
	docker-compose exec app mage sys:check
mage_modules:
	docker-compose exec app mage module:status
mage_reindex:
	docker-compose exec app mage indexer:reindex
mage_show_domain:
	printf "${COLOR_COMMENT}Domain unsecure:${COLOR_RESET}"
	docker-compose exec app mage config:show web/unsecure/base_url
	printf "${COLOR_COMMENT}Domain secure:${COLOR_RESET}"
	docker-compose exec app mage config:show web/secure/base_url
#############
# Grunt     #
#############
grunt_init:
	if [ ! -f "app/src/package.json" ]; then \
         cp -f app/src/package.json.sample app/src/package.json ; \
    fi; \
    if [ ! -f "app/src/Gruntfile.js" ]; then \
		 cp app/src/Gruntfile.js.sample app/src/Gruntfile.js ; \
	fi;
	docker-compose run --rm grunt npm install
	docker-compose run --rm grunt npm update
#############
# Backup DB #
#############
db_backup:
	docker-compose exec mysql mysqldump -usonnguyen mage > mage.sql
db_import:
	docker-compose exec mysql mysqldump -usonnguyen mage < mage.sql
