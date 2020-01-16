#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
FROM python:3.7-slim
LABEL maintainer="Sebastian Goetsch<goetsch@terrestris.de>"

RUN apt-get -y update

#-------------Application Specific Stuff ----------------------------------------------------

RUN apt-get install -y \
    libproj13 \
    libgeos-dev \
    python-lxml \
    libgdal-dev
RUN pip install MapProxy==1.12.0 uwsgi

EXPOSE 8080

ADD uwsgi.conf /uwsgi.conf

ADD start.sh /start.sh
RUN chmod 0755 /start.sh

#USER www-data
# Now launch mappproxy in the foreground
# The script will create a simple config in /mapproxy
# if one does not exist. Typically you should mount 
# /mapproxy as a volume
CMD /start.sh
