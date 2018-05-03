==================================
# Folder include db backup of website #

Create volume file backup to *mysql* docker container in docker-compose.yml: 
*`./db/{db_name}.sql:/docker-entrypoint-initdb.d/{db_name}.sql`*

Ex:
- './db/mage.sql:/docker-entrypoint-initdb.d/mage.sql'

