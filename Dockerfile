#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
FROM python:3.9-slim
LABEL maintainer="Sebastian Goetsch<goetsch@terrestris.de>"

RUN apt-get -y update

#-------------Application Specific Stuff ----------------------------------------------------

RUN apt-get install -y \
    libproj19 \
    python3-pyproj \
    python3-pil \
    python3-yaml \
    libgeos-dev \
    python3-lxml \
    libgdal-dev \
    python3-shapely \
    git

#RUN pip install MapProxy==1.14.0 pyproj uwsgi
RUN pip install pyproj uwsgi
RUN pip install git+https://github.com/ahennr/mapproxy.git@d8a59ffa775c3f541fb795e9c4a313ca8aab28b5

EXPOSE 8080

# ADD uwsgi.conf /uwsgi.conf
COPY uwsgi.*.ini /opt/

ADD start.sh /start.sh
RUN chmod 0755 /start.sh

CMD /start.sh
