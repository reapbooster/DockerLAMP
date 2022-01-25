Very simple LAMP stack running on Docker containers

Everything is launched or controlled with GNU make.

Run `make help` to list available commands or see commands in the file called Makefile.

The `codebase` directory gets mounted within the containers, put your code there.

You can also put a database there and then run `make shell` to go to the Web container and import the DB.
