# Mapproxy Dockerfile

This will build a [docker](http://www.docker.com/) image that runs [mapproxy
](http://mapproxy.org).

## Getting the image

```
docker pull terrestris/mapproxy
```

To build the image yourself do:

```
docker build -t terrestris/mapproxy git://github.com/terrestris/docker-mapproxy
```

# Run

To run a mapproxy container do:

```
docker run --name "mapproxy" -p 8080:8080 -d -t \
     terrestris/mapproxy
```

Typically you will want to mount the mapproxy volume, otherwise you won't be
able to edit the configs:

```
mkdir mapproxy
docker run --name "mapproxy" -p 8080:8080 -d -t -v \
   `pwd`/mapproxy:/mapproxy terrestris/mapproxy
```

The first time your run the container, mapproxy basic default configuration
files will be written into ``./mapproxy``. You should read the mapproxy documentation
on how to configure these files and create appropriate definitions for
your services. Then restart the container to activate your changes.

The cached tiles will be written to ``./mapproxy/cache_data``.

**Note** that the mapproxy containerised application will run as the user that
owns the /mapproxy folder.

# Reverse proxy

The mapproxy container 'speaks' ``uwsgi`` so you need to put e.g. nginx in front of it
(try the ``nginx docker container``). Here is a sample configuration (via linked
containers) that will forward traffic into the uwsgi container.

```
upstream mapproxy {
    server mapproxy:8080;
}
server {
    listen 80;

    root /var/www/html/;

    location /mapproxy/ {
        rewrite /mapproxy/(.+) /$1 break;
        uwsgi_param SCRIPT_NAME /mapproxy;
        uwsgi_pass mapproxy;
        include uwsgi_params;
    }
}
```

Here is an example configuration on how to use this image together with an nginx docker via docker-compose:

```
version: '3'
services:
  nginx:
    image: nginx
    hostname: nginx
    ports:
     - 80:80
    volumes:
      - ./nginx-example.conf:/etc/nginx/conf.d/default.conf
    depends_on:
      - mapproxy
    links:
    - mapproxy:mapproxy
  mapproxy:
    image: terrestris/mapproxy:latest
    hostname: mapproxy
    volumes:
      - ./mapproxy:/mapproxy
```

Once the containers are up and running you can open the mapproxy demo page by visiting

```
http://localhost/mapproxy/demo/
```
