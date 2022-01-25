Very simple LAMP stack running on Docker containers

Everything is launched or controlled with GNU make.

Run `make help` to list available commands or see commands in the file called Makefile.

The `codebase` directory gets mounted within the containers, put your code there.

You can also put a database there and then run `make shell` to go to the Web container and import the DB.

Lastly, based on your directory structure copy the corresponding Apache Config file. 

There are two main ones, but you can create your own and copy it in the same fashion.

For the average site with a web root folder called ./docroot

`docker cp apache-vhost-configs DockerLAMP_web:/etc/apache2/sites-available/000-default.conf`

For sites hosted on Pantheon with a web root folder called ./web

`docker cp apache-vhost-configs-for-pantheon-sites DockerLAMP_web:/etc/apache2/sites-available/000-default.conf`