==================================

# Magento 2 Docker #

A project running Magento 2 in Docker.

Demo host name: http://mage.demo/

# How to run #

Dependencies:
  * Docker engine v1.13 or higher. Your OS provided package might be a little old, if you encounter problems, do upgrade. See [https://docs.docker.com/engine/installation](https://docs.docker.com/engine/installation)
  * Docker compose v1.12 or higher. See [docs.docker.com/compose/install](https://docs.docker.com/compose/install/)

Please disable apache or nginx if they run in port 80, because project use port 80 for webserver.

Add network for docker in you computer:
    `make networks`  

Once you're done init project,
  - simply `cd` to your project
  - add your own hostname on your `/etc/hosts` "127.0.0.1 mage.demo"
  - and run `make init`.
  - and run `make mage_install`.
  - and run `make grunt_init`.
This will initialise and start all the containers, then leave them running in the background.

## Services exposed outside your environment ##

You can access your application via **`mage.demo`**, if you're running the containers directly,


Service|Address outside containers
------|---------
Webserver|[mage.demo](http://mage.demo)
MySQL|**host:** `localhost`; **port:** `8082`
PHPMyAdmin|[localhost:8181](http://mage.demo:8181)

## Create new virtual host ##
In case you want to use new domain in virtual host `/etc/hosts`
- Add hostname on `/etc/hosts`
- Edit hostname in virtual host on `nginx/conf.d/mage2.conf`
- After init (start) dockers containers run command to change domain:
        `docker-compose exec app mage config:set --scope=default web/unsecure/base_url http://example.com/`
        `docker-compose exec app mage config:set --scope=default web/secure/base_url http://example.com/`
- Remove cache & session : `make rm_fullcache && make rm_session`
- Reset containers : `make restart`

## Hosts within your environment ##

You'll need to configure your application to use any services you enabled:

Service|Hostname|Port number
------|---------|-----------
php-fpm|php-fpm|9000:9000
MySQL|mysql|8082:3306 (default)
PHPMyAdmin|phpmyadmin|8181:80
Nginx|webserver|80:80

Grunt|grunt|

# Docker compose cheatsheet #

**Note:** you need to cd first to where your docker-compose.yml file lives.

  * Start containers in the background: `docker-compose up -d`
  * Start containers on the foreground: `docker-compose up`. You will see a stream of logs for every container running.
  * Stop containers: `docker-compose stop`
  * Kill containers: `docker-compose kill`
  * View container logs: `docker-compose logs`
  * Execute command inside of container: `docker-compose exec SERVICE_NAME COMMAND` where `COMMAND` is whatever you want to run.  
    Examples: \
        * Shell into the PHP container, `docker-compose exec php-fpm bash` \
        * Run symfony console, `docker-compose exec php-fpm bin/console` \
        * Open a mysql shell, `docker-compose exec mysql mysql -uroot -pCHOSEN_ROOT_PASSWORD` \
  * Use Composer :
      `docker-compose exec app composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition .`
      `docker-compose exec app composer install`
# Recommendations #

# Use Grunt #
We need init grunt for project, in *`app\src`* you need 2 file package.json, Gruntfile.js \
Run command to init grunt : `make grunt_init` \
Some command for grunt:
- `docker-compose run --rm grunt {command}`
- `docker-compose run --rm grunt grunt -V`
- `docker-compose run --rm grunt grunt npm install`
- `docker-compose run --rm grunt grunt npm update`
- `docker-compose run --rm grunt grunt grunt clean:{theme}`
- `docker-compose run --rm grunt grunt grunt clean:blank`
- `docker-compose run --rm grunt grunt grunt exec:{theme}`
- `docker-compose run --rm grunt grunt grunt exec:blank`
- `docker-compose run --rm grunt grunt grunt less:{theme}`
- `docker-compose run --rm grunt grunt grunt less:blank`
- `docker-compose run --rm grunt grunt grunt watch`

# Setting XDebug #

# Setting PHP CLI #
CLI help running command of project

# Use N98 #
- `docker-compose run -rm cli mage`
- `docker-compose run -rm cli mage sys:check`

# Use Makefile #
Makefile help we summarize some common commands, please view Makefile for clean more.

# Create aliases #
We have a lot of aliases to run command for docker compose
- `make add_aliases`

# Next version #
    - Php cron
    - Redis Cache
    - Elastic Search
    - Muliple Stores
