# Simple Docker LAMP
Everything is launched or controlled with GNU make.

## ;TLDR;

1. Run `make help` to list available commands

2. Edit the .env file, give your project a name

3. On .env: Select the propper APACHE_CONFIG edit it if needed

4. Put your code, DB and media files in `/codebase` , it gets mounted within all the containers under `/var/www/html`

5. Run `make up`. If it runs without errors, you now have 3 containers **web, db and node**.

6. Running `make shell` will get you a terminal shell into the **web** container.

7. Within the **web** container, import the DB: `zcat prod-DB_FILENAME.sql.gz | mysql -u drupal -pdrupal -h db drupal`

## Some helpful commands, run `make help` to verify they still are accurate:

 help           :       Print commands help.
 
 up             :       Pull new images and start up containers (won't prune old ones).
 
 down           :       Stop containers (won't prune).
 
 start          :       Start existing containers without updating.
 
 stop           :       Stop containers (won't prune).
 
 prune          :       Remove containers and their volumes (DB will be lost!).

                        You can optionally pass an argument with the service name to prune single container

                        prune mariadb   : Prune `mariadb` container and remove its volumes.

                        prune mariadb solr      : Prune `mariadb` and `solr` containers and remove their volumes.

 ps             :       List running containers.

 shell          :       Access `web` container via shell.

 shell-node     :       Access `node` container via shell..

 shell-db       :       Access `db` container via shell..

 root-shell-web :       Access `web` container via ROOT shell.
 